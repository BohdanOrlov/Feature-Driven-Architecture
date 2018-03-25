//
//  BlogAppTestsSupport.swift
//  BlogAppTestsSupport
//
//  Created by Bohdan Orlov on 18/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core
import CoreTestsSupport
import Domain
import DomainTestsSupport
import UI
import UITestsSupport
import BlogApp

public struct FakeBlogApp { // This is a framework for BlogApp's mocks and fakes and other tests syntax sugar
    public init() {
        _ = Core()
        _ = FakeCore()
        _ = Domain()
        _ = FakeDomain()
        _ = UI()
        _ = FakeUI()
        _ = BlogApp()
    }
}
