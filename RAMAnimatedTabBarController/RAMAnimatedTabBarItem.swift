//  RAMAnimatedTabBarItem.swift
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

/// UITabBarItem with animation
open class RAMAnimatedTabBarItem: UITabBarItem {

    open override var isEnabled: Bool {
        didSet {
            iconView?.icon.alpha = isEnabled == true ? 1 : 0.5
            iconView?.textLabel.alpha = isEnabled == true ? 1 : 0.5
        }
    }
    
    /// Animation for UITabBarItem. Use RAMFumeAnimation, RAMBounceAnimation, RAMRotationAnimation, RAMFrameItemAnimation, RAMTransitionAnimation
    /// Also posible create custom anmation inherit from the RAMItemAnimation look for https://github.com/Ramotion/animated-tab-bar#creating-custom-animations
    @IBOutlet open var animation: RAMItemAnimation!

    /// The font used to render the UITabBarItem text.
    @IBInspectable open var textFontSize: CGFloat = 10

    /// The color of the UITabBarItem text.
    @IBInspectable open var textColor: UIColor = #colorLiteral(red: 0.5079551811, green: 0.5472556715, blue: 0.6011400746, alpha: 1)

    /// The tint color of the UITabBarItem icon.
    @IBInspectable open var iconColor: UIColor = UIColor.clear // if alpha color is 0 color ignoring

    open var bgDefaultColor: UIColor = UIColor.clear // background color
    open var bgSelectedColor: UIColor = UIColor.clear

    //  The current badge value
    open var badge: RAMBadge? // use badgeValue to show badge

    // Container for icon and text in UITableItem.
    open var iconView: (icon: UIImageView, textLabel: UILabel)?

    /**
     Start selected animation
     */
    open func playAnimation() {

        assert(animation != nil, "add animation in UITabBarItem")
        guard animation != nil, let iconView = iconView else {
            return
        }
        animation.playAnimation(iconView.icon, textLabel: iconView.textLabel)
    }

    /**
     Start unselected animation
     */
    open func deselectAnimation() {

        guard animation != nil && iconView != nil else {
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
    open func selectedState() {
        guard animation != nil, let iconView = iconView else {
            return
        }

        animation.selectedState(iconView.icon, textLabel: iconView.textLabel)
    }
    
    /**
     Set deselected state without animation
     */
    open func deselectedState() {
        guard animation != nil && iconView != nil else {
            return
        }
        
        animation.deselectedState(iconView!.icon, textLabel: iconView!.textLabel)
    }
}


// MARK: Custom Badge
extension RAMAnimatedTabBarItem {

    /// The current badge value
    open override var badgeValue: String? {
        get {
            return badge?.text
        }
        set(newValue) {

            if newValue == nil {
                badge?.removeFromSuperview()
                badge = nil
                return
            }

            if let iconView = iconView, let contanerView = iconView.icon.superview, badge == nil {
                badge = RAMBadge.badge()
                badge?.addBadgeOnView(contanerView)
            }

            badge?.text = newValue
        }
    }
}
