//
//  TestExportData.swift
//  RuKaTests
//
//  Created by Jean-Nicolas on 07.10.22.
//

import XCTest
@testable import Extensions
final class TestDateExtension: XCTestCase {
    
    func testExcelDate() {
        let testDateComponent = DateComponents(year: 2020, month: 10, day: 05,
                                               hour: 12, minute: 30)
        let testDate = Calendar.current.date(from: testDateComponent)!
        
        let resultExcelDateValue = testDate.excelDateValue
        let expectedExcelDateValue = 44109.52083 //  [Excel Sheet to get Date Serial Number](https://www.icloud.com/iclouddrive/02dTgEOm0wGXd9o5B9fvVlsZQ#ExcelDateValue)
        
        XCTAssertEqual(resultExcelDateValue, expectedExcelDateValue, accuracy: 0.0001)
    }
    
    
    func testUnixTimeToDateString() {
        
        let expectedDate = Date()
        let testedUnixTime = expectedDate.timeIntervalSince1970
        let testedLocales = [Locale.current.identifier, "", "de-CH", nil]
        
        for locale in testedLocales {
           
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style hh:mm
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style dd.mm.yyy
            
            
            if  let current_locale =  locale {
                dateFormatter.locale =   Locale(identifier: current_locale)
            }
            
            let expectedDateString = dateFormatter.string(from: expectedDate)
            var testedDateString = ""
            if  let current_locale =  locale {
                testedDateString = testedUnixTime.unixTimeToDateString(languageCode: current_locale) // languageCode: current_locale)
            
            } else {
                testedDateString = testedUnixTime.unixTimeToDateString() // languageCode: current_locale)
            }
            
            
//                print("testUnixTimeToDateString", expectedDateString,testedDateString)
            XCTAssertEqual(expectedDateString , testedDateString)
        }
        
        
        
    }

    
    
}
