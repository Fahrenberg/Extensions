//
//  ColorScheme.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//
import SwiftUI

extension Color {
    /// Proxy calculation if `Color is a light or dark color
    ///
    /// Calculates if foreground and background color combinations provide **not** sufficient contrast when viewed by someone having color deficits or when viewed on a black and white screen
    ///
    /// [GitHub Gist](https://gist.github.com/delputnam/2d80e7b4bd9363fd221d131e4cfdbd8f)
    ///
    /// [Used Algorithm](http://www.w3.org/WAI/ER/WD-AERT/#color-contrast)
    ///
    public func isLight() -> Bool {
       
        guard let (r, g, b, _) = self.colorComponents else {
            return true
        }
        
        let brightness = ((r * 299) + (g * 587) + (b * 114)) / 1_000
        return brightness >= 0.5
    }
}

extension ColorScheme  {
    /// Selected color scheme for device
    public var description: String {
        return self == .light ? "Light" : "Dark"
    }
}
