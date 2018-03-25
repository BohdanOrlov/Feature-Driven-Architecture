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

struct MainFlow { // Flow is not testable at the moment because it acts as an assembly point
    
    static func start(windowOwner: UIWindowOwner) {
        defineWindowFrames(screenBounds: UIScreen.main.bounds) { windowFrame in
            setupWindow(windowFrame: windowFrame, windowOwner: windowOwner) { (viewController: UIViewController) in
                showLoginScreen(rootViewController: viewController) { [unowned viewController] in
                    showTabBar(rootViewController: viewController) { tabControllers in
                        showNavigationBar(rootViewController: tabControllers[Tab.posts.rawValue]!) { viewController in
                            showPostsWithLogoutButton(viewController: viewController) {
                                start(windowOwner: windowOwner)
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


fileprivate func showLoginScreen(rootViewController: UIViewController, didLogin: @escaping () -> Void) {
    _ = LoginScreenFeature(loginViewController: LoginViewController(),
                           viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                           sessionService: SessionService(),
                           didLogin: didLogin)
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

fileprivate func showPostsWithLogoutButton(viewController: UIViewController, didLogout: @escaping () -> Void) {
    showPosts(viewController: viewController) { buttonContainer in
        showLogoutButton(buttonContainer: buttonContainer, didLogout: didLogout)
    }
}

fileprivate func showPosts(viewController: UIViewController, didPrepareButtonContainer: @escaping (UIView) -> Void) {
    _ = PostsScreenFeature(postsViewController: PostsViewController(),
                           viewControllerPresenting: ViewControllerPresenter(rootViewController: viewController),
                           postsRepository: postsRepository(),
                   didPrepareButtonContainer: didPrepareButtonContainer)
}

fileprivate func showLogoutButton(buttonContainer: UIView, didLogout: @escaping () -> Void) {
    _ = LogoutFeature(viewPresenter: ViewPresenter(rootView: buttonContainer), didLogout: didLogout)
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
