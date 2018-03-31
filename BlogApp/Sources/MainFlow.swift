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
        makeWindows(windowOwner: windowOwner) { viewController in
            setupServices { networkService, sessionService, pushNotificationService in
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
                showSendPushNotificationButton(rootViewController: viewController, pushNotificationService: pushNotificationService)
                setupRestartPushNotificationHandling(pushNotificationService: pushNotificationService) {
                    start(windowOwner: windowOwner)
                }
            }
        }
    }
}

fileprivate func makeWindows(windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
    defineWindowFrames(screenBounds: UIScreen.main.bounds) { windowFrame in
        setupWindow(windowFrame: windowFrame, windowOwner: windowOwner, didSetupWindow: didSetupWindow)
    }
}

fileprivate func defineWindowFrames(screenBounds: CGRect, didDefineScreenFrames: (CGRect) -> Void) {
    WindowFrameFeature(screenBounds: screenBounds, splitScreen: false, didDefineScreenFrames: didDefineScreenFrames)
}

fileprivate func setupWindow(windowFrame: CGRect, windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
    WindowFeature(windowFrame: windowFrame, windowOwner: windowOwner, didSetupWindow: didSetupWindow)
}


fileprivate func showLoginScreen(rootViewController: UIViewController, sessionService: SessionServiceProtocol, didLogin: @escaping (Session) -> Void) {
    LoginScreenFeature(loginViewController: LoginViewController(),
                           viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                           sessionService: sessionService,
                           didLogin: didLogin)
}

fileprivate func setupServices(didSetup: (NetworkRequestSending, SessionServiceProtocol, PushNotificationServiceProtocol) -> Void) {
    setupNetworkService() { networkService in
        setupSessionService(networkService: networkService) { sessionService in
            setupPushNotificationService() { pushNotificationService in
                didSetup(networkService, sessionService, pushNotificationService)
            }
        }
    }
}

fileprivate func setupNetworkService(didSetup: (NetworkRequestSending) -> Void) {
    didSetup(NetworkService(hostURL: URL(string: "https://jsonplaceholder.typicode.com")!, session: URLSession(configuration: .default)))
}

fileprivate func setupSessionService(networkService: NetworkRequestSending, didSetup: (SessionServiceProtocol) -> Void) {
    didSetup(SessionService(userProvider: UserRepository(networkService: networkService)))
}

fileprivate func showTabBar(rootViewController: UIViewController, didShowTabBar: @escaping ([String: UIViewController]) -> Void) { 
    TabBarFeature(tabs: Tab.all.map { $0.rawValue },
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
    NavigationBarFeature(viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
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
    PostsScreenFeature(postsViewController: StringsTableViewController(),
                           viewControllerPresenting: ViewControllerPresenter(rootViewController: viewController),
                           userId: userId,
                           postsRepository: PostsRepository(networkService: networkService),
                   didPrepareButtonContainer: didPrepareButtonContainer)
}

fileprivate func showComments(viewController: UIViewController, userId: Int, networkService: NetworkRequestSending) {
    let userCommentsRepository = UserCommentsRepository(postsRepository: PostsRepository(networkService: networkService),
                                                        commentsRepository: CommentsRepository(networkService: networkService))
    CommentsScreenFeature(commentsViewController: StringsTableViewController(),
                              viewControllerPresenting: ViewControllerPresenter(rootViewController: viewController),
                              userId: userId,
                              commentsRepository: userCommentsRepository)
}


fileprivate func showLogoutButton(buttonContainer: UIView, sessionService: SessionServiceProtocol, didLogout: @escaping () -> Void) {
    LogoutButtonFeature(viewPresenter: ViewPresenter(rootView: buttonContainer), sessionService: sessionService, didLogout: didLogout)
}

fileprivate func setupPushNotificationService(didSetupService: (PushNotificationServiceProtocol) -> Void) {
    didSetupService(PushNotificationService())
}

fileprivate func setupRestartPushNotificationHandling(pushNotificationService: PushNotificationServiceProtocol,
                                               didReceiveRestartRequest: @escaping () -> Void) {
    RestartPushNotificationFeature(pushNotificationService:pushNotificationService, didReceiveRestartRequest: didReceiveRestartRequest)
}

fileprivate func showSendPushNotificationButton(rootViewController: UIViewController,
                                                 pushNotificationService: PushNotificationServiceProtocol) {
    PushNotificationButtonFeature(rootViewController: rootViewController, pushNotificationService:pushNotificationService)
}
