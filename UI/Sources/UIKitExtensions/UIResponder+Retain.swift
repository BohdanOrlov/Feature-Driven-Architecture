//
//  UIResponder+Retain.swift
//  UI
//
//  Created by Bohdan Orlov on 02/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {

    public func retain(_ object: AnyObject) {
        var retainedObjects = objc_getAssociatedObject(self, &AssosiatedObject.key) as? [AnyObject] ?? []
        retainedObjects.append(object)
        objc_setAssociatedObject(self, &AssosiatedObject.key, retainedObjects, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private struct AssosiatedObject {
        static var key = "Key"
    }
}
