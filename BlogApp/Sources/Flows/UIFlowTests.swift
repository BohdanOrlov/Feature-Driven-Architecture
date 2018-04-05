//
//  UIFlowTests.swift
//  BlogAppTests
//
//  Created by Bohdan Orlov on 05/04/2018.
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

class UIFlowTests: XCTestCase {
    
    enum Launchers: String {
        case showLoginScreen
        case showPosts
        case showComments
        case showLogoutButton
        case showTabBar
        case showNavigationBar
    }
    
    var expectedLaunchers: [Launchers]  = [.showLoginScreen,
                                           .showTabBar,
                                           .showNavigationBar,
                                           .showPosts,
                                           .showLogoutButton,
                                           .showNavigationBar,
                                           .showComments ]
    var calledLaunchers = [Launchers]()
    
    func test_GivenMockedLaunchers_WhenFlowStarted_ThenShowSendPushNotificationButtonCalled() {
        stubLaunchers()
        startFlow()
        XCTAssertEqual(calledLaunchers, expectedLaunchers)
    }
    
    func startFlow() {
        UIFlow.start(viewController: UIViewController(), sessionService: FakeSessionService(), networkService: FakeNetworkService())
    }
    
    func stubLaunchers() {
        UIFlow.showLoginScreen = { _,_, next in
            self.calledLaunchers.append(.showLoginScreen)
            next(Session(userId: 0, username: ""))
        }
        UIFlow.showPosts = { _,_,_, next in
            self.calledLaunchers.append(.showPosts)
            next(UIView())
        }
        UIFlow.showComments = { _,_,_ in
            self.calledLaunchers.append(.showComments)
        }
        UIFlow.showLogoutButton = { _,_,next in
            self.calledLaunchers.append(.showLogoutButton)
        }
        UIFlow.showTabBar = { _,next in
            self.calledLaunchers.append(.showTabBar)
            next(MainTabs(viewControllers: MainTabs.titles.map{ _ in return UIViewController() }))
        }
        UIFlow.showNavigationBar = { _,next in
            self.calledLaunchers.append(.showNavigationBar)
            next(UIViewController())
        }
    }
    
}

class FakeNetworkService: NetworkRequestSending {
    
    func send(request: Request, completionHandler: @escaping (Response) -> Void) -> URLSessionDataTask {
        return URLSessionDataTask()
    }
    
}
