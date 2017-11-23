//
//  Action.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

class Action {

    let image: UIImage

    let command: Command

    init(image: UIImage, command: Command) {
        self.image = image
        self.command = command
    }
}
