//
//  FakeDomain.swift
//  DomainTestsSupport
//
//  Created by Bohdan Orlov on 17/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Platform
import PlatformTestsSupport
import Domain

public class FakeDomain { // This is a framework for Domain's mocks and fakes and other tests syntax sugar
    public init() {
        _ = Platform()
        _ = FakePlatform()
        _ = Domain()
    }
}
