//
//  LoginScreenFeatureTests.swift
//  BlogAppTests
//
//  Created by Bohdan Orlov on 05/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import XCTest
import Foundation
import UIKit
import Core
import CoreTestsSupport
import Domain
import DomainTestsSupport
import UI
import UITestsSupport
import Features

class LoginScreenFeatureTests: XCTestCase {
    
    var fakeLoginViewController: FakeLoginViewController!
    var fakeViewControllerPresenter: FakeViewControllerPresenter!
    var fakeSessionService: FakeSessionService!
    var fakeDidLogin: ((Session) -> Void)!
    
    override func setUp() {
        super.setUp()
        fakeLoginViewController = FakeLoginViewController()
        fakeViewControllerPresenter = FakeViewControllerPresenter()
        fakeSessionService = FakeSessionService()
        fakeDidLogin = { _ in }
    }
    
    override func tearDown() {
        fakeLoginViewController = nil
        fakeViewControllerPresenter = nil
        fakeSessionService = nil
        fakeDidLogin = nil
        super.tearDown()
    }
    
    func test_GivenSessionReadyToStart_WhenFeatureLaunched_ThenPresentIsCalled() {
        self.fakeSessionService.stubbedSessionState.value = .readyToStart
        
        launchFeature()
        
        XCTAssert(fakeViewControllerPresenter.presentCalled)
    }
    
    func test_GivenSessionReadyToStart_WhenFeatureLaunched_ThenLoginViewControllerIsPresented() {
        self.fakeSessionService.stubbedSessionState.value = .readyToStart
        
        launchFeature()
        
        XCTAssertEqual(fakeViewControllerPresenter.presentedViewController, fakeLoginViewController)
    }
    
    
    func test_GivenSessionStarted_WhenFeatureLaunched_ThenPresentIsCalled() {
        self.fakeSessionService.stubbedSessionState.value = .started(fakeSession)
        
        launchFeature()
        
        XCTAssert(fakeViewControllerPresenter.presentCalled)
    }
    
    func test_GivenLaunchedFeature_WhenSessionStarted_ThenPresentIsNotCalledAgain() {
        launchFeature()
        fakeLoginViewController.stubbedPresentingViewController = UIViewController()
        
        self.fakeSessionService.stubbedSessionState.value = .started(fakeSession)
        
        XCTAssertEqual(fakeViewControllerPresenter.presentCounter, 1)
    }
    
    func test_GivenLaunchedFeature_WhenDidTapButton_ThenStartSessionCalled() {
        launchFeature()
        
        self.fakeLoginViewController.setDidTapButton(fakeCredentials)
        
        XCTAssert(fakeSessionService.startSessionCalled)
    }
    
    
    //MARK: - Tests support
    func launchFeature() {
        LoginScreenFeature(loginViewController: fakeLoginViewController,
                           viewControllerPresenter: fakeViewControllerPresenter,
                           sessionService: fakeSessionService,
                           didLogin: fakeDidLogin)
    }
    
    let fakeSession = Session(userId: 7, username: "John")
    let fakeCredentials = SessionCredentials(username: "John", password: "")
}

final class FakeLoginViewController: UIViewController, LoginRendering {
    var setIsUserInteractionEnabled: Bool!
    var setShowsActivityIndicator: Bool!
    var stubbedIsUserInteractionEnabled: Bool!
    var stubbedShowsActivityIndicator: Bool!
    var stubbedPresentingViewController: UIViewController!
    
    override var presentingViewController: UIViewController? {
        return stubbedPresentingViewController
    }
    
    var isUserInteractionEnabled: Bool {
        set {
            setIsUserInteractionEnabled = newValue
        }
        get {
            return stubbedIsUserInteractionEnabled
        }
    }
    
    var showsActivityIndicator: Bool {
        set {
            setShowsActivityIndicator = newValue
        }
        get {
            return stubbedShowsActivityIndicator
        }
    }
    
    var setDidTapButton: ((SessionCredentials) -> Void)!
    var didTapButton: ((SessionCredentials) -> Void)? {
        get {
            return setDidTapButton
        }
        set {
            setDidTapButton = newValue
        }
    }
    
}

final class FakeViewControllerPresenter: ViewControllerPresenting {
    var presentCalled = false
    var dismissCalled = false
    var presentCounter = 0
    var dismissCounter = 0
    var presentedViewController: UIViewController!
    var dismissedViewController: UIViewController!
    
    func present(viewController: UIViewController, completion: @escaping () -> Void) {
        presentedViewController = viewController
        presentCalled = true
        presentCounter += 1
    }
    
    func dismiss(viewController: UIViewController, completion: @escaping () -> Void) {
        dismissedViewController = viewController
        dismissCalled = true
        dismissCounter = 0
    }
    
    
}


