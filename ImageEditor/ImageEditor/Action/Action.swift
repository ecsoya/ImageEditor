//
//  Action.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

open class Action: Observable {

    open var image: String {
        didSet {
            firePropertyChanges("image", oldValue: oldValue, newValue: image)
        }
    }

    open var command: Command? {
        didSet {
            firePropertyChanges("command", oldValue: oldValue, newValue: command)
        }
    }

    open var actions: [Action]? {
        didSet {
            firePropertyChanges("actions", oldValue: oldValue, newValue: actions)
        }
    }

    open var isEnabled = true {
        didSet {
            firePropertyChanges("isEnabled", oldValue: oldValue, newValue: isEnabled)
        }
    }

    open var execution: (() -> Void)?

    public init(image: String) {
        self.image = image
        super.init()
    }

    public convenience init(image: String, command: Command?) {
        self.init(image: image)
        self.command = command
    }

    public convenience init(image: String, execution: (() -> Void)? ) {
        self.init(image: image)
        self.execution = execution
    }
}

extension Action {
    public static func createAction(_ image: String, execution: (() -> Void)?) -> Action {
        return Action(image: image, execution: execution)
    }
}
