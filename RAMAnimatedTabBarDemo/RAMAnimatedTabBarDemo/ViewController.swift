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
        // example for showing badges
        index += 1
        tabBarItem.badgeValue = "\(index)"
    }

    @IBAction func hideBadgeHandler(_: AnyObject) {
        tabBarItem.badgeValue = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesuter = UITapGestureRecognizer(target: self, action: #selector(selected(sender:)))
        view.addGestureRecognizer(gesuter)
    }
    
    @objc func selected(sender: UIGestureRecognizer) {
        tabBarController?.viewControllers?.remove(at: 0)
    }
}
