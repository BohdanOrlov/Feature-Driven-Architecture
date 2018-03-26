//
//  Services.swift
//  Domain
//
//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core

public protocol PushNotificationServiceProtocol: class {
    var didReceivePush: ((PushNotification) -> Void)? { get set }
    func push(notification: PushNotification)
}

public class PushNotificationService: PushNotificationServiceProtocol {
    public var didReceivePush: ((PushNotification) -> Void)?
    
    public init() {}
    
    public func push(notification: PushNotification) {
        self.didReceivePush?(notification)
    }
}
