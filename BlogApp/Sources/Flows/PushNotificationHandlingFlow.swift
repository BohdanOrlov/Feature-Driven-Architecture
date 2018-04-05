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
import Features

struct PushNotificationHandlingFlow {
    
    static func start(viewController: UIViewController, pushNotificationService: PushNotificationServiceProtocol, didReceiveRestartPush: @escaping () -> Void) {
        showSendPushNotificationButton(viewController, pushNotificationService)
        setupRestartPushNotificationHandling(pushNotificationService, didReceiveRestartPush)
    }
    
    static var setupRestartPushNotificationHandling = RestartPushNotificationFeature.launch
    static var showSendPushNotificationButton = PushNotificationButtonFeature.launch
}
