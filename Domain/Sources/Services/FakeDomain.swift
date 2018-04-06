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

public final class FakeSessionService: SessionServiceProtocol {
    
    public init() { }
    
    public var observableSessionState: ReadonlyObservable<SessionState> {
        return stubbedSessionState.makeReadonly()
    }
    
    public var startSessionCalled = false
    public var stopSessionCalled = false
    
    public var stubbedSessionState = MutableObservable<SessionState>(.readyToStart)
    
    public func startSession(username: String, password: String) {
        startSessionCalled = true
    }
    
    public func stopSession() {
        stopSessionCalled = true
    }
}
