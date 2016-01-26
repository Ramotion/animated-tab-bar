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

extension RAMAnimatedTabBarItem {
    
    override public var badgeValue: String? {
        get {
            return badge?.text
        }
        set(newValue) {
            
            if newValue == nil {
                badge?.removeFromSuperview()
                badge = nil;
                return
            }
            
            if badge == nil {
                badge = RAMBadge.bage()
                if let contanerView = self.iconView!.icon.superview {
                    badge!.addBadgeOnView(contanerView)
                }
            }
            
            badge?.text = newValue
        }
    }
}


public class RAMAnimatedTabBarItem: UITabBarItem {
    
   @IBOutlet weak var animation: RAMItemAnimation!
    
    @IBInspectable var textColor: UIColor = UIColor.blackColor()
    @IBInspectable var iconColor: UIColor = UIColor.clearColor() // if alpha color is 0 color ignoring
    
    public var badge: RAMBadge? // use badgeValue to show badge
    
    public var iconView: (icon: UIImageView, textLabel: UILabel)?
    
    public func playAnimation() {
        
        assert(animation != nil, "add animation in UITabBarItem")
        if animation != nil && iconView != nil {
            animation.playAnimation(iconView!.icon, textLabel: iconView!.textLabel)
        }
    }
    
    public func deselectAnimation() {
        if animation != nil && iconView != nil {
            animation.deselectAnimation(iconView!.icon, textLabel: iconView!.textLabel, defaultTextColor: textColor, defaultIconColor: iconColor)
        }
    }
    
    public func selectedState() {
        if animation != nil && iconView != nil {
            animation.selectedState(iconView!.icon, textLabel: iconView!.textLabel)
        }
    }
}

extension  RAMAnimatedTabBarController {
    
    public func changeSelectedColor(textSelectedColor:UIColor, iconSelectedColor:UIColor) {
        
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        for var index = 0; index < items.count; ++index {
            let item = items[index]
            
            item.animation.textSelectedColor = textSelectedColor
            item.animation.iconSelectedColor = iconSelectedColor
            
            if item == self.tabBar.selectedItem {
                item.selectedState()
            }
        }
    }
    
    public func animationTabBarHidden(isHidden:Bool) {
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        for item in items {
            if let iconView = item.iconView {
                iconView.icon.superview?.hidden = isHidden
            }
        }
        self.tabBar.hidden = isHidden;
    }
    
    public func setSelectIndex(from from:Int,to:Int) {
        self.selectedIndex = to
        let items = self.tabBar.items as! [RAMAnimatedTabBarItem]
        items[from].deselectAnimation()
        items[to].playAnimation()
    }
}


public class RAMAnimatedTabBarController: UITabBarController {
    
    // MARK: life circle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let containers = createViewContainers()
        
        createCustomIcons(containers)
    }
    
    // MARK: create methods
    
    private func createCustomIcons(containers : NSDictionary) {
        
        if let _ = tabBar.items {
            let itemsCount = tabBar.items!.count as Int - 1
            var index = 0
            for item in self.tabBar.items as! [RAMAnimatedTabBarItem] {
                
                assert(item.image != nil, "add image icon in UITabBarItem")
                
                let container : UIView = containers["container\(itemsCount-index)"] as! UIView
                container.tag = index
                
                
                let renderMode = CGColorGetAlpha(item.iconColor.CGColor) == 0 ? UIImageRenderingMode.AlwaysOriginal :
                                                                                UIImageRenderingMode.AlwaysTemplate
                
                let icon = UIImageView(image: item.image?.imageWithRenderingMode(renderMode))
                icon.translatesAutoresizingMaskIntoConstraints = false
                icon.tintColor = item.iconColor
                
                // text
                let textLabel = UILabel()
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clearColor()
                textLabel.textColor = item.textColor
                textLabel.font = UIFont.systemFontOfSize(10)
                textLabel.textAlignment = NSTextAlignment.Center
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                
                container.addSubview(icon)
                createConstraints(icon, container: container, size: item.image!.size, yOffset: -5)
                
                container.addSubview(textLabel)
                let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBar.items!.count) - 5.0
                createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 10), yOffset: 16)
                
                item.iconView = (icon:icon, textLabel:textLabel)
                
                if 0 == index { // selected first elemet
                    item.selectedState()
                }
                
                item.image = nil
                item.title = ""
                index++
            }
        }
    }
    
    private func createConstraints(view:UIView, container:UIView, size:CGSize, yOffset:CGFloat) {
        
        let constX = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0)
        container.addConstraint(constX)
        
        let constY = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: yOffset)
        container.addConstraint(constY)
        
        let constW = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.width)
        view.addConstraint(constW)
        
        let constH = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.height)
        view.addConstraint(constH)
    }
    
    private func createViewContainers() -> NSDictionary {
        
        var containersDict = [String: AnyObject]()
        let itemsCount : Int = tabBar.items!.count as Int - 1
        
        for index in 0...itemsCount {
            let viewContainer = createViewContainer()
            containersDict["container\(index)"] = viewContainer
        }
        
        //let keys = containersDict.keys
        
        var formatString = "H:|-(0)-[container0]"
        for index in 1...itemsCount {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        let  constranints = NSLayoutConstraint.constraintsWithVisualFormat(formatString,
            options:NSLayoutFormatOptions.DirectionRightToLeft,
            metrics: nil,
            views: (containersDict as [String : AnyObject]))
        view.addConstraints(constranints)
        
        return containersDict
    }
    
    private func createViewContainer() -> UIView {
        let viewContainer = UIView();
        viewContainer.backgroundColor = UIColor.clearColor() // for test
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapHandler:")
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)
        
        // add constrains
        let constY = NSLayoutConstraint(item: viewContainer,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0)
        
        view.addConstraint(constY)
        
        let constH = NSLayoutConstraint(item: viewContainer,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: tabBar.frame.size.height)
        viewContainer.addConstraint(constH)
        
        return viewContainer
    }
    
    // MARK: actions
    
    func tapHandler(gesture:UIGestureRecognizer) {
        
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        
        let currentIndex = gesture.view!.tag
        
        if let shouldSelect = delegate?.tabBarController?(self, shouldSelectViewController: self)
            where !shouldSelect {
            return
        }
        
        if selectedIndex != currentIndex {
            let animationItem : RAMAnimatedTabBarItem = items[currentIndex]
            animationItem.playAnimation()
            
            let deselectItem = items[selectedIndex]
            deselectItem.deselectAnimation()
            
            selectedIndex = gesture.view!.tag

            delegate?.tabBarController?(self, didSelectViewController: self)
        } else if selectedIndex == currentIndex {
            
            if let navVC = self.viewControllers![selectedIndex] as? UINavigationController {
                navVC.popToRootViewControllerAnimated(true)
            }
        }
    }
}
