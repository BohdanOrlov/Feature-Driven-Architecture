//  Created by Bohdan Orlov on 12/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import UI

public class NavigationBarFeature {
    
    @discardableResult
    public init(viewControllerPresenter: ViewControllerPresenting,
         navigationController: UINavigationController,
         didShowNavigationBar: @escaping (UIViewController) -> Void) {
        didShowNavigationBar(navigationController)
        viewControllerPresenter.present(viewController: navigationController, completion: {
        })
    }
}
