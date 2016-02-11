
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


public class RAMFumeAnimation : RAMItemAnimation {

    override public func playAnimation(icon : UIImageView, textLabel : UILabel) {
        playMoveIconAnimation(icon, values:[icon.center.y, icon.center.y + 4.0])
        playLabelAnimation(textLabel)
        textLabel.textColor = textSelectedColor
      
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }

    override public func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor : UIColor) {
        
        playMoveIconAnimation(icon, values:[icon.center.y + 4.0, icon.center.y])
        playDeselectLabelAnimation(textLabel)
        textLabel.textColor = defaultTextColor
      
        if let iconImage = icon.image {
            let renderMode = CGColorGetAlpha(defaultIconColor.CGColor) == 0 ? UIImageRenderingMode.AlwaysOriginal :
                                                                              UIImageRenderingMode.AlwaysTemplate
            let renderImage = iconImage.imageWithRenderingMode(renderMode)
            icon.image = renderImage
            icon.tintColor = defaultIconColor
        }
    }

    override public func selectedState(icon : UIImageView, textLabel : UILabel) {

        playMoveIconAnimation(icon, values:[icon.center.y + 12.0])
        textLabel.alpha = 0
        textLabel.textColor = textSelectedColor
      
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }

    func playMoveIconAnimation(icon : UIImageView, values: [AnyObject]) {

        let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:values, duration:duration / 2)

        icon.layer.addAnimation(yPositionAnimation, forKey: nil)
    }

    // MARK: select animation

    func playLabelAnimation(textLabel: UILabel) {

        let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:[textLabel.center.y, textLabel.center.y - 60.0], duration:duration)
        yPositionAnimation.fillMode = kCAFillModeRemoved
        yPositionAnimation.removedOnCompletion = true
        textLabel.layer.addAnimation(yPositionAnimation, forKey: nil)

        let scaleAnimation = createAnimation(Constants.AnimationKeys.Scale, values:[1.0 ,2.0], duration:duration)
        scaleAnimation.fillMode = kCAFillModeRemoved
        scaleAnimation.removedOnCompletion = true
        textLabel.layer.addAnimation(scaleAnimation, forKey: nil)

        let opacityAnimation = createAnimation(Constants.AnimationKeys.Opacity, values:[1.0 ,0.0], duration:duration)
        textLabel.layer.addAnimation(opacityAnimation, forKey: nil)
    }

    func createAnimation(keyPath: String, values: [AnyObject], duration: CGFloat)->CAKeyframeAnimation {
      
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = values
        animation.duration = NSTimeInterval(duration)
        animation.calculationMode = kCAAnimationCubic
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        return animation
    }

    // MARK: deselect animation

    func playDeselectLabelAnimation(textLabel: UILabel) {
      
        let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:[textLabel.center.y + 15, textLabel.center.y], duration:duration)
        textLabel.layer.addAnimation(yPositionAnimation, forKey: nil)

        let opacityAnimation = createAnimation(Constants.AnimationKeys.Opacity, values:[0, 1], duration:duration)
        textLabel.layer.addAnimation(opacityAnimation, forKey: nil)
    }

}
