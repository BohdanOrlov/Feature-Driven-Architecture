//
//  PlatformTestsSupport.swift
//  PlatformTestsSupport
//
//  Created by Bohdan Orlov on 18/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Platform

public class FakePlatform { // This is a framework for Platform's fakes and mocks, and tests syntax sugar
    public init() {
        _ = Platform()
    }
}
