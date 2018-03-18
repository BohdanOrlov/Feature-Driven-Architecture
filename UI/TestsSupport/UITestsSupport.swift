//
//  UITestsSupport.swift
//  UITestsSupport
//
//  Created by Bohdan Orlov on 18/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import UI
import Platform
import PlatformTestsSupport

public struct FakeUI { // This is a framework UI's mocks and fakes and other tests syntax sugar
    public init() {
        _ = Platform()
        _ = FakePlatform()
        _ = UI()
    }
}
