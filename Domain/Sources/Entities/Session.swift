//
//  Entities.swift
//  Architecture
//
//  Created by Bohdan Orlov on 27/02/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

public struct Session: Codable {
    public let userId: Int
    public let username: String
    public init(userId: Int, username: String) {
        self.userId = userId
        self.username = username
    }
}
