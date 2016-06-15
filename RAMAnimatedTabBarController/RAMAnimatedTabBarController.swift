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
      
      if let iconView = iconView, let contanerView = iconView.icon.superview where badge == nil {
        badge = RAMBadge.badge()
        badge!.addBadgeOnView(contanerView)
      }
      
      badge?.text = newValue
    }
  }
}

/// UITabBarItem with animation
public class RAMAnimatedTabBarItem: UITabBarItem {
  
  @IBInspectable public var yOffSet: CGFloat = 0
  
  public override var enabled: Bool {
    didSet {
      iconView?.icon.alpha = enabled == true ? 1 : 0.5
      iconView?.textLabel.alpha = enabled == true ? 1 : 0.5
    }
  }
  
  /// animation for UITabBarItem. use RAMFumeAnimation, RAMBounceAnimation, RAMRotationAnimation, RAMFrameItemAnimation, RAMTransitionAnimation
  /// or create custom anmation inherit RAMItemAnimation
  @IBOutlet public var animation: RAMItemAnimation!
  
  /// The font used to render the UITabBarItem text.
  public var textFont: UIFont = UIFont.systemFontOfSize(10)
  
  /// The color of the UITabBarItem text.
  @IBInspectable public var textColor: UIColor = UIColor.blackColor()
  
  /// The tint color of the UITabBarItem icon.
  @IBInspectable public var iconColor: UIColor = UIColor.clearColor() // if alpha color is 0 color ignoring
  
  var bgDefaultColor: UIColor = UIColor.clearColor() // background color
  var bgSelectedColor: UIColor = UIColor.clearColor()
  
  //  The current badge value
  public var badge: RAMBadge? // use badgeValue to show badge
  
  // Container for icon and text in UITableItem. 
  public var iconView: (icon: UIImageView, textLabel: UILabel)?
  
  /**
   Start selected animation
   */
  public func playAnimation() {
    
    assert(animation != nil, "add animation in UITabBarItem")
    guard animation != nil && iconView != nil else  {
      return
    }
    animation.playAnimation(iconView!.icon, textLabel: iconView!.textLabel)
  }
  
  /**
   Start unselected animation
   */
  public func deselectAnimation() {
    
    guard animation != nil && iconView != nil else  {
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
  public func selectedState() {
    guard animation != nil && iconView != nil else  {
      return
    }
    
    animation.selectedState(iconView!.icon, textLabel: iconView!.textLabel)
  }
}

extension  RAMAnimatedTabBarController {
  
  /**
   Change selected color for each UITabBarItem
   
   - parameter textSelectedColor: set new color for text
   - parameter iconSelectedColor: set new color for icon
   */
  public func changeSelectedColor(textSelectedColor:UIColor, iconSelectedColor:UIColor) {
    
    let items = tabBar.items as! [RAMAnimatedTabBarItem]
    for index in 0..<items.count {
      let item = items[index]
      
      item.animation.textSelectedColor = textSelectedColor
      item.animation.iconSelectedColor = iconSelectedColor
      
      if item == self.tabBar.selectedItem {
        item.selectedState()
      }
    }
  }
  
  /**
   Hide UITabBarController
   
    - parameter isHidden: A Boolean indicating whether the UITabBarController is displayed
   */
  public func animationTabBarHidden(isHidden:Bool) {
    guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
      fatalError("items must inherit RAMAnimatedTabBarItem")
    }
    for item in items {
      if let iconView = item.iconView {
        iconView.icon.superview?.hidden = isHidden
      }
    }
    self.tabBar.hidden = isHidden;
  }
  
  /**
   Selected UITabBarItem with animaton
   
   - parameter from: Index for unselected animation
   - parameter to:   Index for selected animation
   */
  public func setSelectIndex(from from: Int, to: Int) {
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
public class RAMAnimatedTabBarController: UITabBarController {
  
  private var didInit: Bool = false
  private var didLoadView: Bool = false
  
  // MARK: life circle
  
  /**
   Returns a newly initialized view controller with the nib file in the specified bundle.
   
   - parameter nibNameOrNil:   The name of the nib file to associate with the view controller. The nib file name should 
   not contain any leading path information. If you specify nil, the nibName property is set to nil.
   
   - parameter nibBundleOrNil: The bundle in which to search for the nib file. This method looks for the nib file in the
   bundle's language-specific project directories first, followed by the Resources directory. If this parameter is nil,
   the method uses the heuristics described below to locate the nib file.
   
   - returns: A newly initialized RAMAnimatedTabBarController object.
   */
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.didInit = true
    self.initializeContainers()
  }
  
  /**
   Returns a newly initialized view controller with the nib file in the specified bundle.
   
   - parameter viewControllers: Sets the root view controllers of the tab bar controller.
   
   - returns: A newly initialized RAMAnimatedTabBarController object.
   */
  public init(viewControllers: [UIViewController]) {
    super.init(nibName: nil, bundle: nil)
    
    self.didInit = true
    
    // Set initial items
    self.setViewControllers(viewControllers, animated: false)
    
    self.initializeContainers()
  }
  
  /**
   Returns a newly initialized view controller with the nib file in the specified bundle.
   
   - parameter coder: An unarchiver object.
   
   - returns: A newly initialized RAMAnimatedTabBarController object.
   */
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.didInit = true
    self.initializeContainers()
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    self.didLoadView = true
    
    self.initializeContainers()
  }
  
  private func initializeContainers() {
    if !self.didInit || !self.didLoadView {
      return
    }
    
    let containers = self.createViewContainers()
    
    self.createCustomIcons(containers)
  }
  
  // MARK: create methods
  
  private func createCustomIcons(containers : NSDictionary) {
    
    guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
      fatalError("items must inherit RAMAnimatedTabBarItem")
    }
    
    var index = 0
    for item in items {
      
      guard let itemImage = item.image else {
        fatalError("add image icon in UITabBarItem")
      }
      
      guard let container = containers["container\(items.count - 1 - index)"] as? UIView else {
        fatalError()
      }
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
      textLabel.font = item.textFont
      textLabel.textAlignment = NSTextAlignment.Center
      textLabel.translatesAutoresizingMaskIntoConstraints = false
      
      container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgDefaultColor
      
      container.addSubview(icon)
      createConstraints(icon, container: container, size: itemImage.size, yOffset: -5 - item.yOffSet)
      
      container.addSubview(textLabel)
      let textLabelWidth = tabBar.frame.size.width / CGFloat(items.count) - 5.0
      createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 10), yOffset: 16 - item.yOffSet)
      
