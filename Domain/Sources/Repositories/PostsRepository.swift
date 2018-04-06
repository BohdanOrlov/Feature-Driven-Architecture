//
//  PostsRepository.swift
//  Domain
//
//  Created by Bohdan Orlov on 26/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public protocol PostsProviding {
    func posts(userId: Int, didFinish: @escaping ([Post]) -> Void)
}

public final class PostsRepository: PostsProviding {
    private let networkService: NetworkRequestSending
    
    public init(networkService: NetworkRequestSending) {
        self.networkService = networkService
    }
    
    public func posts(userId: Int, didFinish: @escaping ([Post]) -> Void) {
        self.networkService.send(request: .init(endpoint: "posts"), completionHandler: { response in
            switch response {
            case .success(let data):
                guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                    didFinish([])
                    return
                }
                let userPosts = posts.filter { post in
                    post.userId == userId
                }
                didFinish(userPosts)
            case .failure(_):
                didFinish([])
            }
        })
    }
}
