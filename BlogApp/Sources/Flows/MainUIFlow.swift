//
//  MainUIFlow.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain
import UI

struct MainUIFlow {
    
    static func start(viewController: UIViewController, sessionService: SessionServiceProtocol, networkService: NetworkRequestSending) {
        showLoginScreen(rootViewController: viewController, sessionService: sessionService) { [unowned viewController] session in
            showTabBar(rootViewController: viewController) { tabControllers in
                showNavigationBar(rootViewController: tabControllers[Tab.posts.rawValue]!) { viewController in
                    showPostsWithLogoutButton(viewController: viewController, userId: session.userId, networkService: networkService, sessionService: sessionService) { }
                }
                showNavigationBar(rootViewController: tabControllers[Tab.comments.rawValue]!) { viewController in
                    showComments(viewController: viewController, userId: session.userId, networkService: networkService)
                }
            }
        }
    }
    
    private static func showLoginScreen(rootViewController: UIViewController, sessionService: SessionServiceProtocol, didLogin: @escaping (Session) -> Void) {
        LoginScreenFeature(loginViewController: LoginViewController(),
                           viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                           sessionService: sessionService,
                           didLogin: didLogin)
    }
    
    private static func showTabBar(rootViewController: UIViewController, didShowTabBar: @escaping ([String: UIViewController]) -> Void) {
        TabBarFeature(tabs: Tab.all.map { $0.rawValue },
                      tabBarController: UITabBarController(),
                      viewControllerPresenting: ViewControllerPresenter(rootViewController: rootViewController),
                      didShowTabBar: didShowTabBar)
    }
    
    private enum Tab: String {
        case posts = "Posts"
        case comments = "Comments"
        static var all: [Tab] {
            return [.posts, .comments]
        }
    }
    
    private static func showNavigationBar(rootViewController: UIViewController,  didShowNavigationBar: @escaping (UIViewController) -> Void) {
        NavigationBarFeature(viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                             navigationController: UINavigationController(),
                             didShowNavigationBar: didShowNavigationBar)
    }
    
    private static func showPostsWithLogoutButton(viewController: UIViewController, userId: Int, networkService: NetworkRequestSending,
                                               sessionService: SessionServiceProtocol,
                                               didLogout: @escaping () -> Void) {
        showPosts(viewController: viewController, userId: userId, networkService: networkService) { buttonContainer in
            showLogoutButton(buttonContainer: buttonContainer, sessionService: sessionService, didLogout: didLogout)
        }
    }
    
    private static func showPosts(viewController: UIViewController, userId: Int, networkService: NetworkRequestSending, didPrepareButtonContainer: @escaping (UIView) -> Void) {
        PostsScreenFeature(postsViewController: StringsTableViewController(),
                           viewControllerPresenting: ViewControllerPresenter(rootViewController: viewController),
                           userId: userId,
                           postsRepository: PostsRepository(networkService: networkService),
                           didPrepareButtonContainer: didPrepareButtonContainer)
    }
    
    private static func showComments(viewController: UIViewController, userId: Int, networkService: NetworkRequestSending) {
        let userCommentsRepository = UserCommentsRepository(postsRepository: PostsRepository(networkService: networkService),
                                                            commentsRepository: CommentsRepository(networkService: networkService))
        CommentsScreenFeature(commentsViewController: StringsTableViewController(),
                              viewControllerPresenting: ViewControllerPresenter(rootViewController: viewController),
                              userId: userId,
                              commentsRepository: userCommentsRepository)
    }
    
    
    private static func showLogoutButton(buttonContainer: UIView, sessionService: SessionServiceProtocol, didLogout: @escaping () -> Void) {
        LogoutButtonFeature(viewPresenter: ViewPresenter(rootView: buttonContainer), sessionService: sessionService, didLogout: didLogout)
    }
}

