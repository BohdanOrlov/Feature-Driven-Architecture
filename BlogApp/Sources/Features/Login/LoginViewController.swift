//
//  LoginViewController.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 02/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Layoutless

struct SessionCredentials {
    let username: String
    let password: String
}

protocol LoginRendering: class {
    var isUserInteractionEnabled: Bool { get set }
    var showsActivityIndicator: Bool { get set }
    var didTapButton: ((SessionCredentials) -> Void)? { get set }
}

typealias LoginViewControlling = LoginRendering & UIViewController

class LoginViewController: ViewController, LoginRendering {
    
    var isUserInteractionEnabled: Bool {
        get {
            return view.isUserInteractionEnabled
        }
        set {
            view.isUserInteractionEnabled = newValue
        }
    }
    
    var showsActivityIndicator: Bool {
        get {
            return activityIndicator.isAnimating
        }
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    var didTapButton: ((SessionCredentials) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .white
        self.view.addSubview(self.activityIndicator)
        self.button.rightAnchor.constraint(equalTo: self.activityIndicator.leftAnchor, constant: 40).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.activityIndicator.centerYAnchor).isActive = true
        
    }
    
    override var subviewsLayout: AnyLayout {
        return stack(.vertical, spacing: 20, alignment: .fill)(
            usernameField,
            passwordField,
            button
        ).centeringInParent().sizing(toWidth: 200)
    }
    
    private lazy var usernameField = UITextField()
        .set(\.placeholder, "Username (Samantha)")
        .set(\.borderStyle, .line)
    
    private let passwordField = UITextField()
        .set(\.placeholder, "Password")
        .set(\.borderStyle, .line)
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    @objc
    private func onButtonTap() {
        self.didTapButton?(SessionCredentials(username: self.usernameField.text ?? "", password: self.passwordField.text ?? ""))
    }
}
