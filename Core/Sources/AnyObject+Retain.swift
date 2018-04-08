//
//  AnyObject+Retain.swift
//  Core
//
//  Created by Bohdan Orlov on 08/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation


public protocol Retaining {
}


private struct AssosiatedObject {
    static var key = "Key"
}

extension Retaining where Self: AnyObject {
    public func retain(_ object: AnyObject) {
        var retainedObjects = objc_getAssociatedObject(self, &AssosiatedObject.key) as? [AnyObject] ?? []
        retainedObjects.append(object)
        objc_setAssociatedObject(self, &AssosiatedObject.key, retainedObjects, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension NSObject: Retaining {}
