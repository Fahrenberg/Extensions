//
//  PlatformImage.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//

// PlatformImage for macOS and iOS
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
