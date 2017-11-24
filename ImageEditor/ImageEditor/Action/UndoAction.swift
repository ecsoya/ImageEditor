//
//  UndoAction.swift
//  ImageEditor
//
//  Created by Ecsoya on 24/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

public class UndoAction: Action, Observer {

    public let commandStack: CommandStack

    public init(_ commandStack: CommandStack) {
        self.commandStack = commandStack
        super.init(image: "undo")
        self.execution = {
            commandStack.undo()
        }
        updateEnabled()
        commandStack.addObserver(self)
    }

    fileprivate func updateEnabled() {
        self.isEnabled = commandStack.canUndo()
    }

    public func observeChanged(_ observable: Observable) {
        updateEnabled()
    }
}
