//
//  PlatformImage.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//

// PlatformImage: replace UIImage/NSImage for macOS and iOS
#if canImport(UIKit)
    import UIKit
    public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
    import AppKit
    public typealias PlatformImage = NSImage

    extension NSImage {
        func pngData() -> Data? {
            tiffRepresentation?.bitmap?.png
        }
    }

    extension NSBitmapImageRep {
        var png: Data? { representation(using: .png, properties: [:]) }
    }
    extension Data {
        var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
    }
#endif


extension PlatformImage {
    public var sizeDescription: String {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        return "w:\(width) x h:\(height)"
    }
}




//MARK: iOS specific code
#if canImport(UIKit)
extension PlatformImage {
    /// Default for symbols size and color on iOS and macOS
    ///
    /// Align same default size and color for macOS and iOS app
    ///
    /// Colors: white
    /// Font size: 100pt
    ///
    /// - Note: for iOS14 defaultSymbolConfiguration without color! Only with systemFont size = 100.0.
    public static var defaultSymbolConfiguration: UIImage.Configuration {
        if #available(iOS 15.0, *) {
            // iOS 15+ approach using UIImage.SymbolConfiguration
            var config = UIImage.SymbolConfiguration(paletteColors: [.white])
            
            // Apply a configuration that scales to the system font point size of 100
            config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 100.0)))
            
            return config
        } else {
            // Fallback for iOS 14, since UIImage.Configuration is unavailable in iOS 14 and 15
            // We can't use UIImage.Configuration, so return a default configuration for iOS 14
            // with only font size
            let symbolConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 100.0))

            // Return the configuration
            return symbolConfiguration
        }
    }


    
    /// Generates an UIImage for a given SF Symbol with specified size and colors.
    ///
    /// Use this init to ensure Platform independence
    public convenience init?(systemName: String,
                      size: CGFloat = 100.0,
                      colors: [UIColor] = [.white]) {
        var image: UIImage?

        if #available(iOS 15.0, *) {
            // Create a symbol configuration with the given colors and size for iOS 15+
            var config = UIImage.SymbolConfiguration(paletteColors: colors)
            config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: size)))
            
            // Attempt to create the image from the system symbol name with the configured settings
            image = UIImage(systemName: systemName, withConfiguration: config)
        } else {
            // Fallback for iOS 14
            // Create the image with default configuration
            image = UIImage(systemName: systemName)?.withTintColor(colors.first ?? .black, renderingMode: .alwaysOriginal)
        }

        guard let validImage = image else {
            return nil
        }

        // Resize the image to the requested size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let resizedImage = renderer.image { _ in
            validImage.draw(in: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        }

        // Initialize with the resized image
        self.init(cgImage: resizedImage.cgImage!)
    }
}
#endif


//MARK: macOS specific code
#if canImport(AppKit) && !canImport(UIKit)
extension PlatformImage {
    /// Generates an NSImage for a given SF Symbol with specified size and colors.
    public static func symbolImage(systemName: String,
                            size: CGFloat,
                            colors: [NSColor]) -> NSImage? {
        guard let image = NSImage(systemSymbolName: systemName, accessibilityDescription: nil) else {
            return nil
        }
        
        let resizedImage = NSImage(size: NSSize(width: size, height: size))
        resizedImage.lockFocus()
        
        // Apply colors using a gradient overlay
        let rect = NSRect(origin: .zero, size: resizedImage.size)
        let gradient = NSGradient(colors: colors) ?? NSGradient(colors: [.systemGray])!
        gradient.draw(in: rect, angle: 0)
        
        image.draw(in: rect, from: .zero, operation: .sourceAtop, fraction: 1.0)
        
        resizedImage.unlockFocus()
        return resizedImage
    }
    /// Convenience initializer to create an NSImage from a system symbol name with default size and colors.
    public convenience init?(systemName: String,
                      size: CGFloat = 100.0,
                      colors: [NSColor] = [.white]) {
        guard let symbolImage = NSImage.symbolImage(systemName: systemName, size: size, colors: colors) else {
            return nil
        }
        
        self.init(size: symbolImage.size)
        lockFocus()
        symbolImage.draw(in: NSRect(origin: .zero, size: symbolImage.size))
        unlockFocus()
    }
    
   
}

#endif
