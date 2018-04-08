//
//  UIControl+ClosureCallback.swift
//  UI
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Core

class ClosureBox {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
    
}

extension UIControl {
    public func add (for controlEvents: UIControlEvents, _ closure: @escaping ()->()) {
        let closureBox = ClosureBox(closure)
        addTarget(closureBox, action: #selector(ClosureBox.invoke), for: controlEvents)
        self.retain(closureBox)
    }
}
