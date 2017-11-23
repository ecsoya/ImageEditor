//
//  ImageEditor.swift
//  ImageEditor
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit

public protocol ImageEditorDelegate {
    func performDone(_ image: UIImage?, bounds: CGRect?)
}

public class ImageEditor: UIView, ImageEditProtocol {

    public var imageHolderView: UIView? {
        didSet {
            setNeedsLayout()
        }
    }

    public var image: UIImage? {
        didSet {
            updateImage()
        }
    }

    public var delegate: ImageEditorDelegate?

    public var actionHeight = CGFloat(22)

    public var actionSpacing = CGFloat(2)

    fileprivate var visibleView: UIView!
    fileprivate var imageView: UIImageView!
    fileprivate var actionView: UIView!

    fileprivate var imageViewCenter: CGPoint?

    public init() {
        super.init(frame: CGRect.zero)
        createContents()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createContents()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let holder = imageHolderView, let frame = holder.superview?.convert(holder.frame, to: self) {
            visibleView.frame = frame
        } else {
            visibleView.frame = self.bounds
        }

        if let center = imageViewCenter {
            imageView.center = center
        } else {
            imageView.frame = computeImageViewFrame()
        }

        actionView.frame = CGRect(x: 0, y: self.bounds.height - actionHeight * 2, width: self.bounds.width, height: actionHeight * 2)
    }

    fileprivate func computeImageViewFrame() -> CGRect {
        var visibleArea = self.bounds
        if let holder = imageHolderView, let rect = holder.superview?.convert(holder.frame, to: self)  {
            visibleArea = rect
        }
        let center = visibleArea.center
        var width = CGFloat(0)
        var height = CGFloat(0)
        if let imageSize = imageView.image?.size {
            if imageSize.width < visibleArea.width && imageSize.height < visibleArea.height {
                width = imageSize.width
                height = imageSize.height
            } else {
                let scale = min(visibleArea.width / imageSize.width, visibleArea.height / imageSize.height)
                width = imageSize.width * scale
                height = imageSize.height * scale
            }
        }
        return CGRect(center: center, size: CGSize(width: width, height: height))
    }

    fileprivate func createContents() {
        visibleView = UIView()
        self.addSubview(visibleView)

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.yellow.cgColor
        self.addSubview(imageView)

        actionView = UIView()
        self.addSubview(actionView)

        registerForOrientationChanges()
    }

    fileprivate func updateImage() {
        imageViewCenter = nil
        imageView.image = image
        setNeedsLayout()
    }

    fileprivate func registerForOrientationChanges() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(ImageEditor.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    fileprivate func unregisterFromOrientationChanges() {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    @objc func orientationChanged() {
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                self.setNeedsLayout()
            }
        }
    }

    deinit {
        unregisterFromOrientationChanges()
    }

}

extension ImageEditor {
    public static func createImageEditor() -> ImageEditor? {
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        let imageEditor = ImageEditor()

        imageEditor.translatesAutoresizingMaskIntoConstraints = false

        let views = ["imageEditor": imageEditor]

        window.addSubview(imageEditor)
        window.bringSubview(toFront: imageEditor)

        window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageEditor]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageEditor]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        window.setNeedsLayout()

        return imageEditor
    }
}
