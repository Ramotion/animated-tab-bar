//  RAMTransitionItemAniamtions.swift
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

class RAMTransitionItemAniamtions : RAMItemAnimation {

    var transitionOptions : UIViewAnimationOptions!

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.TransitionNone
    }

    override func playAnimation(icon : UIImageView, textLabel : UILabel) {

        selectedColor(icon, textLabel: textLabel)

        UIView.transitionWithView(icon, duration: NSTimeInterval(duration), options: transitionOptions, animations: {
            }, completion: { _ in
        })
    }

    override func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {

        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysOriginal)
            icon.image = renderImage
            textLabel.textColor = defaultTextColor
        }
    }

    override func selectedState(icon : UIImageView, textLabel : UILabel) {

        selectedColor(icon, textLabel: textLabel)
    }


    func selectedColor(icon : UIImageView, textLabel : UILabel) {

        if let iconImage = icon.image where iconSelectedColor != nil {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }

        textLabel.textColor = textSelectedColor
    }
}

class RAMFlipLeftTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
    }
}


class RAMFlipRightTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
    }
}

class RAMFlipTopTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.TransitionFlipFromTop
    }
}

class RAMFlipBottomTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.TransitionFlipFromBottom
    }
}
