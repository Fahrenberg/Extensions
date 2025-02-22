// --------------------------------------------------------------------------------------
// ---------------------- PlatformColor - UIColor or NSColor ----------------------------
// --------------------------------------------------------------------------------------

// Color for macOS and iOS
#if canImport(UIKit)
import UIKit
public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias PlatformColor = NSColor
#endif

