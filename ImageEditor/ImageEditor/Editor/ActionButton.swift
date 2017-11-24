//
//  ActionButton.swift
//  ImageEditor
//
//  Created by Ecsoya on 24/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

class ActionButton: UIButton, Observer {

    let action: Action
    var commandStack: CommandStack?
    init(_ action: Action, commandStack: CommandStack?) {
        self.action = action
        self.commandStack = commandStack
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        self.imageView?.contentMode = .scaleAspectFit
        ImageUtil.setImage(for: self, withName: action.image)
        self.isEnabled = action.isEnabled
        self.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        action.addObserver(self)

    }

    @objc func performAction() {
        if let command = action.command {
            if let commandExecutor = commandStack {
                commandExecutor.execute(command)
            } else if command.canExecute() {
                command.execute()
            }
        }
        action.execution?()
    }

    func observeChanged(_ property: String, oldValue: Any?, newValue: Any?) {
        if "isEnabled" == property, let isEnabled = newValue as? Bool {
            self.isEnabled = isEnabled
        }
    }
}
