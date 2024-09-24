// --------------------------------------------------------------------------------------
// ---------------------- SwiftUI - Color - Codng Extensions ----------------------------
// --------------------------------------------------------------------------------------

// MARK: Platform specfic imports
import Foundation
import SwiftUI


// Color for macOS and iOS
#if canImport(UIKit)
import UIKit
public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias PlatformColor = NSColor
#endif



// MARK: -----------------------------------------------------------------------

// http://brunowernimont.me/howtos/make-swiftui-color-codable
// added availability
@available(iOS 14.0, *)
@available(macOS 11.0, *)
extension Color: Codable {
    fileprivate var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
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
    
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        
        self.init(red: r, green: g, blue: b)
    }
    
    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}

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

