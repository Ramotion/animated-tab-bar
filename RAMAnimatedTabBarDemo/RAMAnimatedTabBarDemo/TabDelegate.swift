//
//  TabDelegate.swift
//  RAMAnimatedTabBarDemo
//
//  Created by Yuri Ferretti on 5/30/15.
//  Copyright (c) 2015 Ramotion. All rights reserved.
//

import UIKit

class TabDelegate: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        println(tabBarController.selectedIndex)
    }
}
