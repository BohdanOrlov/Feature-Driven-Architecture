//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

class WindowFrameFeature {
    
    init(screenBounds: CGRect, splitScreen: Bool, didDefineScreenFrames: (CGRect) -> Void) {
        guard splitScreen else {
            didDefineScreenFrames(screenBounds)
            return
        }
        let gap: CGFloat = 10
        let screenRect = screenBounds
        var (top, bottom) = screenRect.divided(atDistance: screenRect.midY, from: CGRectEdge.minYEdge)
        top.size.height -= gap
        bottom.size.height -= gap
        bottom.origin.y += gap
        [top, bottom].forEach(didDefineScreenFrames)
    }
}
