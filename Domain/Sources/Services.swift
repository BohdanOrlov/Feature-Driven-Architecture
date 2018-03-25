//
//  Services.swift
//  Domain
//
//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import Core

public enum SessionState {
    case readyToStart
    case starting
    case started(Session)
    case failed(Error)
}

public protocol SessionServiceProtocol {
    var observableSessionState: ReadonlyObservable<SessionState> { get }
    func startSession(username: String, password: String)
}

public class SessionService: SessionServiceProtocol {
    public lazy var observableSessionState = self.mutableObservableSessionState.makeReadonly()
    private let mutableObservableSessionState = MutableObservable<SessionState>(.readyToStart)
    
    public init() {
    }
    
    public func startSession(username: String, password: String) {
        guard case .readyToStart = self.observableSessionState.value else {
            assertionFailure()
            return
        }
        self.mutableObservableSessionState.value = .starting
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in
            self?.mutableObservableSessionState.value = .started(Session(username: username))
        }
    }
}


public protocol PushNotificationServiceProtocol: class {
    var didReceivePush: ((PushNotification) -> Void)? { get set }
    func push(notification: PushNotification)
}

public class PushNotificationService: PushNotificationServiceProtocol {
    public var didReceivePush: ((PushNotification) -> Void)?
    
    public init() {}
    
    public func push(notification: PushNotification) {
        self.didReceivePush?(notification)
    }
}

public protocol postsStoring {
    var posts: [Post] { get }
}

public class postsRepository: postsStoring {
    public private(set) var posts = [Post]()
    
    public init() {
        posts = (0...5).map {
            Post(text: "Note \($0)")
        }
    }
}
