//
// Convert Date into Numbers/Excel Date String or Excel Date Serial Number
//


import XCTest
@testable import Extensions
final class TestExcelDateConversion: XCTestCase {
    
  func testExcelDateSerialNumber() {
    let testDateComponent = DateComponents(year: 2020, month: 10, day: 05,
                                               hour: 12, minute: 30)
    let testDate = Calendar.current.date(from: testDateComponent)!
  
    let resultExcelDateValue = testDate.excelDateSerialNumber
    //  [Excel Sheet to get Date Serial Number](https://www.icloud.com/iclouddrive/02dTgEOm0wGXd9o5B9fvVlsZQ#ExcelDateValue)
    let expectedExcelDateValue = 44109.52083 
    
    XCTAssertEqual(resultExcelDateValue, expectedExcelDateValue, accuracy: 0.0001)
  }

  func testExcelDateString() {
    //  December 9, 1968, at 15:45:25 p.m. Pacific Time Zone
    let iso8601DateFormatter = ISO8601DateFormatter()
    iso8601DateFormatter.timeZone = .autoupdatingCurrent
    // assume all ISO8601 are provided UTC GMT
    let testDate = iso8601DateFormatter.date(from: "1968-12-09T15:45:15Z")!
    let expectedDateString = "09.12.1968 15:45:15"

    let resultDateString = testDate.excelDateString

    // print("TEST:", testDate.description, expectedDateString, resultDateString)
    XCTAssertEqual(expectedDateString,resultDateString) 
  }    
    
}
