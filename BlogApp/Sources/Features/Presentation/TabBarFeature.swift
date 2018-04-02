//  Created by Bohdan Orlov on 02/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

class TabBarFeature {
    @discardableResult
    init(tabs: [String],
         tabBarController: UITabBarController,
         viewControllerPresenting: ViewControllerPresenting,
         didShowTabBar: @escaping ([String: UIViewController]) -> Void) {
        var controllersByTabs = [String: UIViewController]()
        let rootViewControllers: [UIViewController] = tabs.map {
            let viewController = RootViewController()
            viewController.title = $0
            controllersByTabs[$0] = viewController
            return viewController
        }
        tabBarController.viewControllers = rootViewControllers
        didShowTabBar(controllersByTabs)
        viewControllerPresenting.present(viewController: tabBarController, completion: {})
    }
}
