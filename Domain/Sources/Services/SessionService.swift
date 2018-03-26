//
//  SessionService.swift
//  Domain
//
//  Created by Bohdan Orlov on 25/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core

public enum SessionState {
    case readyToStart
    case starting
    case started(Session)
    case stopped
    case failed(Error)
}

public protocol SessionServiceProtocol {
    var observableSessionState: ReadonlyObservable<SessionState> { get }
    func startSession(username: String, password: String)
    func stopSession()
}

public class SessionService: SessionServiceProtocol {
    public lazy var observableSessionState = self.mutableObservableSessionState.makeReadonly()
    private let mutableObservableSessionState = MutableObservable<SessionState>(.readyToStart)
    
    private let userProvider: UserProviding
    
    public init(userProvider: UserProviding) {
        self.userProvider = userProvider
    }
    
    public func startSession(username: String, password: String) {
        guard case .readyToStart = self.observableSessionState.value else {
            assertionFailure()
            return
        }
        self.mutableObservableSessionState.value = .starting
        self.userProvider.user(username: username) { [weak self] user in
            if let user = user {
                self?.mutableObservableSessionState.value = .started(Session(userId: user.id, username: user.username))
            } else {
                self?.mutableObservableSessionState.value = .failed(NSError(domain: "", code: 0, userInfo: nil))
                self?.mutableObservableSessionState.value = .readyToStart
            }
        }
    }
    
    public func stopSession() {
        guard case .started(_) = self.observableSessionState.value else {
            assertionFailure()
            return
        }
        self.mutableObservableSessionState.value = .stopped
        self.mutableObservableSessionState.value = .readyToStart
    }
}
