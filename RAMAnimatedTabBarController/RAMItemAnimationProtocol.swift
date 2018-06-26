//  RAMItemAnimationProtocol.swift
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

import Foundation
import UIKit

public protocol RAMItemAnimationProtocol {

    func playAnimation(_ icon: UIImageView, textLabel: UILabel)
    func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor)
    func selectedState(_ icon: UIImageView, textLabel: UILabel)
}

/// Base class for UITabBarItems animation
open class RAMItemAnimation: NSObject, RAMItemAnimationProtocol {

    // MARK: constants

    struct Constants {

        struct AnimationKeys {

            static let Scale = "transform.scale"
            static let Rotation = "transform.rotation"
            static let KeyFrame = "contents"
            static let PositionY = "position.y"
            static let Opacity = "opacity"
        }
    }

    // MARK: properties

    /// The duration of the animation
    @IBInspectable open var duration: CGFloat = 0.5

    ///  The text color in selected state.
    @IBInspectable open var textSelectedColor: UIColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)

    ///  The icon color in selected state.
    @IBInspectable open var iconSelectedColor: UIColor!

    /**
     Start animation, method call when UITabBarItem is selected

     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    open func playAnimation(_: UIImageView, textLabel _: UILabel) {
        fatalError("override method in subclass")
    }

    /**
     Start animation, method call when UITabBarItem is unselected

     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     - parameter defaultTextColor: default UITabBarItem text color
     - parameter defaultIconColor: default UITabBarItem icon color
     */
    open func deselectAnimation(_: UIImageView, textLabel _: UILabel, defaultTextColor _: UIColor, defaultIconColor _: UIColor) {
        fatalError("override method in subclass")
    }

    /**
     Method call when TabBarController did load

     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    open func selectedState(_: UIImageView, textLabel _: UILabel) {
        fatalError("override method in subclass")
    }
    
    /**
     (Optional) Method call when TabBarController did load
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    open func deselectedState(_: UIImageView, textLabel _: UILabel) {}
}
