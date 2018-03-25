//
//  ViewControllerPresenter.swift
//  Architecture
//
//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerPresenting: class {
    func present(viewController: UIViewController, completion: @escaping () -> Void)
    func dismiss(viewController: UIViewController, completion: @escaping () -> Void)
}

class ViewControllerPresenter: ViewControllerPresenting {
    
    
    private weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func present(viewController: UIViewController, completion: @escaping () -> Void) {
        guard let rootViewController = self.rootViewController else {
            assertionFailure()
            completion()
            return
        }
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: navigationController.viewControllers.count > 0)
            completion()
            return
        }
        let viewControllerForModalPresentation = rootViewController.viewControllerForModalPresentation!
        if (viewControllerForModalPresentation.isEmpty) {
            viewControllerForModalPresentation.add(viewController)
            completion()
        } else {
            viewControllerForModalPresentation.present(viewController, animated: true, completion: completion)
        }
    }
    
    func dismiss(viewController: UIViewController, completion: @escaping () -> Void) {
        if let presentingViewController = viewController.presentingViewController {
            presentingViewController.dismiss(animated: true, completion: completion)
        } else {
            viewController.remove()
        }
    }
}


extension UIViewController {
    var isEmpty: Bool {
        return self.view.subviews.isEmpty && self.childViewControllers.isEmpty && self.presentedViewController == nil
    }
    
    var viewControllerForModalPresentation: UIViewController? {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.viewControllerForModalPresentation
        } else {
            return self
        }
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
        child.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        child.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        child.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
