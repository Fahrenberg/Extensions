//
// Convert Date into Numbers/Excel Date String or Excel Date Serial Number
//


import XCTest
@testable import Extensions
final class TestExcelDateString: XCTestCase {
    
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
    let testDate = iso8601DateFormatter.date(from: "1968-12-09T15:45:00-08:00")!

    print("TESTDATE:", testDate.description)
    XCTFail("not yet implemented testDateToISOString")
  }    
    
}
