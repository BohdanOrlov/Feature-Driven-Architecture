//  Created by Bohdan Orlov on 02/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import UI

public protocol TabControllersContainer {
    static var titles: [String] { get }
    init(viewControllers: [UIViewController])
}

public class TabBarFeature {
    
    @discardableResult
    public init<T: TabControllersContainer>(tabs: T.Type,
         tabBarController: UITabBarController,
         viewControllerPresenting: ViewControllerPresenting,
         didShowTabBar: @escaping (T) -> Void) {
        let rootViewControllers: [UIViewController] = tabs.titles.map {
            let viewController = RootViewController()
            viewController.title = $0
            return viewController
        }
        tabBarController.viewControllers = rootViewControllers
        didShowTabBar(T.init(viewControllers: rootViewControllers))
        viewControllerPresenting.present(viewController: tabBarController, completion: {})
    }
}
