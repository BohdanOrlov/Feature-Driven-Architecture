//
//  ViewPresenter.swift
//  Architecture
//
//  Created by Bohdan Orlov on 03/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewPresenting: AnyObject {
    func present(view: UIView)
    func dismiss(view: UIView)
}

public class ViewPresenter: ViewPresenting {
    
    private weak var rootView: UIView?
    
    public init(rootView: UIView) {
        self.rootView = rootView
    }
    
    public func present(view: UIView) {
        guard let rootView = self.rootView else { return }
        rootView.addSubview(view)
        view.leftAnchor.constraint(equalTo: rootView.leftAnchor).isActive = true
        view.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rootView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
    }
    
    public func dismiss(view: UIView) {
        view.removeFromSuperview()
    }
}
