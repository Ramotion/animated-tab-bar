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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // PRAGMA: actions
    
    @IBAction func showBadgeHandelr(_ sender: AnyObject) {
        index += 1
        self.tabBarItem.badgeValue = "\(index)"
    }
  
    @IBAction func hideBadgeHandler(_ sender: AnyObject) {
        self.tabBarItem.badgeValue = nil
    }
}