      if item.enabled == false {
        icon.alpha      = 0.5
        textLabel.alpha = 0.5
      }
      item.iconView = (icon:icon, textLabel:textLabel)
      
      if 0 == index { // selected first elemet
        item.selectedState()
        container.backgroundColor = (items as [RAMAnimatedTabBarItem])[index].bgSelectedColor
      }
      
      item.image = nil
      item.title = ""
      index += 1
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
    
    guard let items = tabBar.items else {
      fatalError("add items in tabBar")
    }
    
    var containersDict = [String: AnyObject]()
    
    for index in 0..<items.count {
      let viewContainer = createViewContainer()
      containersDict["container\(index)"] = viewContainer
    }
    
    var formatString = "H:|-(0)-[container0]"
    for index in 1..<items.count {
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
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RAMAnimatedTabBarController.tapHandler(_:)))
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
    
    guard let items = tabBar.items as? [RAMAnimatedTabBarItem],
      let gestureView = gesture.view else {
        fatalError("items must inherit RAMAnimatedTabBarItem")
    }
    
    let currentIndex = gestureView.tag
    
    if items[currentIndex].enabled == false { return }
    
    let controller = self.childViewControllers[currentIndex]
    
    if let shouldSelect = delegate?.tabBarController?(self, shouldSelectViewController: controller)
      where !shouldSelect {
      return
    }
    
    if selectedIndex != currentIndex {
      let animationItem : RAMAnimatedTabBarItem = items[currentIndex]
      animationItem.playAnimation()
      
      let deselectItem = items[selectedIndex]
      
      let containerPrevious : UIView = deselectItem.iconView!.icon.superview!
      containerPrevious.backgroundColor = items[currentIndex].bgDefaultColor
      
      deselectItem.deselectAnimation()
      
      let container : UIView = animationItem.iconView!.icon.superview!
      container.backgroundColor = items[currentIndex].bgSelectedColor
      
      selectedIndex = gestureView.tag
      delegate?.tabBarController?(self, didSelectViewController: controller)
      
    } else if selectedIndex == currentIndex {
      
      if let navVC = self.viewControllers![selectedIndex] as? UINavigationController {
        navVC.popToRootViewControllerAnimated(true)
      }
    }
  }
}
