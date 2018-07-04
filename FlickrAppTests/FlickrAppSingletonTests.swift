//
//  FlickrAppTests.swift
//  FlickrAppTests
//
//  Created by João Carlos Brandão on 26/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  Unit test for Flickr implementation services API
//

import XCTest
@testable import FlickrApp

class FlickrAppSingletonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test if when the service was call, we get success return with data
    func testImagesHasLoaded() {
            
        let exp = self.expectation(description: "Expecting asynchronous data call to fail.")
        
        let fs = FlickrServicesSingletonMock(sharedInstance: FlickrServices.instance)
        fs.mockSingletonLoadImages(withTag: FLICKR_DEFAULT_TAG, fromPage: 1) { (lstImages) in
            if (lstImages == nil) {
                XCTFail()
            } else {
                XCTAssertGreaterThan(lstImages!.count, 0)
                exp.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 8, handler: nil)
        
    }
    
     // Test if when the service was call, we get success return without data
    func testImagesNotFound() {
        let brokenTag = "2qszxaw1!@#$%"
        
        let exp = expectation(description: "Expecting asynchronous data call to fail.")
        
        let fs = FlickrServicesSingletonMock(sharedInstance: FlickrServices.instance)
        fs.mockSingletonLoadImages(withTag: brokenTag, fromPage: 1) { (lstImages) in
            if (lstImages == nil) {
                XCTFail()
            } else {
                XCTAssertEqual(lstImages!.count, 0)
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
