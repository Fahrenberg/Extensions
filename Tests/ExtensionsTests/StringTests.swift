    import XCTest
    @testable import Extensions

    final class StringTests: XCTestCase {
        
        func testIsNumber() {
            // "Fahrenberg" special swiss locale  = de_US
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
