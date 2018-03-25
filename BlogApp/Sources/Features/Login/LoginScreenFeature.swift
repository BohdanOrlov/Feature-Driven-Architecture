//  Created by Bohdan Orlov on 27/02/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core
import UIKit
import Domain


protocol LoginViewDataRendering {
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
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -60).isActive = true
        self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.backgroundColor = UIColor.white
        
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.addArrangedSubview(self.usernameField)
        stackView.addArrangedSubview(self.passwordField)
        stackView.addArrangedSubview(self.button)
        stackView.addArrangedSubview(self.activityIndicator)
        return stackView
    }()
    
    private lazy var usernameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
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
    private let didLogin: () -> Void
    
    init(loginViewController: LoginViewControlling,
         viewControllerPresenter: ViewControllerPresenting,
         sessionService: SessionServiceProtocol,
         didLogin: @escaping () -> Void) {
        self.loginViewController = loginViewController
        self.viewControllerPresenter = viewControllerPresenter
        self.sessionService = sessionService
        self.didLogin = didLogin
        self.observer = self.sessionService.observableSessionState.observeAndCall(weakify(self, type(of: self).updateUIState))
        

        self.loginViewController?.didTapButton = {  credentials in
            // self captured intentionaly
            self.sessionService.startSession(username: credentials.username, password: credentials.password)
        }
        
        viewControllerPresenter.present(viewController: loginViewController, completion: {
            
        })
    }
    
    private var observer: AnyObject?
    
    private func updateUIState(_ session:SessionState) {
        switch session {
        case .readyToStart:
            self.loginViewController?.view.isUserInteractionEnabled = true
            self.loginViewController?.showsActivityIndicator = false
        case .starting:
            self.loginViewController?.view.isUserInteractionEnabled = false
            self.loginViewController?.showsActivityIndicator = true
        case .started(_):
            self.didLogin()
            self.loginViewController?.showsActivityIndicator = false
        case .failed(_):
            self.loginViewController?.view.isUserInteractionEnabled = true
            self.loginViewController?.showsActivityIndicator = false
            // TODO show error
        }
    }
    
}

