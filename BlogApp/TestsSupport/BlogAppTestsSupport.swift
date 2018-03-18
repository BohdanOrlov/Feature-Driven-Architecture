//
//  BlogAppTestsSupport.swift
//  BlogAppTestsSupport
//
//  Created by Bohdan Orlov on 18/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Platform
import PlatformTestsSupport
import Domain
import DomainTestsSupport
import UI
import UITestsSupport
import BlogApp

public struct FakeBlogApp { // This is a framework for BlogApp's mocks and fakes and other tests syntax sugar
    public init() {
        _ = Platform()
        _ = FakePlatform()
        _ = Domain()
        _ = FakeDomain()
        _ = UI()
        _ = FakeUI()
        _ = BlogApp()
    }
}
