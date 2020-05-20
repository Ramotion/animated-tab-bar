//  RAMAnimatedTabBarController.swift
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
     Bottom line height
     **/
    open var bottomLineHeight: CGFloat = 2 {
        didSet {
            if bottomLineHeight > 0 {
                updateBottomLineHeight(to: bottomLineHeight)
            }
        }
    }
    
    /**
     Bottom line time of animations duration
     **/
    open var bottomLineMoveDuration: TimeInterval = 0.3

    private(set) var containers: [UIView] = []
    
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

    open override var selectedViewController: UIViewController? {
        willSet {
            guard let vc = newValue,
                let index = viewControllers?.firstIndex(of: vc) else { return }
            handleSelection(index: index)
        }
    }
    
    var lineHeightConstraint: NSLayoutConstraint?
    var lineLeadingConstraint: NSLayoutConstraint?
    var bottomLine: UIView?
    var arrBottomAnchor:[NSLayoutConstraint] = []
    var arrViews: [UIView] = []
    
    /**
     Hide UITabBar

     - parameter isHidden: A Boolean indicating whether the UITabBarController is displayed
     */
    @available(*, deprecated, message: "Now you can use UITabBar isHidden")
    open func animationTabBarHidden(_ isHidden: Bool) {
        tabBar.isHidden = isHidden
    }
    
    // MARK: life circle

    open override func viewDidLoad() {
        super.viewDidLoad()
        initializeContainers()
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (transitionCoordinatorContext) -> Void in
            self.layoutContainers()
        }, completion: { (transitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: create methods
    private func initializeContainers() {
        containers.forEach { $0.removeFromSuperview() }
        containers.removeAll()
        
        guard let items = tabBar.items else { return }
        guard items.count <= 5 else { fatalError("More button not supported") }
        
        for index in 0 ..< items.count {
            let viewContainer = UIView()
            viewContainer.isExclusiveTouch = true
            viewContainer.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTap))
            viewContainer.addGestureRecognizer(tapGesture)
            tabBar.addSubview(viewContainer)
            containers.append(viewContainer)
        }
                
        if !containers.isEmpty {
            createCustomIcons(containers: containers)
        }
        
        layoutContainers()
    }
    
    private func layoutContainers() {
        let itemWidth = tabBar.bounds.width / CGFloat(containers.count)
        let isRTL = tabBar.userInterfaceLayoutDirection == .rightToLeft
        
        for (index, container) in containers.enumerated() {
            let i = isRTL ? (containers.count - 1 - index) : index
            let frame = CGRect(x: itemWidth * CGFloat(i), y: 0, width: itemWidth, height: Theme.tabBarHeight)
            container.frame = frame
            
            if let item = tabBar.items?.at(index) as? RAMAnimatedTabBarItem {
                let iconView = item.iconView?.icon
                let iconSize = iconView?.image?.size ?? CGSize(width: 30, height: 30)
                let iconX = (container.frame.width - iconSize.width) / 2 + item.titlePositionAdjustment.horizontal
                let iconY = (container.frame.height - iconSize.height) / 2 + Theme.defaultIconVerticalOffset + item.titlePositionAdjustment.vertical
                iconView?.frame = CGRect(x: iconX, y: iconY, width: iconSize.width, height: iconSize.height)
                
                let label = item.iconView?.textLabel
                let labelSize = label?.sizeThatFits(CGSize.zero) ?? CGSize(width: tabBar.frame.size.width / CGFloat(containers.count), height: 20)
                let labelX = (container.frame.width - labelSize.width) / 2 + item.titlePositionAdjustment.horizontal
                let labelY = (container.frame.height) / 2 + Theme.defaultTitleVerticalOffset + item.titlePositionAdjustment.vertical
                label?.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
            }
        }
    }
    
    private func createCustomIcons(containers: [UIView]) {
        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
            fatalError("items must inherit RAMAnimatedTabBarItem")
        }

        for (index, item) in items.enumerated() {
            let container = containers[index]
            let renderMode = item.iconColor.cgColor.alpha == 0 ? UIImage.RenderingMode.alwaysOriginal :
                UIImage.RenderingMode.alwaysTemplate

            
            let iconImage = item.image ?? item.iconView?.icon.image
            let icon = UIImageView(image: iconImage?.withRenderingMode(renderMode))
            icon.tintColor = item.iconColor
            icon.highlightedImage = item.selectedImage?.withRenderingMode(renderMode)
            container.addSubview(icon)

            
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
            container.addSubview(textLabel)
            
            
            container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgDefaultColor
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
        }
    }
    
    // MARK: actions
    @objc private func itemTap(gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        handleSelection(index: index)
    }
    
    private func handleSelection(index: Int) {
        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else { return }
        let currentIndex = index

        if items[currentIndex].isEnabled == false { return }

        let controller = children[currentIndex]

        if let shouldSelect = delegate?.tabBarController?(self, shouldSelect: controller)
            , !shouldSelect {
            return
        }

        if selectedIndex != currentIndex {
            let previousItem = items.at(selectedIndex)
            let previousContainer: UIView? = previousItem?.iconView?.icon.superview
            previousContainer?.backgroundColor = items[selectedIndex].bgDefaultColor
            previousItem?.deselectAnimation()

            let currentItem: RAMAnimatedTabBarItem = items[currentIndex]
            currentItem.playAnimation()
            let currentContainer: UIView? = currentItem.iconView?.icon.superview
            currentContainer?.backgroundColor = items[currentIndex].bgSelectedColor

            selectedIndex = index
        } else {
            if let navVC = viewControllers?[selectedIndex] as? UINavigationController {
                navVC.popToRootViewController(animated: true)
            }
        }
        delegate?.tabBarController?(self, didSelect: controller)
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


extension RAMAnimatedTabBarController {
    enum Theme {
        public static let tabBarHeight: CGFloat = 49
        public static let defaultTitleVerticalOffset: CGFloat = 10
        public static let defaultIconVerticalOffset: CGFloat = -5
    }
}


extension UIView {
    var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        return UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute)
    }
}
