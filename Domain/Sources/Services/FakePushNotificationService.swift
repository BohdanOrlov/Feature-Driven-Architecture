//
//  FakePushNotificationService.swift
//  DomainTestsSupport
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Domain

public final class FakePushNotificationService: PushNotificationServiceProtocol {
    public init() {
        
    }
    
    public var didReceivePush: ((PushNotification) -> Void)?
    
    public func push(notification: PushNotification) {
        fatalError()
    }
}
