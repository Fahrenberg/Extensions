// --------------------------------------------------------------------------------------
// -------------------------   String - Extensions -------------------------------
// --------------------------------------------------------------------------------------


import Foundation

extension String {
    /// Check if String can be converted to a number for US locale numbers
    public var isNumber: Bool {
        let locale = Locale(identifier: "de_US") // "Fahrenberg" special swiss locale  = de_US
        
        let decimalSeparator = UnicodeScalar(locale.decimalSeparator ?? "")!
        let groupingSeparator =
        UnicodeScalar(locale.groupingSeparator ?? "")!
        var numberSet = CharacterSet.decimalDigits
        numberSet.insert(decimalSeparator)
        numberSet.insert(groupingSeparator)
        
        return self.rangeOfCharacter(from: numberSet.inverted) == nil
    }

    /// Clean up parsing string
   public var removeWhitespaceAndNewLines: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
}


extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
       public var errorDescription: String? { return self }
   }
   
