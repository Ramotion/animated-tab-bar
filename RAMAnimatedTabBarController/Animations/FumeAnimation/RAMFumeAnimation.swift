
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
    
    override func playAnimation(icon : UIImageView, textLable : UILabel) {
        playMoveIconAnimation(icon, values:[icon.center.y, icon.center.y + 4.0])
        playLableAnimation(textLable)
        textLable.textColor = textSelectedColor
    }
    
    override func deselectAnimation(icon : UIImageView, textLable : UILabel, defaultTextColor : UIColor) {
        playMoveIconAnimation(icon, values:[icon.center.y + 4.0, icon.center.y])
        playDeselectLableAniation(textLable)
        textLable.textColor = defaultTextColor
    }
    
    override func selectedState(icon : UIImageView, textLable : UILabel) {
        
        playMoveIconAnimation(icon, values:[icon.center.y + 8.0])
        textLable.alpha = 0
        textLable.textColor = textSelectedColor
    }
    
    func playMoveIconAnimation(icon : UIImageView, values: [AnyObject]) {
        
        let yPositionAnimation = createAnimation("position.y", values:values, duration:duration / 2)
        
        icon.layer.addAnimation(yPositionAnimation, forKey: "yPositionAnimation")
    }
    
    // MARK: select animation
    
    func playLableAnimation(textLable: UILabel) {
        
        let yPositionAnimation = createAnimation("position.y", values:[textLable.center.y, textLable.center.y - 60.0], duration:duration)
        yPositionAnimation.fillMode = kCAFillModeRemoved
        yPositionAnimation.removedOnCompletion = true
        textLable.layer.addAnimation(yPositionAnimation, forKey: "yLablePostionAniamtion")
        
        let scaleAnimation = createAnimation("transform.scale", values:[1.0 ,2.0], duration:duration)
        scaleAnimation.fillMode = kCAFillModeRemoved
        scaleAnimation.removedOnCompletion = true
        textLable.layer.addAnimation(scaleAnimation, forKey: "scaleLableAnimation")
        
        let opacityAnimation = createAnimation("opacity", values:[1.0 ,0.0], duration:duration)
        textLable.layer.addAnimation(opacityAnimation, forKey: "opacityLableAnimation")
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
    
    func playDeselectLableAniation(textLable: UILabel) {
       
        let yPositionAnimation = createAnimation("position.y", values:[textLable.center.y + 15, textLable.center.y], duration:duration)
        textLable.layer.addAnimation(yPositionAnimation, forKey: "yLablePostionAniamtion")
        
        let opacityAnimation = createAnimation("opacity", values:[0, 1], duration:duration)
        textLable.layer.addAnimation(opacityAnimation, forKey: "opacityLableAnimation")
    }
    
}