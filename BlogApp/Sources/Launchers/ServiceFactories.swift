//
//  ServiceFactories.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Domain

extension NetworkService {
    static func shared(didSetup: (NetworkRequestSending) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com"  // this might not work since that data is publicly mutable
        // To start local server: https://github.com/typicode/json-server
//        let urlString = "http://localhost:3000"  // json-server --watch db.json
        didSetup(NetworkService(hostURL: URL(string: urlString)!, session: URLSession(configuration: .default)))
    }
}

extension SessionService {
    static func shared(networkService: NetworkRequestSending, didSetup: (SessionServiceProtocol) -> Void) {
        let userRepository = UserRepository(networkService: networkService)
        didSetup(SessionService(userProvider: userRepository, userDefaults: .standard))
    }
}

extension PushNotificationServiceProtocol {
    static func shared(didSetupService: (PushNotificationServiceProtocol) -> Void) {
        didSetupService(PushNotificationService())
    }
}
