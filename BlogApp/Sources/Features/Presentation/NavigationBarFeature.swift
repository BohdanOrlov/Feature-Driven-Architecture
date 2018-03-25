//  Created by Bohdan Orlov on 12/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

class NavigationBarFeature {
    init(viewControllerPresenter: ViewControllerPresenting,
         navigationController: UINavigationController,
         didShowNavigationBar: @escaping (UIViewController) -> Void) {
        didShowNavigationBar(navigationController)
        viewControllerPresenter.present(viewController: navigationController, completion: {
        })
    }
}
