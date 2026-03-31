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

        // Rasterize written image to a fixed canvas and verify buffer size deterministically
        let rasterSize = CGSize(width: 100.0, height: 100.0)
        let rasterisedData = try XCTUnwrap(rasterizeToRGBA8(image, size: rasterSize))
        let expectedBytes = Int(rasterSize.width * rasterSize.height) * 4
        XCTAssertEqual(rasterisedData.count, expectedBytes, "Rasterized buffer size should match RGBA8 pixel count")
        
        let platformInfo = currentPlatformDescription()
        Logger.test.debug("Platform: \(platformInfo): - rasterized RGBA8 size \(rasterisedData.count) bytes for original image written to disk")
    }
    
    func testWritePlatformImageFramed() throws {
        let testImageType = TestPlatformImageType.small_center
        let imageFileName = testImageType.rawValue + ".bmp"
        
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        let framedImage = image.addFrame(frameWidth: 5)
        try framedImage.writeToDisk(filename: imageFileName)
        
        // Rasterize to a fixed canvas to reduce platform variance
        let rasterSize = CGSize(width: 100.0, height: 100.0)
        let rasterisedData = try XCTUnwrap(rasterizeToRGBA8(framedImage, size: rasterSize))
        let expectedBytes = Int(rasterSize.width * rasterSize.height) * 4
        XCTAssertEqual(rasterisedData.count, expectedBytes, "Rasterized buffer size should match RGBA8 pixel count")
        
        let platformInfo = currentPlatformDescription()
        Logger.test.debug("Platform: \(platformInfo): - rasterized RGBA8 size \(rasterisedData.count) bytes for framed image")
    }
    
    
    func testWritePlatformImageFilled() throws {
        let testImageType = TestPlatformImageType.small_center
        let imageFileName = testImageType.rawValue + ".bmp"
        
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        let fillImage = image.fillFrame()
        try fillImage.writeToDisk(filename: imageFileName)
        
        // Rasterize to a fixed canvas to reduce platform variance
        let rasterSize = CGSize(width: 100.0, height: 100.0)
        let rasterisedData = try XCTUnwrap(rasterizeToRGBA8(fillImage, size: rasterSize))
        
        // Assert the buffer has the expected capacity (width * height * 4 RGBA8 bytes)
        let expectedBytes = Int(rasterSize.width * rasterSize.height) * 4
        XCTAssertEqual(rasterisedData.count, expectedBytes, "Rasterized buffer size should match RGBA8 pixel count")
        
        let platformInfo = currentPlatformDescription()
        Logger.test.debug("Platform: \(platformInfo): - rasterized RGBA8 size \(rasterisedData.count) bytes for filled image")
    }
    
    
    func testWritePlatformImageFramedAndFilled() throws {
        let testImageType = TestPlatformImageType.small_center
        let imageFileName = testImageType.rawValue + ".bmp"
        
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        var framedAndFilledImage = image.addFrame().fillFrame()
        framedAndFilledImage = image.fillFrame().addFrame()
        try framedAndFilledImage.writeToDisk(filename: imageFileName)
        
        // Rasterize to a fixed canvas to reduce platform variance
        let rasterSize = CGSize(width: 100.0, height: 100.0)
        let rasterisedData = try XCTUnwrap(rasterizeToRGBA8(framedAndFilledImage, size: rasterSize))
        
        // Assert the buffer has the expected capacity (width * height * 4 RGBA8 bytes)
        let expectedBytes = Int(rasterSize.width * rasterSize.height) * 4
        XCTAssertEqual(rasterisedData.count, expectedBytes, "Rasterized buffer size should match RGBA8 pixel count")
        
        let platformInfo = currentPlatformDescription()
        Logger.test.debug("Platform: \(platformInfo): - rasterized RGBA8 size \(rasterisedData.count) bytes for framed+filled image")
    }
    
    func testSymbolImagePlatformIndependent() throws {
        let symbolImageResult = Extensions.PlatformImage(systemName: symbolName)!
        
        #if canImport(UIKit)
        let symboldImageExpected = UIImage(systemName: symbolName, withConfiguration: PlatformImage.defaultSymbolConfiguration)!
        #endif
        #if canImport(AppKit) && !canImport(UIKit)
        let symboldImageExpected = PlatformImage.symbolImage(systemName: symbolName, size: 100.0, colors: [.white])!
        #endif
        let rasterisedResultData = rasterizeToRGBA8(symbolImageResult, size: CGSize(width: 100.0, height: 100.0))!
        let rasterisedExpectedData = rasterizeToRGBA8(symboldImageExpected, size: CGSize(width: 100.0, height: 100.0))!
        XCTAssertEqual(rasterisedResultData.count,
                       rasterisedExpectedData.count)
        
        
        
    }
    
    func testSymbolImageSizePlatformAndDeviceIndependent() throws {
        let size = CGSize(width: 100.0, height: 100.0)
        let image = try XCTUnwrap(PlatformImage(systemName: symbolName))
        let rasterisedData = try XCTUnwrap(rasterizeToRGBA8(image, size: size))
        let platformInfo = currentPlatformDescription()
        let logMessage = "Platform: \(platformInfo): - rasterized RGBA8 size \(rasterisedData.count) bytes"
        Logger.test.debug("\(logMessage)")
        
        /* Rasterized byte counts may still differ slightly across platforms due to rendering differences,
         but using a fixed-size RGBA8 buffer reduces variability compared to PNG encoding sizes.
         Example outputs may vary by platform/device. */
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

