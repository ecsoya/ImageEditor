//
//  Command.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

public class Command: NSObject {
    
    public  func canExecute() -> Bool {
        return true
    }
    
    public func canRedo() -> Bool {
        return canExecute()
    }
    
    public func canUndo() -> Bool{
        return true
    }
    
    public func execute() {}
    
    public func undo() {}
}
