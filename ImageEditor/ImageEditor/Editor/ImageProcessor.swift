//
//  ImageProcessor.swift
//  ImageEditor
//
//  Created by Ecsoya on 24/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

public class ImageProcessor: UIImageView {

    public init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        self.contentMode = .scaleAspectFit
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blue.cgColor
    }

}
