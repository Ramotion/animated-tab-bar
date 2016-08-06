
//  RAMFumeAnimation.swift
//
// Copyright (c) 12/2/14 Ramotion Inc. (http://ramotion.com)
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

/// The RAMFumeAnimation class provides bounce animation.
public class RAMFumeAnimation : RAMItemAnimation {
  
  /**
   Start animation, method call when UITabBarItem is selected
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   */
  override public func playAnimation(_ icon : UIImageView, textLabel : UILabel) {
    playMoveIconAnimation(icon, values:[icon.center.y, icon.center.y + 4.0])
    playLabelAnimation(textLabel)
    textLabel.textColor = textSelectedColor
    
    if let iconImage = icon.image {
      let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
      icon.image = renderImage
      icon.tintColor = textSelectedColor
    }
  }
  /**
   Start animation, method call when UITabBarItem is unselected
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   - parameter defaultTextColor: default UITabBarItem text color
   - parameter defaultIconColor: default UITabBarItem icon color
   */
  override public func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor : UIColor) {
    
    playMoveIconAnimation(icon, values:[icon.center.y + 4.0, icon.center.y])
    playDeselectLabelAnimation(textLabel)
    textLabel.textColor = defaultTextColor
    
    if let iconImage = icon.image {
      let renderMode = defaultIconColor.cgColor.alpha == 0 ? UIImageRenderingMode.alwaysOriginal :
        UIImageRenderingMode.alwaysTemplate
      let renderImage = iconImage.withRenderingMode(renderMode)
      icon.image = renderImage
      icon.tintColor = defaultIconColor
    }
  }
  
  /**
   Method call when TabBarController did load
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   */
  override public func selectedState(_ icon : UIImageView, textLabel : UILabel) {
    
    playMoveIconAnimation(icon, values:[icon.center.y + 12.0])
    textLabel.alpha = 0
    textLabel.textColor = textSelectedColor
    
    if let iconImage = icon.image {
      let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
      icon.image = renderImage
      icon.tintColor = textSelectedColor
    }
  }
  
  func playMoveIconAnimation(_ icon : UIImageView, values: [AnyObject]) {
    
    let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:values, duration:duration / 2)
    
    icon.layer.add(yPositionAnimation, forKey: nil)
  }
  
  // MARK: select animation
  
  func playLabelAnimation(_ textLabel: UILabel) {
    
    let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:[textLabel.center.y, textLabel.center.y - 60.0], duration:duration)
    yPositionAnimation.fillMode = kCAFillModeRemoved
    yPositionAnimation.isRemovedOnCompletion = true
    textLabel.layer.add(yPositionAnimation, forKey: nil)
    
    let scaleAnimation = createAnimation(Constants.AnimationKeys.Scale, values:[1.0 ,2.0], duration:duration)
    scaleAnimation.fillMode = kCAFillModeRemoved
    scaleAnimation.isRemovedOnCompletion = true
    textLabel.layer.add(scaleAnimation, forKey: nil)
    
    let opacityAnimation = createAnimation(Constants.AnimationKeys.Opacity, values:[1.0 ,0.0], duration:duration)
    textLabel.layer.add(opacityAnimation, forKey: nil)
  }
  
  func createAnimation(_ keyPath: String, values: [AnyObject], duration: CGFloat)->CAKeyframeAnimation {
    
    let animation = CAKeyframeAnimation(keyPath: keyPath)
    animation.values = values
    animation.duration = TimeInterval(duration)
    animation.calculationMode = kCAAnimationCubic
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = false
    return animation
  }
  
  // MARK: deselect animation
  
  func playDeselectLabelAnimation(_ textLabel: UILabel) {
    
    let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:[textLabel.center.y + 15, textLabel.center.y], duration:duration)
    textLabel.layer.add(yPositionAnimation, forKey: nil)
    
    let opacityAnimation = createAnimation(Constants.AnimationKeys.Opacity, values:[0, 1], duration:duration)
    textLabel.layer.add(opacityAnimation, forKey: nil)
  }
}
