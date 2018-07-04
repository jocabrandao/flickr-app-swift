//
//  ImageCellCollectionViewCell.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 27/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  Custom view with rounded corner that show an image in an collection view cell
//

import UIKit

class CustomImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: CustomImageView!
    
    // Update the image view with an received image data
    func updateViews(image: Image) {
        
        if ((image.urls == nil) ||
            ((image.urls?.count)! == 0) ||
            (image.urls?[ImageSize.LargeSquare] == nil)) {
            
            self.image.image = UIImage(named: "offlineImage.png")
            self.image.contentMode = .center
            
        } else {
            
            self.image.loadImage(fromUrlString: (image.urls?[ImageSize.LargeSquare])!)
            self.image.contentMode = .scaleAspectFit
            
        }

    }
    
    // Config the view options
    private func setupView() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
}
