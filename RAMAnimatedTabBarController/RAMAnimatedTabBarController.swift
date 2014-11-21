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

class RAMAnimatedTabBarItem: UITabBarItem {
    
    @IBOutlet weak var animation: RAMItemAnimation!
    @IBInspectable var textColor: UIColor = UIColor.blackColor()
    
    func playAnimation(icon: UIImageView, textLabel: UILabel) {
        
        assert(animation != nil, "add animation in UITabBarItem")
        if animation != nil {
            animation.playAnimation(icon, textLable: textLabel)
        }
    }
    
    func deselectAnimation(icon: UIImageView, textLable: UILabel) {
        if animation != nil {
            animation.deselectAnimation(icon, textLable: textLable, defaultTextColor: textColor)
        }
    }
    
    func selectedState(icon: UIImageView, textLable: UILabel) {
        if animation != nil {
            animation.selectedState(icon, textLable: textLable)
        }
    }
}

class RAMAnimatedTabBarController: UITabBarController {
    
    var iconsView: [(icon: UIImageView, textLable: UILabel)] = Array()
    
// MARK: life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containers = createViewContainers()

        createCustomIcons(containers)
        
        
    }
    
// MARK: create methods
    
    func createCustomIcons(containers : NSDictionary) {
        
        if let items = tabBar.items {
            let itemsCount = tabBar.items!.count as Int - 1
            var index = 0
            for item in self.tabBar.items as [RAMAnimatedTabBarItem] {
                
                assert(item.image != nil, "add image icon in UITabBarItem")

                var container : UIView = containers["container\(itemsCount-index)"] as UIView
                container.tag = index
                
                var icon = UIImageView(image: item.image)
                icon.setTranslatesAutoresizingMaskIntoConstraints(false)
                icon.tintColor = UIColor.clearColor()
                
                // text
                var textLable = UILabel()
                textLable.text = item.title
                textLable.backgroundColor = UIColor.clearColor()
                textLable.textColor = item.textColor
                textLable.font = UIFont.systemFontOfSize(10)
                textLable.textAlignment = NSTextAlignment.Center
                textLable.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                container.addSubview(icon)
                createConstraints(icon, container: container, size: item.image!.size, yOffset: -5)
                
                container.addSubview(textLable)
                let textLableWidth = tabBar.frame.size.width / CGFloat(tabBar.items!.count) - 5.0
                createConstraints(textLable, container: container, size: CGSize(width: textLableWidth , height: 10), yOffset: 16)

                let iconsAndLables = (icon:icon, textLable:textLable)
                iconsView.append(iconsAndLables)
                
                if 0 == index { // selected first elemet
                    item.selectedState(icon, textLable: textLable)
                }
                
                item.image = nil
                item.title = ""
                index++
            }
        }
    }
    
    func createConstraints(view:UIView, container:UIView, size:CGSize, yOffset:CGFloat) {
        
        var constX = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0)
        container.addConstraint(constX)
        
        var constY = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: yOffset)
        container.addConstraint(constY)
        
        var constW = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.width)
        view.addConstraint(constW)
        
        var constH = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.height)
        view.addConstraint(constH)
    }
    
    func createViewContainers() -> NSDictionary {
        
        var containersDict = NSMutableDictionary()
        let itemsCount : Int = tabBar.items!.count as Int - 1
        
        for index in 0...itemsCount {
            var viewContainer = createViewContainer()
            containersDict.setValue(viewContainer, forKey: "container\(index)")
        }
        
        var keys = containersDict.allKeys
        
        var formatString = "H:|-(0)-[container0]"
        for index in 1...itemsCount {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        var  constranints = NSLayoutConstraint.constraintsWithVisualFormat(formatString,
                                                                    options:NSLayoutFormatOptions.DirectionRightToLeft,
                                                                    metrics: nil,
                                                                      views: containersDict)
        view.addConstraints(constranints)
        
        return containersDict
    }
    
    func createViewContainer() -> UIView {
        var viewContainer = UIView();
        viewContainer.backgroundColor = UIColor.clearColor() // for test
        viewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(viewContainer)
        
        // add gesture
        var tapGesture = UITapGestureRecognizer(target: self, action: "tapHeandler:")
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)
        
        // add constrains
        var constY = NSLayoutConstraint(item: viewContainer,
                                   attribute: NSLayoutAttribute.Bottom,
                                   relatedBy: NSLayoutRelation.Equal,
                                      toItem: view,
                                   attribute: NSLayoutAttribute.Bottom,
                                  multiplier: 1,
                                    constant: 0)
        
        view.addConstraint(constY)
        
        var constH = NSLayoutConstraint(item: viewContainer,
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
    
    func tapHeandler(gesture:UIGestureRecognizer) {
        
        let items = tabBar.items as [RAMAnimatedTabBarItem]
        
        let currentIndex = gesture.view!.tag
        if selectedIndex != currentIndex {
            var animationItem : RAMAnimatedTabBarItem = items[currentIndex]
            var icon = iconsView[currentIndex].icon
            var textLable = iconsView[currentIndex].textLable
            animationItem.playAnimation(icon, textLabel: textLable)
            
            let deselelectIcon = iconsView[selectedIndex].icon
            let deselelectTextLable = iconsView[selectedIndex].textLable
            let deselectItem = items[selectedIndex]
            deselectItem.deselectAnimation(deselelectIcon, textLable: deselelectTextLable)

            selectedIndex = gesture.view!.tag
        }
    }
}


