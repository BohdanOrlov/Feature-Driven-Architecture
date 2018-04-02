//
//  PresentationLaunchers.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

enum Tab: String {
    case posts = "Posts"
    case comments = "Comments"
    static var all: [Tab] {
        return [.posts, .comments]
    }
}

extension WindowFrameFeature {
    static func launch(screenBounds: CGRect, didDefineScreenFrames: (CGRect) -> Void) {
        WindowFrameFeature(screenBounds: screenBounds, splitScreen: false, didDefineScreenFrames: didDefineScreenFrames)
    }
}

extension WindowFeature {
    static func launch(windowFrame: CGRect, windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
        WindowFeature(windowFrame: windowFrame, windowOwner: windowOwner, didSetupWindow: didSetupWindow)
    }
}

extension TabBarFeature {
    static func launch(rootViewController: UIViewController, didShowTabBar: @escaping ([String: UIViewController]) -> Void) {
        TabBarFeature(tabs: Tab.all.map { $0.rawValue },
                      tabBarController: UITabBarController(),
                      viewControllerPresenting: ViewControllerPresenter(rootViewController: rootViewController),
                      didShowTabBar: didShowTabBar)
    }
}

extension NavigationBarFeature {
    static func launch(rootViewController: UIViewController,  didShowNavigationBar: @escaping (UIViewController) -> Void) {
        NavigationBarFeature(viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                             navigationController: UINavigationController(),
                             didShowNavigationBar: didShowNavigationBar)
    }
}
