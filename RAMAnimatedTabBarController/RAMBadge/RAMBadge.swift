//  RAMBadge.swift
//
// Copyright (c) 17/12/15 Ramotion Inc. (http://ramotion.com)
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
// THE SOFTWARE

import UIKit

open class RAMBadge: UILabel {

    internal var topConstraint: NSLayoutConstraint?
    internal var centerXConstraint: NSLayoutConstraint?

    open class func badge() -> RAMBadge {
        return RAMBadge(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        layer.backgroundColor = UIColor.red.cgColor
        layer.cornerRadius = frame.size.width / 2

        configureNumberLabel()

        translatesAutoresizingMaskIntoConstraints = false

        // constraints
        createSizeConstraints(frame.size)
    }

    open override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += 10.0
        return contentSize
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // PRAGMA: create

    internal func createSizeConstraints(_ size: CGSize) {
        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: size.width)
        addConstraint(widthConstraint)

        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: size.height)
        addConstraint(heightConstraint)
    }

    fileprivate func configureNumberLabel() {
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 13)
        textColor = UIColor.white
    }

    // PRAGMA: helpers

    open func addBadgeOnView(_ onView: UIView) {

        onView.addSubview(self)

        // create constraints
        let top = NSLayoutConstraint(item: self,
                                           attribute: NSLayoutConstraint.Attribute.top,
                                           relatedBy: NSLayoutConstraint.Relation.equal,
                                           toItem: onView,
                                           attribute: NSLayoutConstraint.Attribute.top,
                                           multiplier: 1,
                                           constant: 3)
        onView.addConstraint(top)
        topConstraint = top

        let centerX = NSLayoutConstraint(item: self,
                                               attribute: NSLayoutConstraint.Attribute.centerX,
                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                               toItem: onView,
                                               attribute: NSLayoutConstraint.Attribute.centerX,
                                               multiplier: 1,
                                               constant: 10)
        onView.addConstraint(centerX)
        centerXConstraint = centerX
    }
}
