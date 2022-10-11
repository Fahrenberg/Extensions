// --------------------------------------------------------------------------------------
// -------------------------   String - Extensions -------------------------------
// --------------------------------------------------------------------------------------


import Foundation

extension String {
    /// Check if String can be converted to a number
    ///
    public var isNumber: Bool {
        let decimalSeparator = UnicodeScalar(Locale.current.decimalSeparator ?? "")!
        let groupingSeparator =
        UnicodeScalar(Locale.current.groupingSeparator ?? "")!
        var numberSet = CharacterSet.decimalDigits
        numberSet.insert(decimalSeparator)
        numberSet.insert(groupingSeparator)
        
        return self.rangeOfCharacter(from: numberSet.inverted) == nil
    }

}
