//
//  Test String & CharacterSet
//  

import XCTest
@testable import Extensions


final class CharacterSetTests: XCTestCase {
    
    func testRemoveWhiteLineAndNewLine() {
        let unicodeScalarZeroWidthSpace =  UnicodeScalar(0x200B)!  // Check Special Case!!!, isWhiteSpace, isNewLine ignore zeroWidthSpace!
        var newLineWhiteSpaces = CharacterSet.whitespacesAndNewlines
        newLineWhiteSpaces.insert(unicodeScalarZeroWidthSpace)
        
        
        let arrayNewLineWhiteSpaces = newLineWhiteSpaces.allCharacters()
        for character in arrayNewLineWhiteSpaces {
            XCTAssertEqual(String(character).removeWhitespaceAndNewLines, "",
                           "whitespacesAndNewlines-Unicode 0x\(character.unicodeScalars.map({$0.escaped(asASCII: true) }) ) not removed" )
        }
        
        
       
        
        
        
    }
}
