//
//  RAMBadge.swift
//  RAMAnimatedTabBarDemo
//
//  Created by Alex K. on 17/12/15.
//  Copyright © 2015 Ramotion. All rights reserved.
//

import UIKit

public class RAMBadge: UILabel {
    
    var topConstraint: NSLayoutConstraint?
    var centerXConstraint: NSLayoutConstraint?
    var numberLabel: UILabel?
    
    class func bage()->RAMBadge {
        return RAMBadge.init(frame: CGRectMake(0, 0, 18, 18))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.backgroundColor = UIColor.redColor().CGColor;
        self.layer.cornerRadius = frame.size.width / 2;
        
       configureNumberLabel()

        self.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        createSizeConstraints(frame.size)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // PRAGMA: create
    
    func createSizeConstraints(size: CGSize) {
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
    
    func configureNumberLabel()  {
        
        self.textAlignment = .Center
        self.font = UIFont.systemFontOfSize(13)
        self.textColor = UIColor.whiteColor()
    }
    
    // PRAGMA: helpers
    
    func addBadgeOnView(onView:UIView) {

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
