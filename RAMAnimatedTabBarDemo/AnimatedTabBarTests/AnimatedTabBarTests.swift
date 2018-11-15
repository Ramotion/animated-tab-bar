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
    
    func testSelectIndex() {
        let toIndex = 2
        tabBarController.setSelectIndex(from: 0, to: toIndex)
        XCTAssertEqual(tabBarController.selectedIndex, toIndex)
    }
    
    func testAnimatedItems() {
        XCTAssertEqual(tabBarController.viewControllers?.count, tabBarController.animatedItems.count)
    }
    
    func testIsBottomLineShow() {
        XCTAssertEqual(tabBarController.isBottomLineShow, false)
        XCTAssertNil(tabBarController.bottomLine)
        tabBarController.isBottomLineShow = true
        
        XCTAssertEqual(tabBarController.isBottomLineShow, true)
        XCTAssertNotNil(tabBarController.bottomLine)
    }
    
    func testBottomLineColor() {
        let color = UIColor.red
        tabBarController.isBottomLineShow = true
        XCTAssertNotEqual(tabBarController.bottomLine, color)
        tabBarController.bottomLineColor = color
        XCTAssertEqual(tabBarController.bottomLineColor, color)
    }
    
    func testContainersCount() {
        XCTAssertEqual(tabBarController.viewControllers?.count, tabBarController.containers.count)
    }
    
    func testBadge() {
        let value = "1"
        tabBarController.animatedItems.first?.badgeValue = value
        XCTAssertEqual(tabBarController.animatedItems.first?.badgeValue, tabBarController.animatedItems.first?.badge?.text)
    }
    
    func testIsEnabled() {
        guard let item = tabBarController.animatedItems.first else { return }
        item.isEnabled = true
        XCTAssertEqual(item.iconView?.icon.alpha, 1)
        XCTAssertEqual(item.iconView?.textLabel.alpha, 1)
        
        item.isEnabled = false
        XCTAssertEqual(item.iconView?.icon.alpha, 0.5)
        XCTAssertEqual(item.iconView?.textLabel.alpha, 0.5)
    }
    
}
