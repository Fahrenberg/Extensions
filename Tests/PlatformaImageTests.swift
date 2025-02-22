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
        
        let expectedImage =  try XCTUnwrap(TestPlatformImage.image(size: .small_center_framed))
#if canImport(UIKit)
        XCTAssertEqual(framedImage.pngData()?.count, 28664) // change test using [pixel hash](https://chatgpt.com/share/67ba33b0-0fb8-8008-b709-bcfba805557f)
#elseif canImport(AppKit)
        XCTAssertEqual(framedImage.pngData()?.count, expectedImage.pngData()?.count)
#endif
    }
}


enum TestPlatformImageType: String {
    case small, small_center, small_center_framed
}

struct TestPlatformImage {
    static func image(size type: TestPlatformImageType) -> PlatformImage? {
        let bundle = Bundle.module
        guard let imageURL = bundle.url(forResource: type.rawValue, withExtension: "bmp") else {
            return nil
        }
        #if canImport(UIKit)
        return UIImage(contentsOfFile: imageURL.path)
        #elseif canImport(AppKit)
        return NSImage(contentsOf: imageURL)
        #endif
    }
}
