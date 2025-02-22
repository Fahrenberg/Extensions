//
//  ColorScheme.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//
import SwiftUI

extension Color {
    /// https://gist.github.com/delputnam/2d80e7b4bd9363fd221d131e4cfdbd8f
    public func isLight() -> Bool {
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        guard let (r, g, b, _) = self.colorComponents else {
            return true
        }
        
        let brightness = ((r * 299) + (g * 587) + (b * 114)) / 1_000
        return brightness >= 0.5
    }
}

extension ColorScheme  {
    public var description: String {
        return self == .light ? "Light" : "Dark"
    }
}
