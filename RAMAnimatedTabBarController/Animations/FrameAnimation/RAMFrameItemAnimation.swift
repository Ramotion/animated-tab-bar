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

class RAMFrameItemAnimation: RAMItemAnimation {

    var animationImages : Array<CGImage> = Array()

    var selectedImage : UIImage!

    @IBInspectable var isDeselectAnimation: Bool = true
    @IBInspectable var imagesPath: String!

    override func awakeFromNib() {

        let path = NSBundle.mainBundle().pathForResource(imagesPath, ofType:"plist")

        let dict : NSDictionary = NSDictionary(contentsOfFile: path!)!

        let animationImagesName = dict["images"] as! Array<String>
        createImagesArray(animationImagesName)

        // selected image
        let selectedImageName = animationImagesName[animationImagesName.endIndex - 1]
        selectedImage = UIImage(named: selectedImageName)
    }


    func createImagesArray(imageNames : Array<String>) {
        for name : String in imageNames {
            let image = UIImage(named: name)?.CGImage
            animationImages.append(image!)
        }
    }

    override func playAnimation(icon : UIImageView, textLabel : UILabel) {

        playFrameAnimation(icon, images:animationImages)
        textLabel.textColor = textSelectedColor
    }

    override func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        if isDeselectAnimation {
            playFrameAnimation(icon, images:animationImages.reverse())
        }

        textLabel.textColor = defaultTextColor
    }

    override func selectedState(icon : UIImageView, textLabel : UILabel) {
        icon.image = selectedImage
        textLabel.textColor = textSelectedColor
    }

    func playFrameAnimation(icon : UIImageView, images : Array<CGImage>) {
        let frameAnimation = CAKeyframeAnimation(keyPath: "contents")
        frameAnimation.calculationMode = kCAAnimationDiscrete
        frameAnimation.duration = NSTimeInterval(duration)
        frameAnimation.values = images
        frameAnimation.repeatCount = 1
        frameAnimation.removedOnCompletion = false
        frameAnimation.fillMode = kCAFillModeForwards
        icon.layer.addAnimation(frameAnimation, forKey: "frameAnimation")
    }
}
