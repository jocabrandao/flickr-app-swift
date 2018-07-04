//
//  Constants.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 26/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  File to hold all constants from the project

import Foundation

// Certification Pinning
let FLICKR_HOST_NAME = "https://api.flickr.com"
let FLICKR_CERTIFICATE = "FlickrAPICert"

// API Configurations
let FLICKR_API_KEY = "SEU-CODIGO-DE-API"
let FLICKR_API_SERVICES = "\(FLICKR_HOST_NAME)/services/rest/?format=json&nojsoncallback=1"

// Default Settings
let FLICKR_DEFAULT_TAG = "kitten"
let FLICKR_DEFAULT_IMAGE_TILES = ImageSize.LargeSquare.rawValue

// API Endpoints
let FLICKR_SEARCH_SERVICE_ENDPOINT = "flickr.photos.search"
let FLICKR_LIST_SIZES_ENDPOINT = "flickr.photos.getSizes"
