//
//  ImageUtil.swift
//  ImageEditor
//
//  Created by Ecsoya on 24/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

enum IconStyle {
    case normal
    case disabled
    case highlighted
    case selected
}

class ImageUtil {

    static func image(_ name: String?, style: IconStyle = .normal) -> UIImage? {
        if let imageName = name {
            switch style {
            case .normal:
                return UIImage(named: imageName, in: Bundle(for: ImageUtil.self), compatibleWith: nil)
            case .disabled:
                return UIImage(named: "\(imageName).disabled", in: Bundle(for: ImageUtil.self), compatibleWith: nil)
            case.selected:
                return UIImage(named: "\(imageName).selected", in: Bundle(for: ImageUtil.self), compatibleWith: nil)
            case .highlighted:
                return UIImage(named: "\(imageName).highlighted", in: Bundle(for: ImageUtil.self), compatibleWith: nil)
            }
        }
        return nil
    }

    static func imageWithMissing(_ name: String?, style: IconStyle = .normal) -> UIImage {
        if let image = image(name, style: style) {
            return image
        }
        return UIImage.fromColor(UIColor.red, size: CGSize(width: 32, height: 32))!
    }

    static func setImage(for button: UIButton, withName name: String, isSelected: Bool = false) {
        button.setImage(image(name, style: .normal), for: .normal)
        button.setImage(image(name, style: .disabled), for: .disabled)
        button.setImage(image(name, style: .highlighted), for: .highlighted)
        if isSelected {
            button.setImage(image(name, style: .selected), for: .selected)
        }
    }
}
