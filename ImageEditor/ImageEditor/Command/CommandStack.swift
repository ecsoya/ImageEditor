//
//  CommandStack.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

public class CommandStack: Observable {

    public static let INSTANCE: CommandStack = CommandStack()

    fileprivate var undoable = [Command]()
    fileprivate var redoable = [Command]()

    public override init() {
        super.init()
    }

    public func execute(_ command: Command) {
        if !command.canExecute() {
            return
        }
        undoable.append(command)
        firePropertyChanges()
    }

    public func canRedo() -> Bool {
        if !redoable.isEmpty, let command = redoable.last {
            return command.canRedo()
        }
        return false
    }

    public func canUndo() -> Bool {
        if !undoable.isEmpty, let command = undoable.last {
            return command.canUndo()
        }
        return false
    }

    public func redo() {
        if canRedo() {
            let command = redoable.removeLast()
            command.execute()
            undoable.append(command)
            firePropertyChanges()
        }
    }

    public func undo() {
        if canUndo() {
            let command = undoable.removeLast()
            command.undo()
            redoable.append(command)
            firePropertyChanges()
        }
    }
}
