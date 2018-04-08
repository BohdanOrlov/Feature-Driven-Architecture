//
//  Services.swift
//  Domain
//
//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core

public protocol PushNotificationServiceProtocol: AnyObject, Retaining {
    var lastReceivedPush: ReadonlyObservable<PushNotification?> { get }
    func push(notification: PushNotification)
}

public class PushNotificationService: PushNotificationServiceProtocol {
    public var lastReceivedPush: ReadonlyObservable<PushNotification?> {
        return self.mutableLastReceivedPush.makeReadonly()
    }
    private var mutableLastReceivedPush = MutableObservable<PushNotification?>(nil)
    
    public init() {}
    
    public func push(notification: PushNotification) {
        self.mutableLastReceivedPush.value = notification
    }
}
