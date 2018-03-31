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

class PushNotificationHandlingFlowTests: XCTestCase {
    
    func test_GivenMockedLauncher_WhenFlowStarted_ThenShowSendPushNotificationButtonCalled() {
        stubAllLaunchers()
        var called = false
        PushNotificationHandlingFlow.showSendPushNotificationButton = {_,_ in
            called = true
        }
        
        PushNotificationHandlingFlow.start(viewController: UIViewController(),
                                          pushNotificationService: FakePushNotificationService()) { }
        
        XCTAssert(called)
    }
    
    func test_GivenMockedLauncher_WhenFlowStarted_ThenSetupRestartPushNotificationHandlingCalled() {
        stubAllLaunchers()
        var called = false
        PushNotificationHandlingFlow.setupRestartPushNotificationHandling = {_,_ in
            called = true
        }
        
        PushNotificationHandlingFlow.start(viewController: UIViewController(),
                                          pushNotificationService: FakePushNotificationService()) { }
        
        XCTAssert(called)
    }
    
    func stubAllLaunchers() {
        PushNotificationHandlingFlow.setupRestartPushNotificationHandling = {_,_ in }
        PushNotificationHandlingFlow.showSendPushNotificationButton = {_,_ in }
    }
}
