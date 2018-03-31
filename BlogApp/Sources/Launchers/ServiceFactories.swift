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
        didSetup(NetworkService(hostURL: URL(string: "https://jsonplaceholder.typicode.com")!, session: URLSession(configuration: .default)))
    }
}

extension SessionService {
    static func shared(networkService: NetworkRequestSending, didSetup: (SessionServiceProtocol) -> Void) {
        didSetup(SessionService(userProvider: UserRepository(networkService: networkService)))
    }
}

extension PushNotificationServiceProtocol {
    static func shared(didSetupService: (PushNotificationServiceProtocol) -> Void) {
        didSetupService(PushNotificationService())
    }
}
