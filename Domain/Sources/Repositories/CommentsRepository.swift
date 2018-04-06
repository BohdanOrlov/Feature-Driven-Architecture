//
//  CommentsRepository.swift
//  Domain
//
//  Created by Bohdan Orlov on 26/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public protocol CommentsProviding {
    func comments(postIds: [Int], didFinish: @escaping ([Comment]) -> Void)
}

public final class CommentsRepository: CommentsProviding {
    private let networkService: NetworkRequestSending
    
    public init(networkService: NetworkRequestSending) {
        self.networkService = networkService
    }
    
    public func comments(postIds: [Int], didFinish: @escaping ([Comment]) -> Void) {
        self.networkService.send(request: .init(endpoint: "comments"), completionHandler: { response in
            switch response {
            case .success(let data):
                guard let comments = try? JSONDecoder().decode([Comment].self, from: data) else {
                    didFinish([])
                    return
                }
                let postComments = comments.filter { comment in
                    postIds.contains(comment.postId)
                }
                didFinish(postComments)
            case .failure(_):
                didFinish([])
            }
        })
    }
}
