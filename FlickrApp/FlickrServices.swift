//
//  FlickrServices.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 26/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  This is an interface services for Flickr API.
//  We use this to get images from there services and to ensure communication security between the application
//  and the service, this class configure a pinning certificate to Alamofire Session Manager.
//

import Foundation
import Alamofire
import SwiftyJSON

class FlickrServices {

    /// Initialize a Session Manager as default, but it will be changed if certificate was pinning successfully
    var afManager = Alamofire.SessionManager.default
    
    /// Singleton class definition
    static let instance = FlickrServices()
    
    /// Default initialization pinning the certificate to communicate with Flickr API services
    private init() {
        pinningCertificate()
    }

    /// Pinning the "FlickrAPICert.der" to use them to do requests from Alamofire through Session Manager.
    fileprivate func pinningCertificate() {
        
        /// Set up certificate
        let pathToCert = Bundle.main.path(forResource: FLICKR_CERTIFICATE, ofType: "der")
        let localCert = NSData(contentsOfFile: pathToCert!)
        let certificates = [SecCertificateCreateWithData(nil, localCert!)!]
        
        /// Configure the trust policy manager
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: certificates,
            validateCertificateChain: true,
            validateHost: true)
        
        let serverTrustPolicies = ["hostname": serverTrustPolicy]
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        
        /// Configure the session manager with trust policy manager
        afManager = SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: serverTrustPolicyManager)
        
    }
    
    
    /// Build the service url for images search.
    ///
    /// - Returns: url to the service, but, you have to provide more than parameters: "tags" and "page" to perform the search.
    fileprivate func getFlickrImagesSearchEndpoint() -> String {
        let url = "\(FLICKR_API_SERVICES)&method=\(FLICKR_SEARCH_SERVICE_ENDPOINT)&api_key=\(FLICKR_API_KEY)"
        return url
    }
    
    /// Build the service url for images sizes search.
    ///
    /// - Returns: url to the service, but, you have to provide more than parameters: "tags" and "page" to perform the search.
    fileprivate func getFlickrImageSizesEndpoint() -> String {
        let url = "\(FLICKR_API_SERVICES)&method=\(FLICKR_LIST_SIZES_ENDPOINT)&api_key=\(FLICKR_API_KEY)"
        return url
    }
    
    /// Load all images from the services provided through the Flickr API that was segmented by other private methods of the class
    ///
    /// - Parameters:
    ///   - tag: define the search criteria
    ///   - page: define the page number to load
    ///   - completion: return as an closure a list of Image objects
    func loadImages(withTag tag: String, fromPage page: Int, completion: @escaping ([Image]?) -> Void) {

        // Load all available images for the tag from the indicated page number
        getListImagesId(withTag: tag, fromPage: page) { (lstImageIds) in
            
            // Load all available image sizes for the images id received
            self.getListImageSizes(forImages: lstImageIds!, withSizes: [ImageSize.Large, ImageSize.LargeSquare], completion: { (lstImageSizes) in
                completion(lstImageSizes)
            })
            
        }
    }
    

    /// Load all images ids disponible from an specific tag and page
    ///
    /// - Parameters:
    ///   - tag: define the search criteria
    ///   - page: define the page number to load
    ///   - completion: return as an closure a list of Image objects
    fileprivate func getListImagesId(withTag tag: String, fromPage page: Int, completion: @escaping ([Image]?) -> Void) {
        
        // Get all images from the current page
        let serviceURL = getFlickrImagesSearchEndpoint()
        let parameters: Parameters = ["tags" : tag, "page" : page]
        
        // Load images from the service API as async request
        afManager.request(serviceURL, method: .get, parameters: parameters)
            .validate()
            .responseJSON { (response) in
                    
                guard response.result.isSuccess else {
                    debugPrint("Error while fetching remote images: \(response.result.error ?? "Undefined error" as! Error)")
                    completion(nil)
                    return
                }
                
                guard
                    let value = response.result.value as? [String : Any],
                    let photos = value["photos"] as? [String : Any],
                    let _ = photos["photo"] as? [[String : Any]] else {
                        debugPrint("Malformed data received from \(serviceURL) service.")
                        completion(nil)
                        return
                }
                
                let lstImages = self.loadImages(tag: tag, json: JSON(response.result.value!))
                completion(lstImages)
                
        }
    }
    
    
    /// Json response parser to build an list of Image objects
    ///
    /// - Parameters:
    ///   - tag: define the search criteria requested
    ///   - json: response json structure
    /// - Returns: list of Image objects
    fileprivate func loadImages(tag: String, json: JSON) -> [Image] {
        var lstImages = [Image]()
        
        for (key, value):(String, JSON) in json {
            if key == "photos" {
                for (_, obj):(String, JSON) in value["photo"] {
                    lstImages.append(Image(withId: obj["id"].stringValue, forTag: tag))
                }
            }
        }
        return lstImages
    }
   
    
    /// Load all images sizes from an specific image id
    ///
    /// - Parameters:
    ///   - images: list of Image objects
    ///   - sizes: list of ImageSize types
    ///   - completion: return as an closure a list of Image objects updated
    fileprivate func getListImageSizes(forImages images: [Image], withSizes sizes: [ImageSize], completion: @escaping ([Image]?) -> Void) {
        
        // Get all images size options from image
        let serviceURL = getFlickrImageSizesEndpoint()
        var listOfImages = [Image]()
        
        let reqGroup = DispatchGroup()
        
        for img in images {
            
            reqGroup.enter()
            
            let parameters: Parameters = ["photo_id" : img.id]
            
            // Load image sizes from the service API as async request
            afManager.request(serviceURL, method: .get, parameters: parameters)
                .validate()
                .responseJSON { (response) in
                    
                    guard response.result.isSuccess else {
                        debugPrint("Error while fetching remote image sizes: \(response.result.error ?? "Undefined error" as! Error )")
                        completion(nil)
                        return
                    }
                    
                    guard
                        let value = response.result.value as? [String : Any],
                        let lstImgSizes = value["sizes"] as? [String : Any],
                        let _ = lstImgSizes["size"] as? [[String : Any]] else {
                            debugPrint("Malformed data received from \(serviceURL) service.")
                            completion(nil)
                            return
                    }
                    
                    var newImg = img
                    newImg.setUrls(urls: self.findImageSizes(sizes: sizes, json: JSON(response.result.value!)))
                    listOfImages.append(newImg)
                    
                    reqGroup.leave()
            }
        }
        
        reqGroup.notify(queue: DispatchQueue.main) {
            completion(listOfImages)
        }
    }
    
    /// Json response parser to build an list of Image objects updated
    ///
    /// - Parameters:
    ///   - sizes: list of ImageSize types
    ///   - json: response json structure
    /// - Returns: list of Image objects
    fileprivate func findImageSizes(sizes: [ImageSize], json: JSON) -> [ImageSize : String] {
        var lstSizes = [String]()
        var lstImages = [ImageSize : String]()
        
        for imgSize in sizes {
            lstSizes.append(imgSize.rawValue)
        }
        
        for (key, value) : (String, JSON) in json {
            if key == "sizes" {
                for (_, obj) : (String, JSON) in value["size"] {
                    if (lstSizes.contains(obj["label"].stringValue)) {
                        lstImages[ImageSize(rawValue: obj["label"].stringValue)!] = obj["source"].stringValue
                    }
                }
            }
        }
        return lstImages
    }
    
}
