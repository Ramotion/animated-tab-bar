//
//  RAMBadge.swift
//  RAMAnimatedTabBarDemo
//
//  Created by Alex K. on 17/12/15.
//  Copyright © 2015 Ramotion. All rights reserved.
//

import UIKit

public class RAMBadge: UILabel {
    
    internal var topConstraint: NSLayoutConstraint?
    internal var centerXConstraint: NSLayoutConstraint?

    public class func badge() -> RAMBadge {
        return RAMBadge.init(frame: CGRectMake(0, 0, 18, 18))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.backgroundColor = UIColor.redColor().CGColor;
        layer.cornerRadius = frame.size.width / 2;
        
        configureNumberLabel()

        translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        createSizeConstraints(frame.size)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // PRAGMA: create
    
    internal func createSizeConstraints(size: CGSize) {
        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.GreaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.width)
        self.addConstraint(widthConstraint)

        
        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.height)
        self.addConstraint(heightConstraint)
    }
    
    private func configureNumberLabel()  {
        textAlignment = .Center
        font = UIFont.systemFontOfSize(13)
        textColor = UIColor.whiteColor()
    }
    
    // PRAGMA: helpers
    
    public func addBadgeOnView(onView:UIView) {

        onView.addSubview(self)

        // create constraints
        topConstraint = NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: onView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 3)
        onView.addConstraint(topConstraint!)
        
        centerXConstraint = NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: onView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 10)
        onView.addConstraint(centerXConstraint!)
    }
}
