//  Created by Bohdan Orlov on 03/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain


class PushNotificationButtonFeature {
    
    @discardableResult
    init(rootViewController: UIViewController, pushNotificationService: PushNotificationServiceProtocol) {
        guard let window = rootViewController.view.window else {
            assertionFailure()
            return
        }
        let button = UIButton(type: .system)
        button.setTitle("Simulate Push", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(button)
        button.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 20).isActive = true
        button.topAnchor.constraint(equalTo: window.topAnchor, constant: 20).isActive = true
        button.add(for: .touchUpInside) {
            pushNotificationService.push(notification: PushNotification.restart)
        }
    }
}
