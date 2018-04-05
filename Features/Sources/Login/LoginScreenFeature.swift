//  Created by Bohdan Orlov on 27/02/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Core
import Domain
import UI

public class LoginScreenFeature {
    private weak var loginViewController: LoginViewControlling?
    private let viewControllerPresenter: ViewControllerPresenting
    private let sessionService: SessionServiceProtocol
    private let didLogin: (Session) -> Void
    private var observer: AnyObject?
    
    @discardableResult
    public init(loginViewController: LoginViewControlling,
         viewControllerPresenter: ViewControllerPresenting,
         sessionService: SessionServiceProtocol,
         didLogin: @escaping (Session) -> Void) {
        self.viewControllerPresenter = viewControllerPresenter
        self.sessionService = sessionService
        self.didLogin = didLogin
        self.loginViewController = loginViewController
        self.start()
    }
    
    private func start() {
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
            self.presentLoginScreenIfNeeded()
            fallthrough
        case .failed(_): fallthrough
        case .stopped:
            loginViewController.isUserInteractionEnabled = true
            loginViewController.showsActivityIndicator = false
        case .starting:
            loginViewController.isUserInteractionEnabled = false
            loginViewController.showsActivityIndicator = true
        case .started(let session):
            self.presentLoginScreenIfNeeded()
            self.didLogin(session)
            loginViewController.showsActivityIndicator = false
        }
    }
    
    private func presentLoginScreenIfNeeded() {
        guard let loginViewController = self.loginViewController, loginViewController.presentingViewController == nil else { return }
        self.viewControllerPresenter.present(viewController: loginViewController, completion: { })
    }
}
