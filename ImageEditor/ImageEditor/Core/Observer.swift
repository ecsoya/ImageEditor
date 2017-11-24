//
//  Observer.swift
//  Impasto
//
//  Created by Ecsoya on 28/03/2017.
//  Copyright © 2017 Soyatec. All rights reserved.
//

import Foundation

@objc public protocol Observer {

    @objc optional func observeChanged(_ observable: Observable, property: String, oldValue: Any?, newValue: Any?)
    @objc optional func observeChanged(_ property: String, oldValue: Any?, newValue: Any?)
    @objc optional func observeChanged(_ observable: Observable)
}

open class Observable: NSObject {

    open var observers = NSMutableArray()

    open func firePropertyChanges(_ property: String, oldValue: Any?, newValue: Any?) {
        if oldValue == nil && newValue == nil {
            return
        }
        if let oldVal = oldValue as? NSObject, let newVal = newValue as? NSObject, oldVal == newVal {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {
                return
            }
            _ = this.observers.map { (object) -> () in
                if let observer = object as? Observer {
                    observer.observeChanged?(this, property: property, oldValue: oldValue, newValue: newValue)
                    observer.observeChanged?(property, oldValue: oldValue, newValue: newValue)
                }
            }
        }
        firePropertyChanges()
    }

    open func firePropertyChanges() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {
                return
            }
            _ = this.observers.map { (object) -> () in
                if let observer = object as? Observer {
                    observer.observeChanged?(self!)
                }
            }
        }
    }

    open func addObserver(_ observer: Observer) {
        observers.add(observer)
    }

    open func removeObserver(_ observer: Observer) {
        observers.remove(observer)
    }
}
