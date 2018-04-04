//
//  UserDefaults+Reset.swift
//  Core
//
//  Created by Bohdan Orlov on 03/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation



extension UserDefaults {
    //    @objc
    //dynamic
    public func reset() {
        removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        synchronize()
    }
}


public func preventsWeirdCrash() {
    // not making this call resulted in urecognized selector on calling reset
}
