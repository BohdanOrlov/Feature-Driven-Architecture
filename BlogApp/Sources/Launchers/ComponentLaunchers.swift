//
//  ComponentLaunchers.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 31/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import UI
import Domain

extension LogoutButtonFeature {
    static func launch(buttonContainer: UIView, sessionService: SessionServiceProtocol, didLogout: @escaping () -> Void) {
        LogoutButtonFeature(viewPresenter: ViewPresenter(rootView: buttonContainer), sessionService: sessionService, didLogout: didLogout)
    }
}
