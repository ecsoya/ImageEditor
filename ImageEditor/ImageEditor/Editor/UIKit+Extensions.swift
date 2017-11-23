//
//  UIKit+Extensions.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return self.origin.y
        }

        set {
            self.origin.y = newValue
        }
    }
    
    init(center: CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: upperLeft, size: size)
    }

    func centerWithSize(size: CGSize) -> CGRect {
        return CGRect(x: minX + (width - size.width) / 2,
                      y: midY + (height - size.height) / 2,
                      width: size.width,
                      height: size.height)
    }

    func expand(offset: CGFloat) -> CGRect {
        let center = CGPoint(x: midX, y: midY)
        let size = CGSize(width: offset * 2 + width, height: offset * 2 + height)
        return CGRect(center: center, size: size)
    }

    func expand(offset: CGSize) -> CGRect {
        let center = CGPoint(x: midX, y: midY)
        let size = CGSize(width: offset.width * 2 + width, height: offset.height * 2 + height)
        return CGRect(center: center, size: size)
    }

    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
    }
}

//Extension to get the scale values and rotate angle from transform
extension CGAffineTransform {
    public var scaleX: CGFloat {
        return sqrt(a * a + c * c)
    }
    public var scaleY: CGFloat {
        return sqrt(b * b + d * d)
    }
    public var rotationAngle: CGFloat {
        return atan2(b, a)
    }
}
