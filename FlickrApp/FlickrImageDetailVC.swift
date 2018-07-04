//
//  FlickrImageDetailVC.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 27/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  Control the view that present one image loaded from the Flickr API with Large size
//

import UIKit

class FlickrImageDetailVC: UIViewController {

    
    @IBOutlet weak var image: CustomImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIView!
    
    var imageToDisplay: Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        imageView.isUserInteractionEnabled = false
        showImage()
    }
    
    // Show the received image
    private func showImage() {

        if ((imageToDisplay?.urls == nil) ||
            ((imageToDisplay?.urls?.count)! == 0) ||
            (imageToDisplay?.urls?[ImageSize.Large] == nil)) {
            
                self.image.image = UIImage(named: "notFoundImage.png")
                self.image.contentMode = .center
            
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                    self.imageView.isUserInteractionEnabled = true
                }
            
        } else {
           
            DispatchQueue.main.async(execute: {
                self.image.loadImage(fromUrlString: (self.imageToDisplay?.urls?[ImageSize.Large])!)
                self.image.contentMode = .scaleAspectFit
                
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                    self.imageView.isUserInteractionEnabled = true
                }
                
            })

        }

    }
    
    // Load infos getting from the parent view
    func loadDetail(forImage image: Image?) {
        self.imageToDisplay = image
        self.navigationItem.title = image?.tag
    }
    
}

