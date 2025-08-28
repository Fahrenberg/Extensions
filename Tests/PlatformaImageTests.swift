//
//  PlatformaImageTests.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//


import XCTest
@testable import Extensions

import SwiftUI
import OSLog

// Testing PlatformColor Extensions
final class PlatformImageTests: XCTestCase {
    
    let symbolName = "square.and.arrow.up" // available from version 1.0
    
    override func setUpWithError() throws {
        let tmpDir = try PlatformImage.tempDirectory()
        FileManager.deleteAllFiles(directoryURL: tmpDir)  // reset
    }
    
    func testWritePlatformImageToTempDisk() throws {
        let testImageType = TestPlatformImageType.small_center
        let imageFileName = testImageType.rawValue + ".bmp"
        
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        
        let url = try image.writeToDisk(filename: imageFileName)
        XCTAssertTrue(FileManager.fileExists(file: url))

        let imageSize = try XCTUnwrap(image.pngData())
        let resultImageData = try Data(contentsOf: url)
        XCTAssertEqual(resultImageData.count, imageSize.count)
    }
    
    func testWritePlatformImageFramed() throws {
        let testImageType = TestPlatformImageType.small_center
        let imageFileName = testImageType.rawValue + ".bmp"
        
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        let framedImage = image.addFrame(frameWidth: 5)
        try framedImage.writeToDisk(filename: imageFileName)
        
#if canImport(UIKit)
        XCTAssertEqual(framedImage.pngData()?.count, 28664) // change test using [pixel hash](https://chatgpt.com/share/67ba33b0-0fb8-8008-b709-bcfba805557f)
#elseif canImport(AppKit)
        XCTAssertEqual(framedImage.pngData()?.count, 55981)
#endif
    }
    
    
    func testWritePlatformImageFilled() throws {
        let testImageType = TestPlatformImageType.small_center
        let imageFileName = testImageType.rawValue + ".bmp"
        
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        let fillImage = image.fillFrame()
        try fillImage.writeToDisk(filename: imageFileName)
        
//        let expectedImage =  try XCTUnwrap(TestPlatformImage.image(size: .small_center_filled))
#if canImport(UIKit)
    #if targetEnvironment(macCatalyst)
        XCTAssertEqual(fillImage.pngData()?.count, 253442) // Adjusted for Mac Catalyst
    #else
        XCTAssertEqual(fillImage.pngData()?.count, 478114) // Adjusted for iOS
    #endif
#elseif canImport(AppKit)
    XCTAssertEqual(fillImage.pngData()?.count, 54969) // Adjusted for macOS
#endif

    }
    
    
    func testWritePlatformImageFramedAndFilled() throws {
        let testImageType = TestPlatformImageType.small_center
        let imageFileName = testImageType.rawValue + ".bmp"
        
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        var framedAndFilledImage = image.addFrame().fillFrame()
        framedAndFilledImage = image.fillFrame().addFrame()
        try framedAndFilledImage.writeToDisk(filename: imageFileName)
        
//        let expectedImage =  try XCTUnwrap(TestPlatformImage.image(size: .small_center_filled))
#if canImport(UIKit)
    #if targetEnvironment(macCatalyst)
        XCTAssertEqual(framedAndFilledImage.pngData()?.count, 106061) // Adjusted for Mac Catalyst
    #else
        XCTAssertEqual(framedAndFilledImage.pngData()?.count, 222687) // Adjusted for iOS
    #endif
#elseif canImport(AppKit)
    XCTAssertEqual(framedAndFilledImage.pngData()?.count, 55545) // Adjusted for macOS
#endif

    }
    
    func testSymbolImagePlatformIndependent() throws {
        let symbolImageResult = Extensions.PlatformImage(systemName: symbolName)
        
        #if canImport(UIKit)
        let symboldImageExpected = UIImage(systemName: symbolName, withConfiguration: PlatformImage.defaultSymbolConfiguration)
            #if targetEnvironment(macCatalyst)
            XCTAssertEqual(symbolImageResult?.pngData()?.count,
                           4046)
            #else
            XCTAssertEqual(symbolImageResult?.pngData()?.count,
                       symboldImageExpected?.pngData()?.count)
            #endif
        #endif
        
        #if canImport(AppKit) && !canImport(UIKit)
        let symboldImageExpected = PlatformImage.symbolImage(systemName: symbolName, size: 100.0, colors: [.white])
        
        XCTAssertEqual(symbolImageResult?.pngData()?.count,
                       symboldImageExpected?.pngData()?.count)
        
        #endif
        
        
    }
    
    func testSymbolImageSizePlatformAndDeviceIndependent() throws {
        let symbolSize =  try XCTUnwrap(PlatformImage(systemName: symbolName)?.pngData())
        let platformInfo = currentPlatformDescription()
        let logMessage = "Platform: \(platformInfo): - size \(symbolSize)"
        Logger.test.debug("\(logMessage)")
        
        /* will never produce same data size  for all platforms, devices
         Platform: iOS (iPhone 16 Pro Simulator (iOS 18.6)): - size 4332 bytes
         Platform: iOS (iPhone 15 Pro Max Simulator (iOS 17.5)): - size 4371 bytes
         Platform: macOS (Device): - size 23343 bytes
         
         */
    }
    
    
}

/// Returns a formatted string describing the current platform and environment (simulator or device)
func currentPlatformDescription() -> String {
    #if os(iOS)
    let platform = "iOS"
    #elseif os(macOS)
    let platform = "macOS"
    #else
    let platform = "Unknown"
    #endif
    
    let environment: String
    #if targetEnvironment(simulator)
    #if os(iOS)
    let deviceName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? "Unknown iPhone"
    let systemVersion = UIDevice.current.systemVersion
    environment = "\(deviceName) Simulator (iOS \(systemVersion))"
    #else
    environment = "Simulator"
    #endif
    #else
    environment = "Device"
    #endif
    
    return "\(platform) (\(environment))"
}


enum TestPlatformImageType: String {
    case small, small_center, small_center_framed, small_center_filled
}

struct TestPlatformImage {
    static func image(size type: TestPlatformImageType) -> PlatformImage? {
        let bundle = Bundle.module
        guard let imageURL = bundle.url(forResource: type.rawValue, withExtension: "bmp") else {
            return nil
        }
        #if canImport(UIKit)
        return PlatformImage(contentsOfFile: imageURL.path)
        #elseif canImport(AppKit)
        return NSImage(contentsOf: imageURL)
        #endif
    }
}



extension Logger {
    fileprivate static let test = Logger(subsystem: subsystem, category: "PlatformImageTests")
}
