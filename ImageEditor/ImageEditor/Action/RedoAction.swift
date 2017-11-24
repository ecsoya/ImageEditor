//
//  RedoAction.swift
//  ImageEditor
//
//  Created by Ecsoya on 24/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

class RedoAction: Action, Observer {

    public let commandStack: CommandStack

    public init(_ commandStack: CommandStack) {
        self.commandStack = commandStack
        super.init(image: "redo")
        self.execution = {
            commandStack.redo()
        }
        updateEnabled()
        commandStack.addObserver(self)
    }

    fileprivate func updateEnabled() {
        self.isEnabled = commandStack.canRedo()
    }

    public func observeChanged(_ observable: Observable) {
        updateEnabled()
    }
}
