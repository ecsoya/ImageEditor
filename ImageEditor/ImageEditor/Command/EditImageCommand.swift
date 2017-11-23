//
//  EditImageCommand.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

public class EditImageCommand: Command {

    public var editor: ImageEditProtocol?

    public var newImage: UIImage?

    fileprivate var oldImage: UIImage?

    init(_ imageEditor: ImageEditProtocol? = nil) {
        self.editor = imageEditor
    }

    public override func canExecute() -> Bool {
        return editor != nil && newImage != nil
    }
    

    public override func canUndo() -> Bool {
        return editor != nil && oldImage != nil
    }

    public override func execute() {
        self.oldImage = editor?.image
        editor?.image = newImage
    }

    public override func undo() {
        editor?.image = oldImage
    }

}
