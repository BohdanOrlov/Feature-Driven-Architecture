//
//  Observable.swift
//  Architecture
//
//  Created by Bohdan Orlov on 10/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation

public typealias ComputedPropertyChanges = Void

public protocol ObserverProtocol: class {
    
}

public class ReadonlyObservable<T> {
    private let mutableObservable: MutableObservable<T>
    public var value: T {
        return mutableObservable.value
    }
    public init(_ mutableObservable: MutableObservable<T>) {
        self.mutableObservable = mutableObservable
    }
    
    public func observe(_ closure: @escaping (_ old: T, _ new: T) -> Void) -> ObserverProtocol {
        return self.mutableObservable.observe(closure)
    }
    
    public func observeAndCall(_ closure: @escaping (T) -> Void) -> ObserverProtocol {
        return self.mutableObservable.observeAndCall(closure)
    }
}

public class MutableObservable<T> {
    
    public init(_ value: T) {
        self._value = value
    }
    
    public var value: T {
        get {
            return _value
        }
        set {
            self.setValue(newValue)
        }
    }
    
    public func makeReadonly() -> ReadonlyObservable<T> {
        return ReadonlyObservable<T>(self)
    }
    
    /**
     Sets new value allowing specifying which observers shouldn't be notified
     
     - parameter value: the new value
     - parameter withoutNofiyingObservers: observers that won't be notified. For convenience of the caller, you can pass nil in the collection
     */
    public func setValue(_ value: T, withoutNofiyingObservers blacklistedObservers: [ObserverProtocol?] = []) {
        let oldValue = self._value
        self._value = value
        
        let blacklistedObserverPointers = Set(blacklistedObservers.flatMap({ return ($0 as? ObserverWrapper<T>)?.observer }).map({ return Unmanaged.passUnretained($0).toOpaque() }))
        for observer in self.observers {
            let observerIsBlacklisted = blacklistedObserverPointers.contains(Unmanaged.passUnretained(observer).toOpaque())
            if !observerIsBlacklisted {
                observer.closure(oldValue, self.value)
            }
        }
    }
    
    private var _value: T
    
    /**
     Subscribes to a notification.
     
     Returns an opaque observer that needs to be retained. This opaque observer unsubscribes automatically on dealloc.
     
     @return AnyObject Opaque observer
     */
    public func observe(_ closure: @escaping (_ old: T, _ new: T) -> Void) -> ObserverProtocol {
        let observer = Observer(closure: closure)
        self.observers.append(observer)
        return ObserverWrapper(observer: observer, onDeinit: { [weak self] observer in
            self?.removeObserver(observer)
        })
    }
    
    public func observeAndCall(_ closure: @escaping (T) -> Void) -> ObserverProtocol {
        let observer = self.observe({ _, new in
            closure(new)
        })
        closure(self.value)
        return observer
    }
    
    fileprivate func removeObserver(_ observer: Observer<T>) {
        self.observers = self.observers.filter { $0 !== observer }
    }
    
    private lazy var observers = [Observer<T>]()
}

public class Stream<T> {
    private let mutableStream: MutableStream<T>
    public init(_ mutableStream: MutableStream<T>) {
        self.mutableStream = mutableStream
    }
    
    public func subscribe(_ closure: @escaping (_ value: T) -> Void) -> ObserverProtocol {
        return self.mutableStream.subscribe(closure)
    }
}

public class MutableStream<T> {
    
    public init() {
    }
    
    public func makeReadonly() -> Stream<T> {
        return Stream<T>(self)
    }
    
    public func emit(value: T) {
        for observer in self.observers {
            observer.closure(value, value)
        }
    }
    
    public func subscribe(_ closure: @escaping (_ value: T) -> Void) -> ObserverProtocol {
        let observer = Observer(closure: { _, value in
            closure(value)
        })
        self.observers.append(observer)
        return ObserverWrapper(observer: observer, onDeinit: { [weak self] observer in
            self?.removeObserver(observer)
        })
    }
    
    fileprivate func removeObserver(_ observer: Observer<T>) {
        self.observers = self.observers.filter { $0 !== observer }
    }
    
    private lazy var observers = [Observer<T>]()
}

private class Observer<T> {
    let closure: (_ old: T, _ new: T) -> Void
    init (closure: @escaping (_ old: T, _ new: T) -> Void) {
        self.closure = closure
    }
}

private class ObserverWrapper<T>: ObserverProtocol {
    let observer: Observer<T>
    let onDeinit: (Observer<T>) -> Void
    
    init(observer: Observer<T>, onDeinit: @escaping (Observer<T>) -> Void) {
        self.observer = observer
        self.onDeinit = onDeinit
    }
    
    deinit {
        self.onDeinit(self.observer)
    }
}
