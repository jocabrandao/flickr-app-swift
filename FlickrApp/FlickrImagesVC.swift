//
//  ViewController.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 26/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  Control the view that present all images loaded from the Flickr API
//

import UIKit

class FlickrImagesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var searchedTag: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var lstImages = [Image]()
    fileprivate var indexOfPageRequest = 1
    fileprivate var imageLoadingStatus = false
    fileprivate var lastIndexPath = 0
    fileprivate let reuseCellIdentifier = "ImageCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 8.0)
    fileprivate let flickrImageDetailVC = "FlickrImageDetailVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        imagesCollection.isUserInteractionEnabled = false
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        loadImages()
    }
    
    @IBAction func btnReloadTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        imagesCollection.isUserInteractionEnabled = false
        lstImages = [Image]()
        indexOfPageRequest = 1
        imageLoadingStatus = false
        lastIndexPath = 0
        loadImages()
    }
    
    
    /// Load all images from the services provided through the Flickr API
    func loadImages() {
        
        if !imageLoadingStatus {
            imageLoadingStatus = true
            searchedTag.text = FLICKR_DEFAULT_TAG
            FlickrServices.instance.loadImages(withTag: FLICKR_DEFAULT_TAG, fromPage: indexOfPageRequest) { (rImages) in

                for img in rImages! {
                    self.lstImages.append(img)
                }
                
                DispatchQueue.main.async(execute: {
                    if self.imageLoadingStatus && self.activityIndicator.isAnimating {
                        self.activityIndicator.stopAnimating()
                        self.imagesCollection.isUserInteractionEnabled = true
                    }
                    
                    self.imageLoadingStatus = false
                    self.imagesCollection.reloadData()
                })
                
            }
        }

    }
    
    // Control the changes on the scroll to do paging
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!imageLoadingStatus && ((lstImages.count - 12) <= lastIndexPath)) {
            indexOfPageRequest += 1
            loadImages()
        }
        
    }
    
    // Define sizes for images that will hold by collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow : CGFloat = 2
        let availableWidth = imagesCollection.frame.width
        let widthPerItem = ((availableWidth/itemsPerRow) - (sectionInsets.left * itemsPerRow))

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // Define edges for the images that will hold by collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Define minimum space between the images that will hold by collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // Define the number of items to show in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstImages.count
    }
    
    // Build an image cell to show in the collection view index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = imagesCollection.dequeueReusableCell(
            withReuseIdentifier: reuseCellIdentifier,
            for: indexPath) as? CustomImageViewCell {
            
            let image = lstImages[indexPath.row]
            cell.updateViews(image: image)
            
            lastIndexPath = indexPath.row
            
            return cell
            
        }
        
        return CustomImageViewCell()
        
    }
    
    // Monitoring when one image was tapped to call the image detail view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = lstImages[indexPath.row]
        performSegue(withIdentifier: flickrImageDetailVC, sender: image)
    }
    
    // Prepare data to send to the destination view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if let flickrImageDetailVC = segue.destination as? FlickrImageDetailVC {
            
            let barButton = UIBarButtonItem()
            barButton.title = ""
            navigationItem.backBarButtonItem = barButton
            
            flickrImageDetailVC.loadDetail(forImage: (sender as! Image))

        }
        
    }

}

