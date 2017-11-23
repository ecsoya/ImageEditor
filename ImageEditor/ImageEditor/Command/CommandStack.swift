//
//  CommandStack.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

class CommandStack {

    static let INSTANCE: CommandStack = CommandStack()

    fileprivate var undoable = [Command]()
    fileprivate var redoable = [Command]()

    fileprivate init() {

    }

    func execute(_ command: Command) {
        if !command.canExecute() {
            return
        }
        undoable.append(command)
    }

    func canRedo() -> Bool {
        if !redoable.isEmpty, let command = redoable.last {
            return command.canRedo()
        }
        return false
    }

    func canUndo() -> Bool {
        if !undoable.isEmpty, let command = undoable.last {
            return command.canUndo()
        }
        return false
    }
    
    func redo() {
        if canRedo() {
            let command = redoable.removeLast()
            command.execute()
            undoable.append(command)
        }
    }

    func undo() {
        if canUndo() {
            let command = undoable.removeLast()
            command.undo()
            redoable.append(command)
        }
    }
}
