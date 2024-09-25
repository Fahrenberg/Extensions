//
//  ColorTests.swift
//  
//
//  Created by Jean-Nicolas on 08.08.2024.
//

import XCTest
@testable import Extensions

import SwiftUI
import OSLog

// Testing Color extension (SwiftUI)
final class ColorTests: XCTestCase {
    
    func testInvalidHexColorToColor() {
        let expectedHexColor: HexColor = "#12345Z"
        let color = Color(hexColor: expectedHexColor)
        XCTAssertNil(color)
    }

    func testIntToColor() {
        let expectedIntColor: UInt = 0xffc5d93f
        let color = Color(hex: expectedIntColor)
        let resultIntColor: UInt = color.intColor!
        XCTAssertEqual(expectedIntColor, resultIntColor)
    }

    func testHexColorRGBToColor() {
        let hexColor: HexColor = "#c5d93f"
        let color = Color(hexColor: hexColor)
        XCTAssertNotNil(color)
        let resultHexColor = color!.hexColor
        let expectedHexColor: HexColor = "#ffc5d93f".uppercased()
        XCTAssertEqual(expectedHexColor, resultHexColor)
    }
    
    func testHexColorRGBAToColor() {
        let expectedHexColor: HexColor = "#ffc5d93f"
        let color = Color(hexColor: expectedHexColor)
        XCTAssertNotNil(color)
        let resultHexColor = color!.hexColor
        XCTAssertEqual(expectedHexColor.uppercased(), resultHexColor)
    }
    
    
    func testIntRGBToColor() {
        let expectedIntColor: UInt = 0xffc5d9
        let color = Color(hex: expectedIntColor)
        let resultIntColor: UInt = color.intColor!
        XCTAssertEqual(expectedIntColor, resultIntColor)
        
    }
    
}


// Testing HexColor (String) extension
class HexColorTests: XCTestCase {

    func testHexColorValidation() {
        // Test: only # or empty string -> false
        XCTAssertNil("".hexColor)
        XCTAssertNil("#".hexColor)
        
        // Test: valid 3 digit hex color -> true (Web)
        XCTAssertEqual("#ABC".hexColor, "#AABBCC")
        XCTAssertEqual("#1F3".hexColor, "#11FF33")
        
        // Test: valid 6 digit hex color -> true
        XCTAssertEqual("#123456".hexColor, "#123456")
        XCTAssertEqual("#abcdef".hexColor, "#ABCDEF")
        
        // Test: valid 8 digit hex color -> true
        XCTAssertEqual("#12345678".hexColor, "#12345678")
        XCTAssertEqual("#abcdef12".hexColor, "#ABCDEF12")
        XCTAssertEqual("#ffc5d93f".hexColor, "#FFC5D93F")
        // Test: valid 1, 2, 4, 5, 7 digit hex colors -> false
        XCTAssertNil("#1".hexColor)
        XCTAssertNil("#12".hexColor)
        XCTAssertNil("#1234".hexColor)
        XCTAssertNil("#12345".hexColor)
        XCTAssertNil("#1234567".hexColor)
        
        // Test: valid more than 8 digit hex color -> false
        XCTAssertNil("#123456789".hexColor)
        XCTAssertNil("#abcdef123".hexColor)
        
        // Test: invalid characters from the beginning -> false
        XCTAssertNil("#GHIJKL".hexColor)
        XCTAssertNil("#ZZZ123".hexColor)
        
        // Test: invalid characters after valid hex beginning -> false
        XCTAssertNil("#12345Z".hexColor)
        XCTAssertNil("#123ABCXYZ".hexColor)
    }
    
    func testAdditionalHexColorCases() {
        // Test: double #
        XCTAssertEqual("##ABC".hexColor, "#AABBCC")
        // Test: leading/trailing spaces
        XCTAssertEqual("  #ABC  ".hexColor, "#AABBCC")
        XCTAssertEqual("   #123456   ".hexColor, "#123456")
        
        // Test: no # prefix
        XCTAssertEqual("123456".hexColor, "#123456")
        
        // Test: all lowercase letters
        XCTAssertEqual("abcdef".hexColor, "#ABCDEF")
        
        // Test: mixed uppercase and lowercase letters
        XCTAssertEqual("#aBcDeF".hexColor, "#ABCDEF")
        
        // Test: all uppercase letters
        XCTAssertEqual("#ABCDEF".hexColor, "#ABCDEF")
        
        // Test: 8 digits without # prefix
        XCTAssertEqual("12345678".hexColor, "#12345678")
        
        // Test: valid hex with invalid characters after trimming whitespace
        // Ensures that removing whitespace doesn't mask invalid characters.
        XCTAssertNil(" 123Z56 ".hexColor)
    }

}
