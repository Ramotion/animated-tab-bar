//
//  RAMBadgeTests.swift
//  AnimatedTabBarTests
//
//  Created by Alex K on 06/12/2018.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import XCTest
@testable import Animated_Tab_Bar

class RAMBadgeTests: XCTestCase {
    
    var badge: RAMBadge!

    override func setUp() {
        badge = RAMBadge.badge()
    }

    override func tearDown() {
    }

    func testCreateBadge() {
        XCTAssertNotNil(badge)
    }
    
    func testAddBadgeOnView() {
        let view = UIView()
        XCTAssertNil(badge.superview)
        badge.addBadgeOnView(view)
        XCTAssertNotNil(badge.superview)
        XCTAssertNotNil(badge.topConstraint)
        XCTAssertNotNil(badge.centerXConstraint)
    }
}
