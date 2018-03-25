//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit


class LogoutFeature {
    private let didLogout: () -> Void
    
    init(viewPresenter: ViewPresenter, didLogout: @escaping () -> Void) {
        self.didLogout = didLogout
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.setTitle("Logout", for: .normal)
        button.add(for: .touchUpInside) {
            self.didLogout()
        }
        button.setTitleColor(.black, for: .normal)
        viewPresenter.present(view: button)
    }
    
}

class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func add (for controlEvents: UIControlEvents, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
