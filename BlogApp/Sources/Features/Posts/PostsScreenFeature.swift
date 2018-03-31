//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain
import UI

class PostsScreenFeature {
    @discardableResult
    init(postsViewController: StringsTableViewController,
         viewControllerPresenting: ViewControllerPresenting,
         userId: Int,
         postsRepository: PostsProviding,
         didPrepareButtonContainer: @escaping (UIView) -> Void) {
        
        postsViewController.didPrepareButtonContainer = didPrepareButtonContainer
        postsRepository.posts(userId: userId) { [weak postsViewController] posts in
            postsViewController?.data = .init(strings: posts.map { $0.body })
        }

        viewControllerPresenting.present(viewController: postsViewController, completion: { })
        
    }
}
