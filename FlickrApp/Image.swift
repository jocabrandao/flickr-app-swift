//
//  Image.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 27/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  Structure to hold informations from the image loaded
//

import Foundation

struct Image {
    
    private(set) public var id: String
    private(set) public var tag: String
    private(set) public var urls: [ImageSize: String]?
    
    init(withId id: String, forTag tag: String) {
        self.id = id
        self.tag = tag
    }
    
    mutating func setUrls(urls: [ImageSize: String]) {
        self.urls = urls
    }
}
