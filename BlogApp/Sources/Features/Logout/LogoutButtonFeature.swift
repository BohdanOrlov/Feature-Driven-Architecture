//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Core
import Domain

class LogoutButtonFeature {
    private let viewPresenter: ViewPresenting
    private let sessionService: SessionServiceProtocol
    private let didLogout: () -> Void
    private weak var button: UIButton?
    
    @discardableResult
    init(viewPresenter: ViewPresenter, sessionService: SessionServiceProtocol, didLogout: @escaping () -> Void) {
        self.viewPresenter = viewPresenter
        self.sessionService = sessionService
        self.didLogout = didLogout
        self.start()
    }
    
    private func start() {
        let button = self.makeButton()
        self.button = button
        self.button?.retain(self)
        self.observer = self.sessionService.observableSessionState.observeAndCall(weakify(self, type(of: self).updateUIState))
    }    
    
    private func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.setTitle("Logout", for: .normal)
        button.add(for: .touchUpInside) { [weak self] in
            self?.sessionService.stopSession()
        }
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    private func updateUIState(_ session:SessionState) {
        guard let button = self.button else {
            return
        }
        switch session {
        case .started(_):
            self.viewPresenter.present(view: button)
            button.isEnabled = true
        case .stopped:
            self.viewPresenter.dismiss(view: button)
            self.didLogout()
            fallthrough
        case .readyToStart: fallthrough
        case .starting: fallthrough
        case .failed(_):
            button.isEnabled = false
        }
    }
    
    private var observer: AnyObject?
}
