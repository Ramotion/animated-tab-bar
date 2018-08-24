//
//  AnimatedTabBarTests.swift
//  AnimatedTabBarTests
//
//  Created by Alex K on 17/08/2018.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import XCTest
@testable import Animated_Tab_Bar

class AnimatedTabBarTests: XCTestCase {
    
    var tabBarController: RAMAnimatedTabBarController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tabBarController = storyboard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController") as? RAMAnimatedTabBarController
        
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateController() {
        XCTAssertNotNil(tabBarController)
    }
}
