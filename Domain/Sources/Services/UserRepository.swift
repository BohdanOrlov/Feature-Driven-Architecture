//
//  UserRepository.swift
//  Domain
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public protocol UserProviding {
    func user(username: String, didFinish: @escaping (User?) -> Void)
}

public final class UserRepository: UserProviding {
    private let networkService: NetworkRequestSending
    
    public init(networkService: NetworkRequestSending) {
        self.networkService = networkService
    }
    
    public func user(username: String, didFinish: @escaping (User?) -> Void) {
        self.networkService.send(request: .init(endpoint: "users"), completionHandler: { response in
            switch response {
            case .success(let data):
                var users: [User]?
                do {
                    users = try JSONDecoder().decode([User].self, from: data)
                } catch {
                    print(error)
                }
                let user = users?.first(where: { user in
                    return user.username == username
                })
                didFinish(user)
            case .failure(_):
                didFinish(nil)
            }
        })
    }
}

