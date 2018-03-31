//
//  MainFlow.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain
import UI

struct MainFlow {
    
    static func start(windowOwner: UIWindowOwner) {
        makeWindows(windowOwner: windowOwner) { viewController in
            setupServices { networkService, sessionService, pushNotificationService in
                MainUIFlow.start(viewController: viewController, sessionService: sessionService, networkService: networkService)
                RestartPushNotificationFlow.start(viewController: viewController, pushNotificationService: pushNotificationService) {
                    start(windowOwner: windowOwner)
                }
            }
        }
    }
    
    private static func setupServices(didSetup: (NetworkRequestSending, SessionServiceProtocol, PushNotificationServiceProtocol) -> Void) {
        setupNetworkService() { networkService in
            setupSessionService(networkService: networkService) { sessionService in
                setupPushNotificationService() { pushNotificationService in
                    didSetup(networkService, sessionService, pushNotificationService)
                }
            }
        }
    }
    
    private static func makeWindows(windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
        defineWindowFrames(screenBounds: UIScreen.main.bounds) { windowFrame in
            setupWindow(windowFrame: windowFrame, windowOwner: windowOwner, didSetupWindow: didSetupWindow)
        }
    }
    
    private static func defineWindowFrames(screenBounds: CGRect, didDefineScreenFrames: (CGRect) -> Void) {
        WindowFrameFeature(screenBounds: screenBounds, splitScreen: true, didDefineScreenFrames: didDefineScreenFrames)
    }
    
    private static func setupWindow(windowFrame: CGRect, windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
        WindowFeature(windowFrame: windowFrame, windowOwner: windowOwner, didSetupWindow: didSetupWindow)
    }
    
    private static func setupNetworkService(didSetup: (NetworkRequestSending) -> Void) {
        didSetup(NetworkService(hostURL: URL(string: "https://jsonplaceholder.typicode.com")!, session: URLSession(configuration: .default)))
    }
    
    private static func setupSessionService(networkService: NetworkRequestSending, didSetup: (SessionServiceProtocol) -> Void) {
        didSetup(SessionService(userProvider: UserRepository(networkService: networkService)))
    }
    
    private static func setupPushNotificationService(didSetupService: (PushNotificationServiceProtocol) -> Void) {
        didSetupService(PushNotificationService())
    }
}

