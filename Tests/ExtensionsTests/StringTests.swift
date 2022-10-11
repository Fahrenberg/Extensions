    import XCTest
    @testable import Extensions

    final class StringTests: XCTestCase {
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
        
        func testIsNumber() {
            // locale de_US required for test
            let valid = ["123.56", "1,345.04", "1345.50"]
            let wrong = ["CHF 123.4", "NotANumber", "1 345.50", "123'459"]
            
            valid.forEach {test in
                XCTAssertTrue(test.isNumber, "\(test) - locale \(Locale.current)")
            }
            wrong.forEach {test in
                XCTAssertFalse(test.isNumber, "\(test) - locale \(Locale.current)")
            }
        }
    }
