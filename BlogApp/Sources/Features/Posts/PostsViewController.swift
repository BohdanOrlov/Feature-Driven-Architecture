//
//  PostsViewController.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 02/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Core
import UI
import Layoutless

public protocol SubviewContainerProviding: class {
    var didPrepareSubviewsContainer: ((UIView) -> Void)? { get set }
}

final class PostsViewController: ViewController, StringsRendering, SubviewContainerProviding {
    var data: StringsData {
        get {
            return self.stringsTableViewController.data
        }
        set {
            self.stringsTableViewController.data = newValue
        }
    }
    
    public var didPrepareSubviewsContainer: ((UIView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override var subviewsLayout: AnyLayout {
        return stack(.vertical)(
            self.stringsTableViewController.view,
            self.buttonContainer
        ).fillingParent(relativeToSafeArea: true)
    }
    
    override func defineLayout() {
        super.defineLayout()
        self.stringsTableViewController.didMove(toParentViewController: self)
        self.didPrepareSubviewsContainer?(self.buttonContainer)
    }
    
    private let buttonContainer = UIView()
    private let stringsTableViewController = StringsTableViewController()
}
