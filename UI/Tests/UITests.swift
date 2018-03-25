//
//  UITests.swift
//  UITests
//
//  Created by Bohdan Orlov on 17/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import XCTest
import Core
import CoreTestsSupport
import UI
import UITestsSupport

class UITests: XCTestCase {
    
    override func setUp() { // This is a framework UI's visual regression and unit tests
        super.setUp()
        _ = Core()
        _ = FakeCore()
        _ = UI()
        _ = FakeUI()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
