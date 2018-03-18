//
//  BlogAppTests.swift
//  BlogAppTests
//
//  Created by Bohdan Orlov on 17/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import XCTest
import Platform
import PlatformTestsSupport
import Domain
import DomainTestsSupport
import UI
import UITestsSupport
import BlogApp

class BlogAppTests: XCTestCase {  // This is a place for unit tests of BlogApp. End-to-end functional tests can be here or in an additional test target (preffered)
    
    override func setUp() {
        _ = Platform()
        _ = FakePlatform()
        _ = Domain()
        _ = FakeDomain()
        _ = UI()
        _ = FakeUI()
        super.setUp()
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
