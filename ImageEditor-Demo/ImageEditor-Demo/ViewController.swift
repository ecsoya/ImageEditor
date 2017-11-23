//
//  ViewController.swift
//  ImageEditor-Demo
//
//  Created by Ecsoya on 23/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit
import ImageEditor

class ViewController: UIViewController {


    fileprivate var button: UIButton!

    fileprivate var shrinkButton: UIButton!
    fileprivate var expandButton: UIButton!
    fileprivate var imageContainer: UIView!

    fileprivate var imageContainerFrame: CGRect? {
        didSet {
            self.view.setNeedsLayout()
        }
    }

    fileprivate var currentImageEditor: ImageEditor?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGray
        imageContainer = UIView()
        imageContainer.backgroundColor = UIColor.white
        self.view.addSubview(imageContainer)

        shrinkButton = UIButton(type: .custom)
        shrinkButton.setTitle("Shrink", for: .normal)
        shrinkButton.backgroundColor = UIColor.blue
        shrinkButton.addTarget(self, action: #selector(performShrink(_:)), for: .touchUpInside)
        self.view.addSubview(shrinkButton)

        expandButton = UIButton(type: .custom)
        expandButton.setTitle("Expand", for: .normal)
        expandButton.backgroundColor = UIColor.blue
        expandButton.addTarget(self, action: #selector(performExpand(_:)), for: .touchUpInside)
        self.view.addSubview(expandButton)

        button = UIButton(type: .custom)
        button.setTitle("Import Image", for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(performImportImage(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            if let rect = self.imageContainerFrame {
                let newRect = rect.applying(CGAffineTransform(rotationAngle: context.targetTransform.rotationAngle))
                self.imageContainerFrame = CGRect(center: CGPoint(x: size.width / 2, y: size.height / 2), size: newRect.size)
            }

        }) { (context) in
            self.currentImageEditor?.setNeedsLayout()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let frame = imageContainerFrame {
            imageContainer.frame = frame
        } else {
            imageContainer.frame = self.view.bounds
        }
        shrinkButton.frame = CGRect(x: 0, y: 10, width: 100, height: 22)
        expandButton.frame = CGRect(x: 110, y: 10, width: 100, height: 22)
        button.frame = CGRect(x: self.view.bounds.width - 200, y: 10, width: 200, height: 22)
    }

    @objc func performShrink (_ sender: UIButton)  {
        if let rect = imageContainerFrame {
            let value = rect.insetBy(dx: 10, dy: 10)
            if value.width > 50 && value.height > 50 {
                imageContainerFrame = value
            }
        } else {
            imageContainerFrame = self.view.bounds.insetBy(dx: 10, dy: 10)
        }
        self.view.setNeedsLayout()
    }

    @objc func performExpand (_ sender: UIButton)  {
        if let rect = imageContainerFrame {
            let value = rect.insetBy(dx: -10, dy: -10)
            if value.width < self.view.bounds.width && value.height < self.view.bounds.height {
                imageContainerFrame = value
            }
        }
        self.view.setNeedsLayout()
    }

    @objc func performImportImage (_ sender: UIButton)  {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func displayImageEditor(_ image: UIImage) {
        currentImageEditor?.removeFromSuperview()
        if let imageEditor = ImageEditor.createImageEditor() {
            imageEditor.delegate = self
            imageEditor.image = image
            imageEditor.imageHolderView = imageContainer
            currentImageEditor = imageEditor
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.displayImageEditor(image)
            })
        }
    }
}

extension ViewController: ImageEditorDelegate {
    func performDone(_ image: UIImage?, bounds: CGRect?) {
        if let newImage = image, let frame = bounds {
            let imageView = UIImageView(frame: frame)
            imageView.image = newImage
            imageContainer.addSubview(imageView)
        }
        currentImageEditor?.removeFromSuperview()
    }
}
