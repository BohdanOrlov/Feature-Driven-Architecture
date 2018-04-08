//  Created by Bohdan Orlov on 03/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Core
import Domain

public class RestartPushNotificationFeature {
    
    @discardableResult
    public init(pushNotificationService: PushNotificationServiceProtocol, didReceiveRestartRequest: @escaping () -> Void) {
        observer = pushNotificationService.lastReceivedPush.observe { _, notification in
            if case .restart? = notification {
                didReceiveRestartRequest()
            }
        }
        pushNotificationService.retain(self)
    }
    
    private let observer: AnyObject
}
