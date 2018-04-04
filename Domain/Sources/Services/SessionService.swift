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

public protocol SessionServiceProtocol: class {
    var observableSessionState: ReadonlyObservable<SessionState> { get }
    func startSession(username: String, password: String)
    func stopSession()
}

public class SessionService: SessionServiceProtocol {
    public lazy var observableSessionState = self.mutableObservableSessionState.makeReadonly()
    private let mutableObservableSessionState = MutableObservable<SessionState>(.readyToStart)
    
    private let userProvider: UserProviding
    private let userDefaults: UserDefaults
    private let persistenceKey: String
    
    static var persistenceSalt = 0 // in the split screen mode we have to keep persistant storages separate for separate session services
    
    public init(userProvider: UserProviding, userDefaults: UserDefaults) {
        self.userProvider = userProvider
        self.userDefaults = userDefaults
        self.persistenceKey = "blog.app.session.\(SessionService.persistenceSalt)"
        self.attemptToRestoreSession()
        SessionService.persistenceSalt += 1
    }
    
    public func startSession(username: String, password: String) {
        guard case .readyToStart = self.observableSessionState.value else {
            assertionFailure()
            return
        }
        self.mutableObservableSessionState.value = .starting
        self.userProvider.user(username: username) { [weak self] user in
            self?.handle(user)
        }
    }
    
    public func stopSession() {
        guard case .started(_) = self.observableSessionState.value else {
            assertionFailure()
            return
        }
        self.userDefaults.removeObject(forKey: self.persistenceKey)
        self.mutableObservableSessionState.value = .stopped
        self.mutableObservableSessionState.value = .readyToStart
    }
    
    private func handle(_ user: User?) {
        if let user = user {
            let session = Session(userId: user.id, username: user.username)
            self.mutableObservableSessionState.value = .started(session)
            self.userDefaults.set(try? PropertyListEncoder().encode(session), forKey: self.persistenceKey)
        } else {
            self.mutableObservableSessionState.value = .failed(NSError(domain: "", code: 0, userInfo: nil))
            self.mutableObservableSessionState.value = .readyToStart
        }
    }
    
    private func attemptToRestoreSession() {
        guard let encodedSession = userDefaults.object(forKey: self.persistenceKey) as? Data else { return }
        guard let session = try? PropertyListDecoder().decode(Session.self, from: encodedSession) else {
            assertionFailure()
            return
        }
        self.mutableObservableSessionState.value = .started(session)
    }
}
