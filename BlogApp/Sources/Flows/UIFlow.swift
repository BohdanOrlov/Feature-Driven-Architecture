//
//  UIFlow.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain
import UI

struct UIFlow {
    
    static func start(viewController: UIViewController, sessionService: SessionServiceProtocol, networkService: NetworkRequestSending) {
        showLoginScreen(viewController, sessionService) { [unowned viewController] session in
            showTabBar(viewController) { tabControllers in
                showNavigationBar(tabControllers[Tab.posts.rawValue]!) { viewController in
                    showPosts(viewController, session.userId, networkService) { buttonContainer in
                        showLogoutButton(buttonContainer, sessionService) { }
                    }
                }
                showNavigationBar(tabControllers[Tab.comments.rawValue]!) { viewController in
                    showComments(viewController, session.userId, networkService)
                }
            }
        }
    }
    
    static var showLoginScreen = LoginScreenFeature.launch
    static var showPosts = PostsScreenFeature.launch
    static var showComments = CommentsScreenFeature.launch
    static var showLogoutButton = LogoutButtonFeature.launch
    static var showTabBar = TabBarFeature.launch
    static var showNavigationBar = NavigationBarFeature.launch
}

