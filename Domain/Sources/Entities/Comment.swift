//
//  Comment.swift
//  Domain
//
//  Created by Bohdan Orlov on 26/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public struct Comment: Codable {
    public let id: Int
    public let postId: Int
    public let body: String
}
