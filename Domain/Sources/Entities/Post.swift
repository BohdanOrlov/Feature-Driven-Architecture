//
//  Post.swift
//  Domain
//
//  Created by Bohdan Orlov on 26/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public struct Post: Decodable {
    public let id: Int
    public let userId: Int
    public let body: String
}
