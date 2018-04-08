//
//  FakePushNotificationService.swift
//  DomainTestsSupport
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core
import Domain

public final class FakePushNotificationService: PushNotificationServiceProtocol {
    public var stubLastReceivedPush = MutableObservable<PushNotification?>(nil)
    public var lastReceivedPush: ReadonlyObservable<PushNotification?> {
        return stubLastReceivedPush.makeReadonly()
    }
    
    public init() {
        
    }
    
    public func push(notification: PushNotification) {
        fatalError()
    }
}
