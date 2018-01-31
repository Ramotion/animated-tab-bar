//  AnimationTabBarController.swift
//
// Copyright (c) 11/10/14 Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

// MARK: Custom Badge

extension RAMAnimatedTabBarItem {

    /// The current badge value
    open override var badgeValue: String? {
        get {
            return badge?.text
        }
        set(newValue) {

            if newValue == nil {
                badge?.removeFromSuperview()
                badge = nil
                return
            }

            if let iconView = iconView, let contanerView = iconView.icon.superview, badge == nil {
                badge = RAMBadge.badge()
                badge!.addBadgeOnView(contanerView)
            }

            badge?.text = newValue
        }
    }
}

/// UITabBarItem with animation
open class RAMAnimatedTabBarItem: UITabBarItem {

    @IBInspectable open var yOffSet: CGFloat = 0

    open override var isEnabled: Bool {
        didSet {
            iconView?.icon.alpha = isEnabled == true ? 1 : 0.5
            iconView?.textLabel.alpha = isEnabled == true ? 1 : 0.5
        }
    }
    
    /// animation for UITabBarItem. use RAMFumeAnimation, RAMBounceAnimation, RAMRotationAnimation, RAMFrameItemAnimation, RAMTransitionAnimation
    /// or create custom anmation inherit RAMItemAnimation
    @IBOutlet open var animation: RAMItemAnimation!

    /// The font used to render the UITabBarItem text.
    open var textFont: UIFont = UIFont.systemFont(ofSize: 10)

    /// The color of the UITabBarItem text.
    @IBInspectable open var textColor: UIColor = UIColor.black

    /// The tint color of the UITabBarItem icon.
    @IBInspectable open var iconColor: UIColor = UIColor.clear // if alpha color is 0 color ignoring

    open var bgDefaultColor: UIColor = UIColor.clear // background color
    open var bgSelectedColor: UIColor = UIColor.clear

    //  The current badge value
    open var badge: RAMBadge? // use badgeValue to show badge

    // Container for icon and text in UITableItem.
    open var iconView: (icon: UIImageView, textLabel: UILabel)?

    /**
     Start selected animation
     */
    open func playAnimation() {

        assert(animation != nil, "add animation in UITabBarItem")
        guard animation != nil && iconView != nil else {
            return
        }
        animation.playAnimation(iconView!.icon, textLabel: iconView!.textLabel)
    }

    /**
     Start unselected animation
     */
    open func deselectAnimation() {

        guard animation != nil && iconView != nil else {
            return
        }

        animation.deselectAnimation(
            iconView!.icon,
            textLabel: iconView!.textLabel,
            defaultTextColor: textColor,
            defaultIconColor: iconColor)
    }

    /**
     Set selected state without animation
     */
    open func selectedState() {
        guard animation != nil && iconView != nil else {
            return
        }

        animation.selectedState(iconView!.icon, textLabel: iconView!.textLabel)
    }
}

extension RAMAnimatedTabBarController {

    /**
     Change selected color for each UITabBarItem

     - parameter textSelectedColor: set new color for text
     - parameter iconSelectedColor: set new color for icon
     */
    open func changeSelectedColor(_ textSelectedColor: UIColor, iconSelectedColor: UIColor) {

        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        for index in 0 ..< items.count {
            let item = items[index]

            item.animation.textSelectedColor = textSelectedColor
            item.animation.iconSelectedColor = iconSelectedColor

            if item == tabBar.selectedItem {
                item.selectedState()
            }
        }
    }

    /**
     Hide UITabBarController

     - parameter isHidden: A Boolean indicating whether the UITabBarController is displayed
     */
    open func animationTabBarHidden(_ isHidden: Bool) {
        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
            fatalError("items must inherit RAMAnimatedTabBarItem")
        }
        for item in items {
            if let iconView = item.iconView {
                iconView.icon.superview?.isHidden = isHidden
            }
        }
        tabBar.isHidden = isHidden
    }

    /**
     Selected UITabBarItem with animaton

     - parameter from: Index for unselected animation
     - parameter to:   Index for selected animation
     */
    open func setSelectIndex(from: Int, to: Int) {
        selectedIndex = to
        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
            fatalError("items must inherit RAMAnimatedTabBarItem")
        }

        let containerFrom = items[from].iconView?.icon.superview
        containerFrom?.backgroundColor = items[from].bgDefaultColor
        items[from].deselectAnimation()

        let containerTo = items[to].iconView?.icon.superview
        containerTo?.backgroundColor = items[to].bgSelectedColor
        items[to].playAnimation()
    }
}

/// UITabBarController with item animations
open class RAMAnimatedTabBarController: UITabBarController {

    fileprivate var containers: [String: UIView] = [:]
    
    open override var viewControllers: [UIViewController]? {
        didSet {
            initializeContainers()
        }
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        initializeContainers()
    }
    
    // MARK: life circle

    open override func viewDidLoad() {
        super.viewDidLoad()
        initializeContainers()
    }

    fileprivate func initializeContainers() {
        
        containers.values.forEach { $0.removeFromSuperview() }
        containers = createViewContainers()

        createCustomIcons(containers)
    }

    // MARK: create methods

    fileprivate func createCustomIcons(_ containers: [String: UIView]) {

        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
            fatalError("items must inherit RAMAnimatedTabBarItem")
        }

