//
//  XplorerTests.swift
//  XplorerTests
//
//  Created by Devan Dutta on 11/11/17.
//  Copyright © 2017 devan.dutta. All rights reserved.
//

import UIKit
import XCTest
@testable import Xplorer

class XplorerTests: XCTestCase {
    
    // Properties
    var systemUnderTest:TimeAndLocationViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "timeAndLocation") as! TimeAndLocationViewController
        // run view did load
        _ = systemUnderTest.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeAndLocationViewIsNotNilAfterViewDidLoad(){
        XCTAssertNotNil(systemUnderTest.view)
    }
    
    
    func testStartLocationNotNilAfterViewDidLoad(){
        XCTAssertNotNil(systemUnderTest.startLocation)
    }
    
    // TODO: test start location is set when AutoCompleteViewController is called
    // TODO: test end location is set
    
    
}
