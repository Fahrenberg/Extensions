//
//  TestExportData.swift
//  RuKaTests
//
//  Created by Jean-Nicolas on 07.10.22.
//

import XCTest
@testable import Extensions
final class TestExcelDateExtension: XCTestCase {
    
    func testExcelDate() {
        let testDateComponent = DateComponents(year: 2020, month: 10, day: 05,
                                               hour: 12, minute: 30)
        let testDate = Calendar.current.date(from: testDateComponent)!
        
        let resultExcelDateValue = testDate.excelDateValue
        let expectedExcelDateValue = 44109.52083 //  [Excel Sheet to get Date Serial Number](https://www.icloud.com/iclouddrive/02dTgEOm0wGXd9o5B9fvVlsZQ#ExcelDateValue)
        
        XCTAssertEqual(resultExcelDateValue, expectedExcelDateValue, accuracy: 0.0001)
    }
    

    
    
}
