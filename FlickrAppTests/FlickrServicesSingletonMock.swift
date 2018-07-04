//
//  FlickrServiceMock.swift
//  FlickrApp
//
//  Created by João Carlos Brandão on 26/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//

import Foundation
@testable import FlickrApp

class FlickrServicesSingletonMock: NSObject {

    var instance: FlickrServices
    
    init(sharedInstance: FlickrServices) {
        self.instance = sharedInstance
    }
    
    func mockSingletonLoadImages(withTag tag: String, fromPage page: Int, completion: @escaping ([Image]?) -> Void) {
        self.instance.loadImages(withTag: tag, fromPage: page) { (lstImages) in
            completion(lstImages)
        }
    }
    
}
