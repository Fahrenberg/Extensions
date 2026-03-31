//
//  TestToolbox.swift
//  Extensions
//
//  Created by Jean-Nicolas on 31.03.2026.
//
import Foundation
import CoreGraphics

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@testable import Extensions

func rasterizeToRGBA8(_ image: PlatformImage, size: CGSize, scale: CGFloat = 1.0) -> Data? {
    let width = Int(size.width * scale)
    let height = Int(size.height * scale)
    guard width > 0, height > 0 else { return nil }

    let bytesPerPixel = 4
    let bytesPerRow = width * bytesPerPixel
    let bitsPerComponent = 8

    var rawData = Data(count: height * bytesPerRow)

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo =
        CGBitmapInfo.byteOrder32Big.union(
            CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        )

    let rendered = rawData.withUnsafeMutableBytes { buffer -> Bool in
        guard let baseAddress = buffer.baseAddress else { return false }

        guard let context = CGContext(
            data: baseAddress,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return false
        }

        context.clear(CGRect(x: 0, y: 0, width: width, height: height))
        context.interpolationQuality = .high

        #if canImport(UIKit)
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: scale, y: -scale)

        UIGraphicsPushContext(context)
        image.draw(in: CGRect(origin: .zero, size: size))
        UIGraphicsPopContext()

        context.restoreGState()

        #elseif canImport(AppKit)
        let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = graphicsContext

        NSColor.clear.setFill()
        NSBezierPath(rect: CGRect(origin: .zero, size: size)).fill()

        image.draw(
            in: CGRect(origin: .zero, size: size),
            from: .zero,
            operation: .sourceOver,
            fraction: 1.0
        )

        graphicsContext.flushGraphics()
        NSGraphicsContext.restoreGraphicsState()
        #endif

        return true
    }

    return rendered ? rawData : nil
}

