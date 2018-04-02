//  Created by Bohdan Orlov on 27/02/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core
import UIKit
import Domain


protocol LoginViewDataRendering: class {
    var showsActivityIndicator: Bool { get set }
    var didTapButton: ((SessionCredentials) -> Void)? {get set}
}

typealias LoginViewControlling = LoginViewDataRendering & UIViewController

struct SessionCredentials {
    let username: String
    let password: String
}

class LoginViewController: UIViewController, LoginViewDataRendering {
    public var showsActivityIndicator: Bool {
        get {
            return self.activityIndicator.isAnimating
        }
        set {
            if newValue {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    var didTapButton: ((SessionCredentials) -> Void)?
    
    override func viewDidLoad() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.stackView)
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.activityIndicator)
        self.button.rightAnchor.constraint(equalTo: self.activityIndicator.leftAnchor, constant: 40).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.activityIndicator.centerYAnchor).isActive = true
        
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.addArrangedSubview(self.usernameField)
        stackView.addArrangedSubview(self.passwordField)
        stackView.addArrangedSubview(self.button)
        return stackView
    }()
    
    private lazy var usernameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username (Samantha)"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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



protocol LoginScreenInteracting {
    
}

protocol YellowDataViewDataSource {
}

protocol YellowDataViewDelegate {

}

typealias YellowDataViewAdapting = YellowDataViewDataSource & YellowDataViewDelegate

class YellowDataViewAdapter: YellowDataViewAdapting {
}

class LoginScreenFeature: LoginScreenInteracting {
    private weak var loginViewController: LoginViewControlling?
    private let viewControllerPresenter: ViewControllerPresenting
    private let sessionService: SessionServiceProtocol
    private let didLogin: (Session) -> Void
    private var observer: AnyObject?
    
    @discardableResult
    init(loginViewController: LoginViewControlling,
         viewControllerPresenter: ViewControllerPresenting,
         sessionService: SessionServiceProtocol,
         didLogin: @escaping (Session) -> Void) {
        self.viewControllerPresenter = viewControllerPresenter
        self.sessionService = sessionService
        self.didLogin = didLogin
        self.loginViewController = loginViewController
        
        self.loginViewController?.retain(self)
        self.loginViewController?.didTapButton = { [weak self] credentials in
            self?.sessionService.startSession(username: credentials.username, password: credentials.password)
        }
        self.observer = self.sessionService.observableSessionState.observeAndCall(weakify(self, type(of: self).updateUIState))
    }
    
    private func updateUIState(_ session:SessionState) {
        guard let loginViewController = self.loginViewController else { return }
        switch session {
        
        case .readyToStart:
            self.viewControllerPresenter.present(viewController: loginViewController, completion: { })
            fallthrough
        case .failed(_): fallthrough
        case .stopped:
            loginViewController.view.isUserInteractionEnabled = true
            loginViewController.showsActivityIndicator = false
        case .starting:
            loginViewController.view.isUserInteractionEnabled = false
            loginViewController.showsActivityIndicator = true
        case .started(let session):
            self.didLogin(session)
            loginViewController.showsActivityIndicator = false
        }
    }
}
