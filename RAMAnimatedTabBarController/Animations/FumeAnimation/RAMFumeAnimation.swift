
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


class RAMFumeAnimation : RAMItemAnimation {

    override func playAnimation(icon : UIImageView, textLabel : UILabel) {
        playMoveIconAnimation(icon, values:[icon.center.y, icon.center.y + 4.0])
        playLabelAnimation(textLabel)
        textLabel.textColor = textSelectedColor
      
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }

    override func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        playMoveIconAnimation(icon, values:[icon.center.y + 4.0, icon.center.y])
        playDeselectLabelAnimation(textLabel)
        textLabel.textColor = defaultTextColor
      
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = defaultTextColor
        }
    }

    override func selectedState(icon : UIImageView, textLabel : UILabel) {

        playMoveIconAnimation(icon, values:[icon.center.y + 8.0])
        textLabel.alpha = 0
        textLabel.textColor = textSelectedColor
      
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }

    func playMoveIconAnimation(icon : UIImageView, values: [AnyObject]) {

        let yPositionAnimation = createAnimation("position.y", values:values, duration:duration / 2)

        icon.layer.addAnimation(yPositionAnimation, forKey: "yPositionAnimation")
    }

    // MARK: select animation

    func playLabelAnimation(textLabel: UILabel) {

        let yPositionAnimation = createAnimation("position.y", values:[textLabel.center.y, textLabel.center.y - 60.0], duration:duration)
        yPositionAnimation.fillMode = kCAFillModeRemoved
        yPositionAnimation.removedOnCompletion = true
        textLabel.layer.addAnimation(yPositionAnimation, forKey: "yLabelPostionAnimation")

        let scaleAnimation = createAnimation("transform.scale", values:[1.0 ,2.0], duration:duration)
        scaleAnimation.fillMode = kCAFillModeRemoved
        scaleAnimation.removedOnCompletion = true
        textLabel.layer.addAnimation(scaleAnimation, forKey: "scaleLabelAnimation")

        let opacityAnimation = createAnimation("opacity", values:[1.0 ,0.0], duration:duration)
        textLabel.layer.addAnimation(opacityAnimation, forKey: "opacityLabelAnimation")
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
      
        let yPositionAnimation = createAnimation("position.y", values:[textLabel.center.y + 15, textLabel.center.y], duration:duration)
        textLabel.layer.addAnimation(yPositionAnimation, forKey: "yLabelPostionAnimation")

        let opacityAnimation = createAnimation("opacity", values:[0, 1], duration:duration)
        textLabel.layer.addAnimation(opacityAnimation, forKey: "opacityLabelAnimation")
    }

}
