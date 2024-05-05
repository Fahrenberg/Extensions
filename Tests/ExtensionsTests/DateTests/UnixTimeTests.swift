//
// UnixTimeTests
//

import XCTest
@testable import Extensions
final class UnixTimeTests: XCTestCase {


  func testUnixTimeToDateString() {
      
    let expectedDate = Date()
    let testedUnixTime = expectedDate.timeIntervalSince1970
    let testedLocales = [Locale.current.identifier, "", "de-CH", nil]
    
    for locale in testedLocales {
       
      let dateFormatter = DateFormatter()
      dateFormatter.timeStyle = DateFormatter.Style.short //Set time style hh:mm
      dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style dd.mm.yyy
      
      
      if let current_locale = locale {
        dateFormatter.locale = Locale(identifier: current_locale)
      }
      
      let expectedDateString = dateFormatter.string(from: expectedDate)
      var testedDateString = ""
      if let current_locale =  locale {
        testedDateString = testedUnixTime.unixTimeToDateString(languageCode: current_locale)
      
      } else {
          testedDateString = testedUnixTime.unixTimeToDateString()
      }
      
//    print("testUnixTimeToDateString", expectedDateString, testedDateString)
      XCTAssertEqual(expectedDateString , testedDateString)
    }
      
  }

} 
