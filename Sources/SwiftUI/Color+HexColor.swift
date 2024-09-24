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
    
    /// HexColor: "#RGBA"  or "#RGB" as string with hex values.
    ///
    /// [From Hex to Color and Back in SwiftUI](https://blog.eidinger.info/from-hex-to-color-and-back-in-swiftui)
    public init?(hexColor: HexColor) {
        var hexSanitized = hexColor.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    
    
    /// Convert Color to HexColor (String)  using RGBA.
    public var hexColor: HexColor {
      
        let platformColor = PlatformColor(self)
      
        guard let components = platformColor.cgColor.components, components.count >= 3 else {
            fatalError("\(String(describing: platformColor))  cannot be split into RGB(A) components")
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}


