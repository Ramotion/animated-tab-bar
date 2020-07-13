//
//  TabBarController.swift
//  RAMAnimatedTabBarDemo
//
//  Created by Igor K. on 13.07.2020.
//  Copyright © 2020 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import RAMAnimatedTabBarController

final class TabBarController: RAMAnimatedTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Example #2. To prevent tab bar appearance please make sure that there is no controllers with:
        ///hidesBottomBarWhenPushed == true, because after poping this controller tab bar will appear automatically
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tabBar.isHidden = true
        }
        */
    }
}
