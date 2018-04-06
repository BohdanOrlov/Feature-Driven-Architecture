//
//  UserCommentsRepository.swift
//  Domain
//
//  Created by Bohdan Orlov on 26/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public protocol UserCommentsProviding {
    func comments(userId: Int, didFinish: @escaping ([Comment]) -> Void)
}

public class UserCommentsRepository: UserCommentsProviding {
    
    private let postsRepository: PostsProviding
    private let commentsRepository: CommentsProviding
    
    public init(postsRepository: PostsProviding, commentsRepository: CommentsProviding) {
        self.postsRepository = postsRepository
        self.commentsRepository = commentsRepository
    }
    
    public func comments(userId: Int, didFinish: @escaping ([Comment]) -> Void) {
        self.postsRepository.posts(userId: userId) { posts in
            self.commentsRepository.comments(postIds: posts.map { $0.id }) { comments in
                didFinish(comments)
            }
        }
    }
}
