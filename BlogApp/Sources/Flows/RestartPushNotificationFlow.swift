//
//  RestartPushNotificationFlow.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain

struct RestartPushNotificationFlow {
    
    static func start(viewController: UIViewController, pushNotificationService: PushNotificationServiceProtocol, didReceiveRestartPush: @escaping () -> Void) {
        showSendPushNotificationButton(rootViewController: viewController, pushNotificationService: pushNotificationService)
        setupRestartPushNotificationHandling(pushNotificationService: pushNotificationService, didReceiveRestartRequest: didReceiveRestartPush)
    }
    
    private static func setupRestartPushNotificationHandling(pushNotificationService: PushNotificationServiceProtocol,
                                                          didReceiveRestartRequest: @escaping () -> Void) {
        RestartPushNotificationFeature(pushNotificationService:pushNotificationService, didReceiveRestartRequest: didReceiveRestartRequest)
    }
    
    private static func showSendPushNotificationButton(rootViewController: UIViewController,
                                                    pushNotificationService: PushNotificationServiceProtocol) {
        PushNotificationButtonFeature(rootViewController: rootViewController, pushNotificationService:pushNotificationService)
    }
    
}
