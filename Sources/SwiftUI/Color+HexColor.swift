// --------------------------------------------------------------------------------------
// ------------------- SwiftUI - Color - HexCoding Extensions ---------------------------
// --------------------------------------------------------------------------------------

// MARK: Platform specfic imports
import Foundation
import SwiftUI


// Color for macOS and iOS
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public typealias HexColor = String

// Color <-> Hex Converter
extension Color {
    
    /// Initializes a Color from a hex string.
    ///
    /// The hex string can be in 6-character (RRGGBB) or 8-character (AARRGGBB) format. It uses the `hexColor` extension
    /// to validate and normalize the input string.
    ///
    /// - Parameter hex: A hex color string with or without a `#` prefix.
    init?(hexColor: String) {
        // Use the hexColor property to get the normalized hex string.
        guard let sanitizedHex = hexColor.hexColor else {
            return nil // Return nil if the hex string is invalid.
        }
        
        // Remove the `#` for further processing
        let hexSanitized = sanitizedHex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        let scanner = Scanner(string: hexSanitized)
        guard scanner.scanHexInt64(&rgb) else {
            return nil
        }
        
        let r, g, b, a: Double
        if hexSanitized.count == 6 {
            // RRGGBB (6 characters): No alpha channel, fully opaque.
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            a = 1.0  // Fully opaque
        } else if hexSanitized.count == 8 {
            // AARRGGBB (8 characters): Includes alpha channel.
            a = Double((rgb & 0xFF000000) >> 24) / 255.0
            r = Double((rgb & 0x00FF0000) >> 16) / 255.0
            g = Double((rgb & 0x0000FF00) >> 8) / 255.0
            b = Double(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        // Initialize the SwiftUI Color with the RGBA values
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    /// Convert hex value (e.g. 0xffc5d9) wiht/without alpha  to Color
    ///
    /// - [Stackoverflow : Use Hex color in SwiftUI](https://stackoverflow.com/a/56894458/808593)
    /// - [ChatGPT with alpha](https://chatgpt.com/share/9fd50287-1137-469f-97ff-99e7c37fe54e)
    ///
    /// Usage:      Color(hex: 0xffc5d9)
    ///         Color(hex: 0xffc5d9AA)
    ///
    public init(hex: UInt) {
        let hasAlpha = (hex >> 24) == 0
        
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
        
        if hasAlpha {
            red = Double((hex >> 16) & 0xff) / 255
            green = Double((hex >> 8) & 0xff) / 255
            blue = Double(hex & 0xff) / 255
            alpha = 1.0
        } else {
            red = Double((hex >> 24) & 0xff) / 255
            green = Double((hex >> 16) & 0xff) / 255
            blue = Double((hex >> 8) & 0xff) / 255
            alpha = Double(hex & 0xff) / 255
        }
        
        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
    
    public var intColor: UInt? {
        // Ensure the color is in the sRGB color space
        guard let cgColor = self.cgColor?.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil),
              let components = cgColor.components, components.count >= 4 else {
            return nil
        }
        let alpha = UInt(round(components[3] * 255))
        
        if alpha == 255 { //  opacity = 1.0 (default)
            let red = UInt(round(components[0] * 255)) << 16
            let green = UInt(round(components[1] * 255)) << 8
            let blue = UInt(round(components[2] * 255))
            return red | green | blue
        } else {
            let red = UInt(round(components[0] * 255)) << 24
            let green = UInt(round(components[1] * 255)) << 16
            let blue = UInt(round(components[2] * 255)) << 8
            let alpha = UInt(round(components[3] * 255))
            return red | green | blue | alpha
        }
    }
    
    /// Converts a SwiftUI `Color` to a hex string representation.
    ///
    /// - Returns: A hex string in `#RRGGBB` or `#AARRGGBB` format.
    public var hexColor: String {
        let platformColor = UIColor(self) // Or NSColor(self) for macOS
        
        guard let components = platformColor.cgColor.components else {
            fatalError("Cannot convert color to components")
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        let a = components.count >= 4 ? components[3] : 1.0
        
        // Convert to hex string format
        
        // Always include alpha in the hex string (AARRGGBB format)
        return String(format: "#%02X%02X%02X%02X",
                      Int(round(a * 255)),
                      Int(round(r * 255)),
                      Int(round(g * 255)),
                      Int(round(b * 255)))
        
    }
}

extension String {
    /// Returns a valid formatted HexColor in uppercase or nil if string cannot be converted to a hex color.
    ///
    /// - Returns: Uppercase 6 or 8 digit hex color with # prefix, or nil if invalid.
    var hexColor: String? {
        var hexSanitized = self.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        // Validating the length (3, 6, or 8 characters)
        let isValidLength = [3, 6, 8].contains(hexSanitized.count)
        guard isValidLength else { return nil }
        
        // Checking for valid hex characters only
        let validCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
        let invalidCharsRange = hexSanitized.rangeOfCharacter(from: validCharacters.inverted)
        guard invalidCharsRange == nil else { return nil }
        
        // Normalize 3-digit shorthand to 6-digit hex
        if hexSanitized.count == 3 {
            hexSanitized = hexSanitized.map { "\($0)\($0)" }.joined()
        }
        
        // Return in uppercase and with `#` prefix
        return "#" + hexSanitized.uppercased()
    }
    
    /// Checks if the hex string is a valid hex color (ignores the leading `#`).
    ///
    /// - Returns: `true` if valid hex color, otherwise `false`.
    func isValidHexColor() -> Bool {
        return self.hexColor != nil
    }
}

