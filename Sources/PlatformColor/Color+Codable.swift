// --------------------------------------------------------------------------------------
// ---------------------- SwiftUI - Color - Coding Extensions ---------------------------
// --------------------------------------------------------------------------------------

// MARK: Platform specfic imports
import Foundation
import SwiftUI

@available(iOS 14.0, *)
@available(macOS 11.0, *)
extension Color {
     var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
#if os(macOS)
        PlatformColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        // Note that non RGB color will raise an exception, that I don't now how to catch because it is an Objc exception.
#else
        guard PlatformColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // Pay attention that the color should be convertible into RGB format
            // Colors using hue, saturation and brightness won't work
            return nil
        }
#endif
        
        return (r, g, b, a)
    }
}

@available(iOS 14.0, *)
@available(macOS 11.0, *)
public struct CodableColor: Codable, Hashable, Sendable {
    public var color: Color

    public init(_ color: Color) {
        self.color = color
    }

    enum CodingKeys: String, CodingKey { case red, green, blue, alpha }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        let a = try container.decodeIfPresent(Double.self, forKey: .alpha) ?? 1.0
        self.color = Color(red: r, green: g, blue: b, opacity: a)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let comps = color.colorComponents {
            try container.encode(Double(comps.red), forKey: .red)
            try container.encode(Double(comps.green), forKey: .green)
            try container.encode(Double(comps.blue), forKey: .blue)
            try container.encode(Double(comps.alpha), forKey: .alpha)
        } else {
            // Fallback: encode as opaque black if components are unavailable
            try container.encode(0.0, forKey: .red)
            try container.encode(0.0, forKey: .green)
            try container.encode(0.0, forKey: .blue)
            try container.encode(1.0, forKey: .alpha)
        }
    }
}
public extension Color {
    @available(iOS 14.0, *)
    @available(macOS 11.0, *)
    var codable: CodableColor { CodableColor(self) }
}

