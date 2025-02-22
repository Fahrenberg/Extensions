//
//  FramedPlatformImage.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//

import Foundation
import OSLog



// Color for macOS and iOS
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension PlatformImage {
    /// Adds a frame aroind the PlatformImage
    ///
    /// New Image ist frameWidth x 2 (default 4 points) larger and higher than original image.
    ///
    public func addFrame(frameWidth: CGFloat = 2.0,
                         frameColor: PlatformColor = .red)  -> PlatformImage {
        let imageSize = self.size
        let frameSize = CGSize(width: imageSize.width + frameWidth * 2, height: imageSize.height + frameWidth * 2)
        
#if canImport(UIKit)
        // iOS or iPadOS specific code
        UIGraphicsBeginImageContextWithOptions(frameSize, false, self.scale)
        frameColor.setStroke()
        let frameRect = CGRect(origin: .zero, size: frameSize)
        
        // Draw the border (outline) instead of filling the rectangle
        let path = UIBezierPath(rect: frameRect)
        path.lineWidth = frameWidth
        path.stroke()
        
        let imageRect = CGRect(x: frameWidth, y: frameWidth, width: imageSize.width, height: imageSize.height)
        self.draw(in: imageRect)
        let imageWithFrame = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
#elseif canImport(AppKit)
        // macOS specific code
        
        // Try to extract bitmap representation from the image
        var bitmapRep: NSBitmapImageRep? = nil
        for representation in self.representations {
            if let rep = representation as? NSBitmapImageRep {
                bitmapRep = rep
                break
            }
        }
        
        // Ensure we have a valid bitmap representation
        guard let validBitmapRep = bitmapRep else {
            fatalError("Failed to find bitmap representation for NSImage.")
        }
        
        // Now safely obtain a CGImage from the bitmap representation
        guard let cgImage = validBitmapRep.cgImage else {
            fatalError("Failed to get CGImage from bitmap representation.")
        }
        
        // Create a new NSImage to draw the frame into
        let imageWithFrame = NSImage(size: frameSize)
        
        // Lock focus to set up a valid graphics context
        imageWithFrame.lockFocus()
        
        // Use the current context to draw the frame (outline/border)
        let context = NSGraphicsContext.current!.cgContext
        context.setStrokeColor(frameColor.cgColor)
        context.setLineWidth(frameWidth)
        
        // Draw only the border (outline) using a path
        let frameRect = CGRect(origin: .zero, size: frameSize)
        context.stroke(frameRect)
        
        let imageRect = CGRect(x: frameWidth, y: frameWidth, width: imageSize.width, height: imageSize.height)
        context.draw(cgImage, in: imageRect)
        
        // Unlock focus to finalize the drawing
        imageWithFrame.unlockFocus()
        
#else
        fatalError("Unsupported platform")
#endif
        
        return imageWithFrame
    }
    
}
