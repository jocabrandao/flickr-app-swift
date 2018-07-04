//
//  PicturePanelView.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 27/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  Custom view with rounded corner
//

import UIKit

@IBDesignable class CustomPanelView: UIView {

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