        var index = 0
        for item in items {

            guard let container = containers["container\(items.count - 1 - index)"] else {
                fatalError()
            }
            container.tag = index

            let renderMode = item.iconColor.cgColor.alpha == 0 ? UIImageRenderingMode.alwaysOriginal :
                UIImageRenderingMode.alwaysTemplate

            let iconImage = item.image ?? item.iconView?.icon.image
            let icon = UIImageView(image: iconImage?.withRenderingMode(renderMode))
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.tintColor = item.iconColor
            icon.highlightedImage = item.selectedImage?.withRenderingMode(renderMode)

            // text
            let textLabel = UILabel()
            if let title = item.title, !title.isEmpty {
                textLabel.text = title
            } else {
                textLabel.text = item.iconView?.textLabel.text
            }
            textLabel.backgroundColor = UIColor.clear
            textLabel.textColor = item.textColor
            textLabel.font = item.textFont
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.translatesAutoresizingMaskIntoConstraints = false

            container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgDefaultColor

            container.addSubview(icon)
            let itemSize = item.image?.size ?? CGSize(width: 30, height: 30)
            createConstraints(icon, container: container, size: itemSize, yOffset: -5 - item.yOffSet)

            container.addSubview(textLabel)
            let textLabelWidth = tabBar.frame.size.width / CGFloat(items.count) - 5.0
            createConstraints(textLabel, container: container, width: textLabelWidth, yOffset: 16 - item.yOffSet)

            if item.isEnabled == false {
                icon.alpha = 0.5
                textLabel.alpha = 0.5
            }
            item.iconView = (icon: icon, textLabel: textLabel)

            if 0 == index { // selected first elemet
                item.selectedState()
                container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgSelectedColor
            }

            item.image = nil
            item.title = ""
            index += 1
        }
    }

    fileprivate func createConstraints(_ view: UIView, container: UIView, size: CGSize, yOffset: CGFloat) {
        createConstraints(view, container: container, width: size.width, height: size.height, yOffset: yOffset)
    }

    fileprivate func createConstraints(_ view: UIView, container: UIView, width: CGFloat? = nil, height: CGFloat? = nil, yOffset: CGFloat) {

        let constX = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.centerX,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.centerX,
                                        multiplier: 1,
                                        constant: 0)
        container.addConstraint(constX)

        let constY = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.centerY,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.centerY,
                                        multiplier: 1,
                                        constant: yOffset)
        container.addConstraint(constY)

        if let width = width {
            let constW = NSLayoutConstraint(item: view,
                                            attribute: NSLayoutAttribute.width,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1,
                                            constant: width)
            view.addConstraint(constW)
        }

        if let height = height {
            let constH = NSLayoutConstraint(item: view,
                                            attribute: NSLayoutAttribute.height,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1,
                                            constant: height)
            view.addConstraint(constH)
        }
    }

    fileprivate func createViewContainers() -> [String: UIView] {

        guard let items = tabBar.items else {
            fatalError("add items in tabBar")
        }

        var containersDict: [String: UIView] = [:]

        for index in 0 ..< items.count {
            let viewContainer = createViewContainer()
            containersDict["container\(index)"] = viewContainer
        }

        var formatString = "H:|-(0)-[container0]"
        for index in 1 ..< items.count {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        let constranints = NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                                          options: NSLayoutFormatOptions.directionRightToLeft,
                                                          metrics: nil,
                                                          views: (containersDict as [String: AnyObject]))
        view.addConstraints(constranints)

        return containersDict
    }

    fileprivate func createViewContainer() -> UIView {
        let viewContainer = UIView()
        viewContainer.backgroundColor = UIColor.clear // for test
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.isExclusiveTouch = true
        view.addSubview(viewContainer)

        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RAMAnimatedTabBarController.tapHandler(_:)))
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)

        // add constrains
        viewContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true

        let constH = NSLayoutConstraint(item: viewContainer,
                                        attribute: NSLayoutAttribute.height,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.notAnAttribute,
                                        multiplier: 1,
                                        constant: 49)
        viewContainer.addConstraint(constH)

        return viewContainer
    }

    // MARK: actions

    @objc open func tapHandler(_ gesture: UIGestureRecognizer) {

        guard let items = tabBar.items as? [RAMAnimatedTabBarItem],
            let gestureView = gesture.view else {
            fatalError("items must inherit RAMAnimatedTabBarItem")
        }

        let currentIndex = gestureView.tag

        if items[currentIndex].isEnabled == false { return }

        let controller = childViewControllers[currentIndex]

        if let shouldSelect = delegate?.tabBarController?(self, shouldSelect: controller)
            , !shouldSelect {
            return
        }

        if selectedIndex != currentIndex {
            let animationItem: RAMAnimatedTabBarItem = items[currentIndex]
            animationItem.playAnimation()

            let deselectItem = items[selectedIndex]

            let containerPrevious: UIView = deselectItem.iconView!.icon.superview!
            containerPrevious.backgroundColor = items[currentIndex].bgDefaultColor

            deselectItem.deselectAnimation()

            let container: UIView = animationItem.iconView!.icon.superview!
            container.backgroundColor = items[currentIndex].bgSelectedColor

            selectedIndex = gestureView.tag

        } else if selectedIndex == currentIndex {

            if let navVC = self.viewControllers![selectedIndex] as? UINavigationController {
                navVC.popToRootViewController(animated: true)
            }
        }
        delegate?.tabBarController?(self, didSelect: controller)
    }
}
