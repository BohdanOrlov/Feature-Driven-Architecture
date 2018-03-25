//
//  User.swift
//  Domain
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public struct User: Codable {
    public var username: String
    public init(username: String) {
        self.username = username
    }
}
