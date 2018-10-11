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
    @IBInspectable open var textFontSize: CGFloat = 10

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
    
    /**
     Set deselected state without animation
     */
    open func deselectedState() {
        guard animation != nil && iconView != nil else {
            return
        }
        
        animation.deselectedState(iconView!.icon, textLabel: iconView!.textLabel)
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
    
    /**
     The animated items displayed by the tab bar.
     **/
    open var animatedItems: [RAMAnimatedTabBarItem] {
        return tabBar.items as? [RAMAnimatedTabBarItem] ?? []
    }
    
    
    /**
     Show bottom line for indicating selected item, default value is false
     **/
    open var isBottomLineShow: Bool = false {
        didSet {
            if isBottomLineShow {
                if bottomLine == nil { createBottomLine() }
            } else {
                if bottomLine != nil { removeBottomLine() }
            }
        }
    }
    
    /**
      Bottom line color
     **/
    open var bottomLineColor: UIColor = .black {
        didSet {
            bottomLine?.backgroundColor = bottomLineColor
        }
    }
    
    /**
     Bottom line time of animations duration
     **/
    open var bottomLineMoveDuration: TimeInterval = 0.3

    var containers: [String: UIView] = [:]
    
    open override var viewControllers: [UIViewController]? {
        didSet {
            initializeContainers()
        }
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        initializeContainers()
    }
    
    open override var selectedIndex: Int {
        didSet {
           self.setBottomLinePosition(index: selectedIndex)
        }
    }

    var lineLeadingConstraint: NSLayoutConstraint?
    var bottomLine: UIView?
    var arrBottomAnchor:[NSLayoutConstraint] = []
    var arrViews:[UIView] = []
    
    // MARK: life circle

    open override func viewDidLoad() {
        super.viewDidLoad()
        initializeContainers()
    }

    fileprivate func initializeContainers() {
        

        containers.values.forEach { $0.removeFromSuperview() }
        containers = createViewContainers()

        if !containers.isEmpty {
            createCustomIcons(containers)
        }
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (transitionCoordinatorContext) -> Void in
            let orient = UIApplication.shared.statusBarOrientation
            
            for (index, var layoutAnchor) in self.arrBottomAnchor.enumerated() {
                
                layoutAnchor.isActive = false
                
                switch orient {
                case .portrait:
                    layoutAnchor = self.arrViews[index].bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
                case .landscapeLeft,.landscapeRight :
                    layoutAnchor = self.arrViews[index].bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor)
                default:
                    print("Anything But Portrait")
                }
                
                self.arrBottomAnchor[index] = layoutAnchor
                self.arrBottomAnchor[index].isActive = true
            }
            self.view.updateConstraints()
            
        }, completion: { (transitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: create methods

    fileprivate func createCustomIcons(_ containers: [String: UIView]) {

        if let items = tabBar.items, items.count > 5 { fatalError("More button not supported") }

        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
            fatalError("items must inherit RAMAnimatedTabBarItem")
        }

        var index = 0
        for item in items {

            guard let container = containers["container\(items.count - 1 - index)"] else {
                fatalError()
            }
            container.tag = index

            let renderMode = item.iconColor.cgColor.alpha == 0 ? UIImage.RenderingMode.alwaysOriginal :
                UIImage.RenderingMode.alwaysTemplate

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
            textLabel.font =  UIFont.systemFont(ofSize: item.textFontSize)
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.translatesAutoresizingMaskIntoConstraints = false

            container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgDefaultColor

            container.addSubview(icon)
            let itemSize = item.image?.size ?? CGSize(width: 30, height: 30)
            createConstraints(icon, container: container, size: itemSize, yOffset: -5 - item.yOffSet)

            container.addSubview(textLabel)
            let textLabelWidth = tabBar.frame.size.width / CGFloat(items.count) - 5.0
            createConstraints(textLabel, container: container, width: textLabelWidth, yOffset: 16 - item.yOffSet, heightRelation: .greaterThanOrEqual)

            if item.isEnabled == false {
                icon.alpha = 0.5
                textLabel.alpha = 0.5
            }
            item.iconView = (icon: icon, textLabel: textLabel)
            
            if 0 == index { // selected first elemet
                item.selectedState()
                container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgSelectedColor
            } else {
                item.deselectedState()
                container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgDefaultColor
            }

            item.image = nil
            item.title = ""
            index += 1
        }
    }

    fileprivate func createConstraints(_ view: UIView, container: UIView, size: CGSize, yOffset: CGFloat) {
        createConstraints(view, container: container, width: size.width, height: size.height, yOffset: yOffset)
    }

    fileprivate func createConstraints(_ view: UIView, container: UIView, width: CGFloat? = nil, height: CGFloat? = nil, yOffset: CGFloat, heightRelation: NSLayoutConstraint.Relation = .equal) {

        let constX = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutConstraint.Attribute.centerX,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: container,
                                        attribute: NSLayoutConstraint.Attribute.centerX,
                                        multiplier: 1,
                                        constant: 0)
        container.addConstraint(constX)

        let constY = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutConstraint.Attribute.centerY,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: container,
                                        attribute: NSLayoutConstraint.Attribute.centerY,
                                        multiplier: 1,
                                        constant: yOffset)
        container.addConstraint(constY)

        if let width = width {
            let constW = NSLayoutConstraint(item: view,
                                            attribute: NSLayoutConstraint.Attribute.width,
                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                            multiplier: 1,
                                            constant: width)
            view.addConstraint(constW)
        }

        if let height = height {
            let constH = NSLayoutConstraint(item: view,
                                            attribute: NSLayoutConstraint.Attribute.height,
                                            relatedBy: heightRelation,
                                            toItem: nil,
                                            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                            multiplier: 1,
                                            constant: height)
            view.addConstraint(constH)
        }
    }

    fileprivate func createViewContainers() -> [String: UIView] {
        
        guard let items = tabBar.items, items.count > 0 else { return [:] }

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
        
        var constranints:[NSLayoutConstraint]!
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft{
            constranints = NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                                          options: NSLayoutConstraint.FormatOptions.directionLeftToRight,
                                                          metrics: nil,
                                                          views: (containersDict as [String: AnyObject]))
        } else {
            constranints = NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                                          options: NSLayoutConstraint.FormatOptions.directionRightToLeft,
                                                          metrics: nil,
                                                          views: (containersDict as [String: AnyObject]))
        }
        view.addConstraints(constranints)
        
        return containersDict
    }

    fileprivate func createViewContainer() -> UIView {
        let viewContainer = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.isExclusiveTouch = true
        view.addSubview(viewContainer)

        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RAMAnimatedTabBarController.tapHandler(_:)))
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)
        arrViews.append(viewContainer)
        
        // add constrains
        if UIDevice.current.orientation.isLandscape {
            let bottomAnchor = viewContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor)
            self.arrBottomAnchor.append(bottomAnchor)
            bottomAnchor.isActive = true
        } else {
            let bottomAnchor = viewContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            self.arrBottomAnchor.append(bottomAnchor)
            bottomAnchor.isActive = true
        }

        let constH = NSLayoutConstraint(item: viewContainer,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
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

        let controller = children[currentIndex]

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
