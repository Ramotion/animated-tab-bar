import XCTest
@testable import Animated_Tab_Bar

class RAMBadgeTests: XCTestCase {
    
    var badge: RAMBadge!

    override func setUp() {
        badge = RAMBadge.badge()
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
