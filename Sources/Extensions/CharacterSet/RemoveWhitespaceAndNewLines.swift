
//MARK: -------------------------------------------------------------------------
//MARK: ---------------------------- String clean up ----------------------------
//MARK: -------------------------------------------------------------------------
extension String {
    /// Clean up parsing string
   public var removeWhitespaceAndNewLines: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
