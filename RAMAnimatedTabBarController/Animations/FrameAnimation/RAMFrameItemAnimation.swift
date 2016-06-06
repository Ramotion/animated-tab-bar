//  RAMFrameItemAnimation.swift
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
import QuartzCore

/// The RAMFrameItemAnimation class provides keyframe animation.
public class RAMFrameItemAnimation: RAMItemAnimation {
  
  @nonobjc private var animationImages : Array<CGImage> = Array()
  
  var selectedImage : UIImage!
  
  /// A Boolean value indicated plaing revers animation when UITabBarItem unselected, if false image change immediately, defalut value true
  @IBInspectable public var isDeselectAnimation: Bool = true
  
  /// path to array of image names from plist file
  @IBInspectable public var imagesPath: String!
  
  override public func awakeFromNib() {
    
    guard let path = NSBundle.mainBundle().pathForResource(imagesPath, ofType:"plist") else {
      fatalError("don't found plist")
    }
    
    guard case let animationImagesName as [String] = NSArray(contentsOfFile: path) else {
      fatalError()
    }
    
    createImagesArray(animationImagesName)
    
    // selected image
    let selectedImageName = animationImagesName[animationImagesName.endIndex - 1]
    selectedImage = UIImage(named: selectedImageName)
  }
  
  func createImagesArray(imageNames : Array<String>) {
    for name : String in imageNames {
      if let image = UIImage(named: name)?.CGImage {
        animationImages.append(image)
      }
    }
  }
  
  // MARK: public
  
  /**
   Set images for keyframe animation
   
   - parameter images: images for keyframe animation
   */
  public func setAnimationImages(images: Array<UIImage>) {
    var animationImages = Array<CGImage>()
    for image in images {
      if let cgImage = image.CGImage {
        animationImages.append(cgImage)
      }
    }
    self.animationImages = animationImages
  }
  
  // MARK: RAMItemAnimationProtocol
  
  /**
   Start animation, method call when UITabBarItem is selected
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   */
  override public func playAnimation(icon : UIImageView, textLabel : UILabel) {
    
    playFrameAnimation(icon, images:animationImages)
    textLabel.textColor = textSelectedColor
  }
  
  /**
   Start animation, method call when UITabBarItem is unselected
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   - parameter defaultTextColor: default UITabBarItem text color
   - parameter defaultIconColor: default UITabBarItem icon color
   */
  override public func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor : UIColor) {
    if isDeselectAnimation {
      playFrameAnimation(icon, images:animationImages.reverse())
    }
    
    textLabel.textColor = defaultTextColor
  }
  
  /**
   Method call when TabBarController did load
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   */
  override public func selectedState(icon : UIImageView, textLabel : UILabel) {
    icon.image = selectedImage
    textLabel.textColor = textSelectedColor
  }
  
  @nonobjc func playFrameAnimation(icon : UIImageView, images : Array<CGImage>) {
    let frameAnimation = CAKeyframeAnimation(keyPath: Constants.AnimationKeys.KeyFrame)
    frameAnimation.calculationMode = kCAAnimationDiscrete
    frameAnimation.duration = NSTimeInterval(duration)
    frameAnimation.values = images
    frameAnimation.repeatCount = 1
    frameAnimation.removedOnCompletion = false
    frameAnimation.fillMode = kCAFillModeForwards
    icon.layer.addAnimation(frameAnimation, forKey: nil)
  }
}
