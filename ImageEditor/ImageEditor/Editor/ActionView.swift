//
//  ImageEditorActionView.swift
//  ImageEditor
//
//  Created by Ecsoya on 24/11/2017.
//  Copyright © 2017 Ecsoya. All rights reserved.
//

import UIKit
import Layoutable

protocol ActionViewDelegate {
    func performAction(_ action: Action)
    func performCancel(_ exit: Bool)
    func performDone(_ exit: Bool)
}

class ActionView: LayoutableView, WeightsLayoutDelegate {

    var actions: [Action]? {
        didSet {
            lastActions = oldValue
            update(actionsView, with: actions)
        }
    }

    var globalActions: [Action]? {
        didSet {
            update(globalActionsView, with: globalActions)
        }
    }

    var commandStack: CommandStack?

    var actionSize = CGSize(width: 22, height: 22) {
        didSet {
            setNeedsLayout()
        }
    }

    var actionSpacing = CGFloat(6) {
        didSet {
            setNeedsLayout()
        }
    }

    var delegate: ActionViewDelegate?

    fileprivate lazy var globalActionsView = self.makeStackView()
    fileprivate lazy var actionsView = self.makeStackView()
    fileprivate lazy var cancelButton = self.createCancelButton()
    fileprivate lazy var doneButton = self.createDoneButton()

    fileprivate var lastActions: [Action]?

    init(commandStack: CommandStack? = CommandStack.INSTANCE) {
        self.commandStack = commandStack
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        self.layout?.horizontal = false
        self.layout?.weights = [1, 1]
        self.layout?.delegate = self

        let topView = UIView()
        topView.backgroundColor = .clear
        topView.addSubview(globalActionsView)
        self.addSubview(topView)

        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        bottomView.addSubview(cancelButton)
        bottomView.addSubview(actionsView)
        bottomView.addSubview(doneButton)
        self.addSubview(bottomView)

        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
    }

    func layoutSubviews(_ parent: UIView) {
        layoutViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }

    fileprivate func update(_ view: UIStackView, with actions: [Action]?) {
        for subview in view.arrangedSubviews {
            subview.removeFromSuperview()
        }
        if let newActions = actions {
            for action in newActions {
                view.addArrangedSubview(createActionButton(action))
            }
        }
        view.setNeedsLayout()
    }

    fileprivate func preferedSize(of view: UIStackView) -> CGSize {
        let height = actionSize.height
        let width = actionSize.width * CGFloat(view.arrangedSubviews.count) + actionSpacing + CGFloat(view.arrangedSubviews.count - 1)
        return CGSize(width: width, height: height)
    }

    fileprivate func layoutViews() {
        if let bounds = globalActionsView.superview?.bounds {
            let size = preferedSize(of: globalActionsView)
            let width = min(size.width, bounds.width)
            let height = min(size.height, bounds.height)
            globalActionsView.frame = CGRect(center: bounds.center, size: CGSize(width: width, height: height))
        }

        if let bounds = actionsView.superview?.bounds {
            let size = preferedSize(of: actionsView)
            let width = min(size.width, bounds.width)
            let height = min(size.height, bounds.height)
            actionsView.frame = CGRect(center: bounds.center, size: CGSize(width: width, height: height))
        }

        if let bounds = cancelButton.superview?.bounds {
            let size = CGSize(width: min(actionSize.width, bounds.width), height: min(actionSize.height, bounds.height))
            let spacing = (bounds.height - size.height ) / 2
            cancelButton.frame = CGRect(origin: CGPoint(x: spacing, y: spacing), size: size)
        }
        if let bounds = doneButton.superview?.bounds {
            let size = CGSize(width: min(actionSize.width, bounds.width), height: min(actionSize.height, bounds.height))
            let spacing = (bounds.height - size.height ) / 2
            doneButton.frame = CGRect(origin: CGPoint(x: bounds.width - size.width - spacing, y: spacing), size: size)
        }
    }

    fileprivate func performCancel() {
        if let actions = lastActions {
            self.actions = actions
            lastActions = nil
            delegate?.performCancel(false)
        } else {
            delegate?.performCancel(true)
        }
    }

    fileprivate func performDone() {
        if let actions = lastActions {
            self.actions = actions
            lastActions = nil
            delegate?.performDone(false)
        } else {
            delegate?.performDone(true)
        }
    }

    fileprivate func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }

    fileprivate func createCancelButton() -> ActionButton {
        let action = Action.createAction("cancel") {
            self.performCancel()
        }
        return createActionButton(action)
    }

    fileprivate func createDoneButton() -> ActionButton {
        let action = Action.createAction("done") {
            self.performDone()
        }
        return createActionButton(action)
    }

    fileprivate func createActionButton(_ action: Action) -> ActionButton {
        let actionButton = ActionButton(action, commandStack: commandStack)
        actionButton.addTarget(self, action: #selector(performAction(_:)), for: .touchUpInside)
        return actionButton
    }

    @objc func performAction(_ sender: ActionButton) {
        if let actions = sender.action.actions {
            self.actions = actions
        }
    }
}
