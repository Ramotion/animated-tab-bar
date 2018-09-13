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
        _ = tabBarController.view
        
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateController() {
        XCTAssertNotNil(tabBarController)
    }
    
    func testIsBottomLineShowen() {
        
        XCTAssertEqual(tabBarController.bottomLine, nil)

        tabBarController.isBottomLineShow = true
        XCTAssertNotNil(tabBarController.bottomLine)
        
        tabBarController.isBottomLineShow = false
        XCTAssertEqual(tabBarController.bottomLine, nil)
    }
    
    func testChangeSelectedColor() {
        let selectedColor = UIColor.red
        let iconSelectedColor = UIColor.green
        tabBarController.changeSelectedColor(selectedColor, iconSelectedColor: iconSelectedColor)
        
        tabBarController.animatedItems.forEach {
            XCTAssertEqual($0.animation.textSelectedColor, selectedColor)
            XCTAssertEqual($0.animation.iconSelectedColor, iconSelectedColor)
        }
    }
    
    func testAnimationBarHidden() {
    
        XCTAssertEqual(tabBarController.tabBar.isHidden, false)
        tabBarController.animatedItems.forEach {
            XCTAssertEqual($0.iconView?.icon.superview?.isHidden, false)
        }
        
        tabBarController.animationTabBarHidden(true)
        
        XCTAssertEqual(tabBarController.tabBar.isHidden, true)
        tabBarController.animatedItems.forEach {
            XCTAssertEqual($0.iconView?.icon.superview?.isHidden, true)
        }
    }
}
