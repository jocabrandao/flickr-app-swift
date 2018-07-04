//
//  FlickrAppUITests.swift
//  FlickrAppUITests
//
//  Created by João Carlos Brandão on 26/08/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//
//  UI test for Flickr implementation app screen
//

import XCTest

class FlickrAppUITests: XCTestCase {
    
    let app = XCUIApplication() // Getting access to the app
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test simulating a user's navigation
    func testLoadApp() {
        
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.tap()
        app.navigationBars["kitten"].buttons["Back"].tap()
        app.navigationBars["FlickrApp.FlickrImagesVC"].buttons["customRefresh"].tap()

    }
    
}
