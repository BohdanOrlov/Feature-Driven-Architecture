//
//  CommentsScreenFeature.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 26/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain
import UI

public class CommentsScreenFeature {
    
    @discardableResult
    public init(commentsViewController: StringsRenderingViewController,
         viewControllerPresenting: ViewControllerPresenting,
         userId: Int,
         commentsRepository: UserCommentsRepository) {
        
        commentsViewController.retain(self)
        commentsRepository.comments(userId: userId) { [weak commentsViewController] comments in
            commentsViewController?.data = .init(strings: comments.map{ $0.body })
        }
        
        viewControllerPresenting.present(viewController: commentsViewController, completion: { })
    }
    
}
