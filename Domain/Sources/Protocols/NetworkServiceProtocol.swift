//
//  NetworkServiceProtocol.swift
//  Domain
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation


public struct Request {
    public let endpoint: String
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
}

public enum Response {
    case success(Data)
    case failure(Error)
}

public protocol NetworkServiceTask {
    var url: URL { get }
}

public protocol NetworkRequestSending {
    @discardableResult func send(request: Request,  completionHandler: @escaping (Response) -> Void) -> URLSessionDataTask
}

