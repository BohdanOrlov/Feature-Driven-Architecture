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

public protocol SubviewContainerProviding: AnyObject {
    var didPrepareSubviewsContainer: ((UIView) -> Void)? { get set }
}

public final class PostsViewController: ViewController, StringsRendering, SubviewContainerProviding {
    public var data: StringsData {
        get {
            return self.stringsTableViewController.data
        }
        set {
            self.stringsTableViewController.data = newValue
        }
    }
    
    public var didPrepareSubviewsContainer: ((UIView) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    public override var subviewsLayout: AnyLayout {
        return stack(.vertical)(
            self.stringsTableViewController.view,
            self.buttonContainer
        ).fillingParent(relativeToSafeArea: true)
    }
    
    public override func defineLayout() {
        super.defineLayout()
        self.stringsTableViewController.didMove(toParentViewController: self)
        self.didPrepareSubviewsContainer?(self.buttonContainer)
    }
    
    private let buttonContainer = UIView()
    private let stringsTableViewController = StringsTableViewController()
}
