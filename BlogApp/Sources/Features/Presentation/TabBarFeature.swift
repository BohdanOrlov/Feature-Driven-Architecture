//  Created by Bohdan Orlov on 02/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

class TabBarFeature {
    @discardableResult
    init<T: TabControllersInitializable>(tabs: [String],
         tabBarController: UITabBarController,
         viewControllerPresenting: ViewControllerPresenting,
         didShowTabBar: @escaping (T) -> Void) {
        let rootViewControllers: [UIViewController] = tabs.map {
            let viewController = RootViewController()
            viewController.title = $0
            return viewController
        }
        tabBarController.viewControllers = rootViewControllers
        didShowTabBar(T.init(viewControllers: rootViewControllers))
        viewControllerPresenting.present(viewController: tabBarController, completion: {})
    }
}
