//
//  MainFlow.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain
import UI

struct MainFlow { // Flow is not testable at the moment because it acts as an assembly point
    
    static func start(windowOwner: UIWindowOwner) {
        defineWindowFrames(screenBounds: UIScreen.main.bounds) { windowFrame in
            setupWindow(windowFrame: windowFrame, windowOwner: windowOwner) { (viewController: UIViewController) in
                setupNetworkService() { networkService in
                    setupSessionService(networkService: networkService) { sessionService in
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
                }
                setupPushNotificationService() { service in
                    setupRestartPushNotificationHandling(pushNotificationService: service) {
                        start(windowOwner: windowOwner)
                    }
                    setupSendPushNotificationButton(rootViewController: viewController, pushNotificationService: service)
                }
            }
        }
    }
}


fileprivate func defineWindowFrames(screenBounds: CGRect, didDefineScreenFrames: (CGRect) -> Void) {
    _ = WindowFrameFeature(screenBounds: screenBounds, splitScreen: true, didDefineScreenFrames: didDefineScreenFrames)
}

fileprivate func setupWindow(windowFrame: CGRect, windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
    _ = WindowFeature(windowFrame: windowFrame, windowOwner: windowOwner, didSetupWindow: didSetupWindow)
}


fileprivate func showLoginScreen(rootViewController: UIViewController, sessionService: SessionServiceProtocol, didLogin: @escaping (Session) -> Void) {
    _ = LoginScreenFeature(loginViewController: LoginViewController(),
                           viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                           sessionService: sessionService,
                           didLogin: didLogin)
}

fileprivate func setupNetworkService(didSetup: (NetworkRequestSending) -> Void) {
    didSetup(NetworkService(hostURL: URL(string: "https://jsonplaceholder.typicode.com")!, session: URLSession(configuration: .default)))
}

fileprivate func setupSessionService(networkService: NetworkRequestSending, didSetup: (SessionServiceProtocol) -> Void) {
    didSetup(SessionService(userProvider: UserRepository(networkService: networkService)))
}

fileprivate func showTabBar(rootViewController: UIViewController, didShowTabBar: @escaping ([String: UIViewController]) -> Void) { 
    _ = TabBarFeature(tabs: Tab.all.map { $0.rawValue },
                          tabBarController: UITabBarController(),
                          viewControllerPresenting: ViewControllerPresenter(rootViewController: rootViewController),
                          didShowTabBar: didShowTabBar)
}

fileprivate enum Tab: String {
    case posts = "Posts"
    case comments = "Comments"
    static var all: [Tab] {
        return [.posts, .comments]
    }
}

fileprivate func showNavigationBar(rootViewController: UIViewController,  didShowNavigationBar: @escaping (UIViewController) -> Void) {
    _ = NavigationBarFeature(viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                                 navigationController: UINavigationController(),
                                 didShowNavigationBar: didShowNavigationBar)
}

fileprivate func showPostsWithLogoutButton(viewController: UIViewController, userId: Int, networkService: NetworkRequestSending,
                                           sessionService: SessionServiceProtocol,
                                           didLogout: @escaping () -> Void) {
    showPosts(viewController: viewController, userId: userId, networkService: networkService) { buttonContainer in
        showLogoutButton(buttonContainer: buttonContainer, sessionService: sessionService, didLogout: didLogout)
    }
}

fileprivate func showPosts(viewController: UIViewController, userId: Int, networkService: NetworkRequestSending, didPrepareButtonContainer: @escaping (UIView) -> Void) {
    _ = PostsScreenFeature(postsViewController: StringsTableViewController(),
                           viewControllerPresenting: ViewControllerPresenter(rootViewController: viewController),
                           userId: userId,
                           postsRepository: PostsRepository(networkService: networkService),
                   didPrepareButtonContainer: didPrepareButtonContainer)
}

fileprivate func showComments(viewController: UIViewController, userId: Int, networkService: NetworkRequestSending) {
    let userCommentsRepository = UserCommentsRepository(postsRepository: PostsRepository(networkService: networkService),
                                                        commentsRepository: CommentsRepository(networkService: networkService))
    _ = CommentsScreenFeature(commentsViewController: StringsTableViewController(),
                              viewControllerPresenting: ViewControllerPresenter(rootViewController: viewController),
                              userId: userId,
                              commentsRepository: userCommentsRepository)
}


fileprivate func showLogoutButton(buttonContainer: UIView, sessionService: SessionServiceProtocol, didLogout: @escaping () -> Void) {
    _ = LogoutButtonFeature(viewPresenter: ViewPresenter(rootView: buttonContainer), sessionService: sessionService, didLogout: didLogout)
}

fileprivate func setupPushNotificationService(didSetupService: (PushNotificationServiceProtocol) -> Void) {
    didSetupService(PushNotificationService())
}

fileprivate func setupRestartPushNotificationHandling(pushNotificationService: PushNotificationServiceProtocol,
                                               didReceiveRestartRequest: @escaping () -> Void) {
    _ = RestartPushNotificationFeature(pushNotificationService:pushNotificationService, didReceiveRestartRequest: didReceiveRestartRequest)
}

fileprivate func setupSendPushNotificationButton(rootViewController: UIViewController,
                                                 pushNotificationService: PushNotificationServiceProtocol) {
    _ = PushNotificationButtonFeature(rootViewController: rootViewController, pushNotificationService:pushNotificationService)
}
