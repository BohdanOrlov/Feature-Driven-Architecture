//
//  Entities.swift
//  Architecture
//
//  Created by Bohdan Orlov on 27/02/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

public struct Post {
    public let text: String
}

public struct Session {
    public let username: String
    public init(username: String) {
        self.username = username
    }
}

public enum PushNotification {
    case restart
}
