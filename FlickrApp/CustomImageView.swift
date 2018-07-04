//
//  CustomImageView.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 29/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  Custom image view to load and cache images from an URL address
//

import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    fileprivate var imageUrlString: String?
    
    // Load and cache images from an URL address
    func loadImage(fromUrlString urlString: String) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else {
            debugPrint("Error: cannot create URL.")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        image = nil // Prevent load image error when use in reusable cell.
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        let _ = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                debugPrint(error ?? "An unknown error has occurred.")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                
            })
            
        }).resume()
        
    }
}
