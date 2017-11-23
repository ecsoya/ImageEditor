//
//  ImageEditProtocol.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

public protocol ImageEditProtocol {

    var image: UIImage? {get set}

    var imageHolderView: UIView? {get set}
}
