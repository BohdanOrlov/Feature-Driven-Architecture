//
//  KeyPathBuildable.swift
//  Core
//
//  Created by Bohdan Orlov on 02/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public protocol KeyPathBuildable {}

extension NSObject: KeyPathBuildable {}

extension KeyPathBuildable where Self: Any {
    public func set<T>(_ property: ReferenceWritableKeyPath<Self, T>, _ value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}
