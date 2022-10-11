//
//  CoreGraphics Test Cases
//  

import XCTest
@testable import Extensions


final class CoreGraphicsTest: XCTestCase {
    
    func testCGSizeAddition() {
        let left = CGSize(width: 20, height: 30)
        let right = CGSize(width: 50, height: 70)
        let expected = CGSize(width: 70, height: 100)
        let addition = left + right
        XCTAssertEqual(expected, addition)
    }
    
    func testCGSizeSubstraction() {
        let left = CGSize(width: 20, height: 30)
        let right = CGSize(width: 50, height: 70)
        let expected = CGSize(width: -30, height: -40)
        let addition = left - right
        XCTAssertEqual(expected, addition)
    }
    
    func testCGSizeFaktorMultiplication() {
        let left = CGSize(width: 20, height: 30)
        let right: CGFloat = 5.0
        let expected = CGSize(width: 100, height: 150)
        let addition = left * right
        XCTAssertEqual(expected, addition)
    }
    
}
