//
//  ViewControllerPresenter.swift
//  Architecture
//
//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewControllerPresenting: AnyObject {
    func present(viewController: UIViewController, completion: @escaping () -> Void)
    func dismiss(viewController: UIViewController, completion: @escaping () -> Void)
}

public class ViewControllerPresenter: ViewControllerPresenting {
    
    private weak var rootViewController: UIViewController?
    private let application: UIApplication
    
    public init(rootViewController: UIViewController, application: UIApplication) {
        self.rootViewController = rootViewController
        self.application = application
    }
    
    public func present(viewController: UIViewController, completion: @escaping () -> Void) {
        if alreadyPresented(viewController) {
            self.rewind(to: viewController, completion: completion)
            return
        }
        guard let rootViewController = self.rootViewController else {
            assertionFailure()
            completion()
            return
        }
        present(rootViewController: rootViewController, viewController: viewController, completion)
    }
    
    public func dismiss(viewController: UIViewController, completion: @escaping () -> Void) {
        if let presentingViewController = viewController.presentingViewController {
            presentingViewController.dismiss(animated: true, completion: completion)
        } else {
            viewController.remove()
        }
    }
    
    private func alreadyPresented(_ viewController: UIViewController) -> Bool {
        return viewController.presentingViewController != nil || viewController.parent != nil
    }
    
    private func rewind(to viewController: UIViewController, completion: @escaping () -> Void) {
        if viewController.presentedViewController != nil {
            viewController.dismiss(animated: true, completion: completion)
        } else {
            completion()
        }
    }
    
    private func present(rootViewController: UIViewController,
                         viewController: UIViewController,
                         _ completion: @escaping () -> Void) {
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: navigationController.viewControllers.count > 0)
            completion()
            return
        }
        presentAsFullscreen(rootViewController: rootViewController, viewController: viewController, completion)
    }
    
    private func presentAsFullscreen(rootViewController: UIViewController,
                                    viewController: UIViewController,
                                    _ completion: @escaping () -> Void) {
        let viewControllerForModalPresentation = rootViewController.viewControllerForModalPresentation!
        if (viewControllerForModalPresentation.isEmpty) {
            viewControllerForModalPresentation.add(viewController)
            completion()
        } else {
            let appIsActive = (application.applicationState == .active)
            viewControllerForModalPresentation.present(viewController, animated: appIsActive, completion: completion)
        }
    }
}

extension UIViewController {
    public var isEmpty: Bool {
        return self.view.subviews.isEmpty && self.childViewControllers.isEmpty && self.presentedViewController == nil
    }
    
    public var viewControllerForModalPresentation: UIViewController? {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.viewControllerForModalPresentation
        } else {
            return self
        }
    }
}

extension UIViewController {
    public func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
        child.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        child.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        child.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    public func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
