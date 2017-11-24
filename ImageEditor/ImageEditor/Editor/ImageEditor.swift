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

    func buildActions(actions: inout [Action], globalActions: inout [Action])
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

    public var delegate: ImageEditorDelegate? {
        didSet {
            if let value = delegate, var actions = actionView.actions, var globalActions = actionView.globalActions {
                value.buildActions(actions: &actions, globalActions: &globalActions)
                actionView.actions = actions
                actionView.globalActions = globalActions
            }
        }
    }

    public var actionHeight = CGFloat(30)

    public var actionSpacing = CGFloat(2)

    let commandStack = CommandStack.INSTANCE

    fileprivate var visibleView: UIView!
    fileprivate var imageProcessor = ImageProcessor()
    fileprivate var actionView: ActionView!

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
            imageProcessor.center = center
        } else {
            imageProcessor.frame = computeImageViewFrame()
        }

        actionView.frame = CGRect(x: 0, y: self.bounds.height - actionHeight * 2, width: self.bounds.width, height: actionHeight * 2)
    }

    fileprivate func computeImageViewFrame() -> CGRect {
        var visibleArea = self.bounds.insetBy(dx: 10, dy: actionHeight * 2.1)
        if let holder = imageHolderView, let rect = holder.superview?.convert(holder.frame, to: self)  {
            visibleArea = rect.insetBy(dx: 10, dy: actionHeight * 2.1)
        }
        let center = visibleArea.center
        var width = CGFloat(0)
        var height = CGFloat(0)
        if let imageSize = imageProcessor.image?.size {
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

        self.addSubview(imageProcessor)

        actionView = ActionView(commandStack: commandStack)
        actionView.actions = buildActions()
        actionView.globalActions = buildGlobalActions()
        actionView.delegate = self
        self.addSubview(actionView)

        registerForOrientationChanges()
    }

    fileprivate func buildActions() -> [Action] {
        var actions = [Action]()
        let cropAction = Action(image: "crop")
        var cropActions = [Action]()
        cropActions.append(Action(image: "crop_free"))
        cropActions.append(Action(image: "crop_polygon"))
        cropActions.append(Action(image: "crop_oval"))
        cropAction.actions = cropActions
        actions.append(cropAction)
        actions.append(UndoAction(commandStack))
        return actions
    }

    fileprivate func buildGlobalActions() -> [Action] {
        return [UndoAction(commandStack), RedoAction(commandStack)]
    }

    fileprivate func updateImage() {
        imageViewCenter = nil
        imageProcessor.image = image
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

extension ImageEditor: ActionViewDelegate {
    func performAction(_ action: Action) {

    }

    func performCancel(_ exit: Bool) {
        if exit {
            self.removeFromSuperview()
        }
    }

    func performDone(_ exit: Bool) {
        if exit {
            delegate?.performDone(nil, bounds: nil)
            self.removeFromSuperview()
        }
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
