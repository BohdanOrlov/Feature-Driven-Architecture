//
//  PresentationLaunchers.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit



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

protocol TabControllersContainer {
    static var titles: [String] { get }
    init(viewControllers: [UIViewController])
}

struct MainTabs: TabControllersContainer {
    init(viewControllers: [UIViewController]) {
        posts = viewControllers[0]
        comments = viewControllers[1]
    }
    
    let posts: UIViewController
    let comments: UIViewController
    
    static var titles: [String] {
        return ["Posts", "Comments"]
    }
}

extension TabBarFeature {
    
    static func launch<T: TabControllersContainer>(tabs: T.Type, rootViewController: UIViewController, didShowTabBar: @escaping (T) -> Void) {
        TabBarFeature(tabs: tabs,
                      tabBarController: UITabBarController(),
                      viewControllerPresenting: ViewControllerPresenter(rootViewController: rootViewController),
                      didShowTabBar: didShowTabBar)
    }
    
    static func launchMain(rootViewController: UIViewController, didShowTabBar: @escaping (MainTabs) -> Void) {
        self.launch(tabs: MainTabs.self, rootViewController: rootViewController, didShowTabBar: didShowTabBar)
    }
    
    
}

extension NavigationBarFeature {
    static func launch(rootViewController: UIViewController,  didShowNavigationBar: @escaping (UIViewController) -> Void) {
        NavigationBarFeature(viewControllerPresenter: ViewControllerPresenter(rootViewController: rootViewController),
                             navigationController: UINavigationController(),
                             didShowNavigationBar: didShowNavigationBar)
    }
}
