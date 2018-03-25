//
//  FakeDomain.swift
//  DomainTestsSupport
//
//  Created by Bohdan Orlov on 17/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core
import CoreTestsSupport
import Domain

public class FakeDomain { // This is a framework for Domain's mocks and fakes and other tests syntax sugar
    public init() {
        _ = Core()
        _ = FakeCore()
        _ = Domain()
    }
}
