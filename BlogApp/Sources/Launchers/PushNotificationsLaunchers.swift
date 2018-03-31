//
//  PushNotificationsLaunchers.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain

extension RestartPushNotificationFeature {
    static func launch(pushNotificationService: PushNotificationServiceProtocol,
                                                             didReceiveRestartRequest: @escaping () -> Void) {
        RestartPushNotificationFeature(pushNotificationService:pushNotificationService, didReceiveRestartRequest: didReceiveRestartRequest)
    }
}

extension PushNotificationButtonFeature {
    static func launch(rootViewController: UIViewController,
                                                   pushNotificationService: PushNotificationServiceProtocol) {
        PushNotificationButtonFeature(rootViewController: rootViewController, pushNotificationService:pushNotificationService)
    }
}
