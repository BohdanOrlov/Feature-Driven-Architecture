//
//  RestartPushNotificationFlowTests.swift
//  BlogAppTests
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import XCTest
import Foundation
import Core
import CoreTestsSupport
import Domain
import DomainTestsSupport
import UI
import UITestsSupport
@testable import BlogApp
import BlogAppTestsSupport

class RestartPushNotificationFlowTests: XCTestCase {
    
    func test_GivenMockedLauncher_WhenFlowStarted_ThenShowSendPushNotificationButtonCalled() {
        stubAllLaunchers()
        var called = false
        RestartPushNotificationFlow.showSendPushNotificationButton = {_,_ in
            called = true
        }
        
        RestartPushNotificationFlow.start(viewController: UIViewController(),
                                          pushNotificationService: FakePushNotificationService()) { }
        
        XCTAssert(called)
    }
    
    func test_GivenMockedLauncher_WhenFlowStarted_ThenSetupRestartPushNotificationHandlingCalled() {
        stubAllLaunchers()
        var called = false
        RestartPushNotificationFlow.setupRestartPushNotificationHandling = {_,_ in
            called = true
        }
        
        RestartPushNotificationFlow.start(viewController: UIViewController(),
                                          pushNotificationService: FakePushNotificationService()) { }
        
        XCTAssert(called)
    }
    
    func stubAllLaunchers() {
        RestartPushNotificationFlow.setupRestartPushNotificationHandling = {_,_ in }
        RestartPushNotificationFlow.showSendPushNotificationButton = {_,_ in }
    }
}
