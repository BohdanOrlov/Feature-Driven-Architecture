//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

protocol UIWindowOwner: class {
    var windows: [String: UIWindow] { get set }
}

class WindowFeature {
    @discardableResult
    init(windowFrame: CGRect, windowOwner: UIWindowOwner, didSetupWindow: @escaping (UIViewController) -> Void) {
        let windowKey = windowFrame.debugDescription
        let window = UIWindow(frame: windowFrame)
        let oldWindow = windowOwner.windows[windowKey]
        let rootViewController = ViewController()
        rootViewController.didLoad = {
            if let oldWindow = oldWindow {
                if let viewController = oldWindow.rootViewController {
                    viewController.dismiss(animated: false, completion: nil)
                }
                oldWindow.rootViewController = nil
            }
            didSetupWindow(rootViewController)
        }
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        windowOwner.windows[windowKey] = window
        
    }
}
