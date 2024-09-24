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


final class ColorTests: XCTestCase {
    
    func testHexColorToColor() {
        let expectedHexColor: HexColor = "#ffc5d9".uppercased()
        let color = Color(hexColor: expectedHexColor)
        XCTAssertNotNil(color)
        let resultHexColor = color!.hexColor
        XCTAssertEqual(expectedHexColor, resultHexColor)
    }
    
    func testIntToColor() {
        let expectedIntColor: UInt = 0xffc5d93f
        let color = Color(hex: expectedIntColor)
        let resultIntColor: UInt = color.intColor!
        XCTAssertEqual(expectedIntColor, resultIntColor)
    }

    func testHexColorRGBAToColor() {
        let expectedHexColor: HexColor = "#ffc5d93f".uppercased()
        let color = Color(hexColor: expectedHexColor)
        XCTAssertNotNil(color)
        let resultHexColor = color!.hexColor
        XCTAssertEqual(expectedHexColor, resultHexColor)
    }
    
    
    func testIntRGBToColor() {
        let expectedIntColor: UInt = 0xffc5d9
        let color = Color(hex: expectedIntColor)
        let resultIntColor: UInt = color.intColor!
        XCTAssertEqual(expectedIntColor, resultIntColor)
        
    }
    
    
    func testInvalidHexColorToColor() {
        let invalidHexColor = "#invalid hex color"
        let color = Color(hexColor: invalidHexColor)
        print("Color: \(color?.hexColor ?? "nil")")
        XCTAssertNil(color)
    }
    
    func testHexColorStringTooLongToColor() {
        let invalidHexColor = "#AAFF21_invalid hex color" // too long
        let color = Color(hexColor: invalidHexColor)
        print("Color: \(color?.hexColor ?? "nil")")
        XCTAssertNil(color, color?.hexColor ?? "nil")
    }
}
