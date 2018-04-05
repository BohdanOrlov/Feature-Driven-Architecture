//
//  NetworkService.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Domain

public final class NetworkService: NetworkRequestSending {
    public let hostURL: URL
    public let session: URLSessionProtocol
    
    public init(hostURL: URL, session: URLSessionProtocol) {
        self.hostURL = hostURL
        self.session = session
    }
    
    public func send(request: Request, completionHandler: @escaping (Response) -> Void) -> URLSessionDataTask {
        let dataTask = self.session.dataTask(with: self.url(for: request)) {
            data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse
                    , (200..<300) ~= httpResponse.statusCode
                    , let data = data else {
                        let error = error ?? NSError(domain: String(describing: NetworkRequestSending.self), code: -1)
                        completionHandler(Response.failure(error))
                        return
                }
                completionHandler(Response.success(data))
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    private func url(for request: Request) -> URL {
        return self.hostURL.appendingPathComponent(request.endpoint)
    }
    
}


public protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}


extension URLSession: URLSessionProtocol {
    
}

