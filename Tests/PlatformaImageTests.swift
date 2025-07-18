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
        let symbolName = "document"
        let symbolImageResult = PlatformImage(systemName: symbolName)
        
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
