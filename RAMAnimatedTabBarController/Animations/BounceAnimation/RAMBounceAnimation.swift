//  RAMBounceAnimation.swift
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


public class RAMBounceAnimation : RAMItemAnimation {

    override public func playAnimation(icon : UIImageView, textLabel : UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    override public func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor: UIColor) {
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
        textLabel.textColor = textSelectedColor
      
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
    }

    func playBounceAnimation(icon : UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: Constants.AnimationKeys.Scale)
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic

        icon.layer.addAnimation(bounceAnimation, forKey: nil)
      
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
    }

}
