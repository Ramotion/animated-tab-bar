//
//  ViewController.swift
//  RAMAnimatedTabBarDemo
//
//  Created by Alex Kalinkin on 11/18/14.
//  Copyright (c) 2014 Ramotion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var index: NSInteger = 0

    // PRAGMA: actions
    @IBAction func showBadgeHandelr(_: AnyObject) {
        index += 1
        tabBarItem.badgeValue = "\(index)"
    }

    @IBAction func hideBadgeHandler(_: AnyObject) {
        tabBarItem.badgeValue = nil
    }
}
