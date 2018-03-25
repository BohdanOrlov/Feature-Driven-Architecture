//  Created by Bohdan Orlov on 03/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain


class RestartPushNotificationFeature {
    init(pushNotificationService: PushNotificationServiceProtocol, didReceiveRestartRequest: @escaping () -> Void) {
        pushNotificationService.didReceivePush = { notification in
            if case .restart = notification {
                didReceiveRestartRequest()
            }
        }
    }
}
