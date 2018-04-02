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
                startUIFlow(viewController, sessionService, networkService)
                startPushNotificationHandlingFlow(viewController, pushNotificationService) {
                    start(windowOwner: windowOwner)
                }
            }
        }
    }
    
    private static func setupServices(didSetup: (NetworkRequestSending, SessionServiceProtocol, PushNotificationServiceProtocol) -> Void) {
        setupNetworkService() { networkService in
            setupSessionService(networkService) { sessionService in
                setupPushNotificationService() { pushNotificationService in
                    didSetup(networkService, sessionService, pushNotificationService)
                }
            }
        }
    }
    
    private static func makeWindows(windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
        defineWindowFrames(UIScreen.main.bounds) { windowFrame in
            setupWindow(windowFrame, windowOwner, didSetupWindow)
        }
    }
    
    static var startUIFlow = UIFlow.start
    static var startPushNotificationHandlingFlow = PushNotificationHandlingFlow.start
    
    static var defineWindowFrames = WindowFrameFeature.launch
    static var setupWindow = WindowFeature.launch
    
    static var setupNetworkService = NetworkService.shared
    static var setupSessionService = SessionService.shared
    static var setupPushNotificationService = PushNotificationService.shared
}

