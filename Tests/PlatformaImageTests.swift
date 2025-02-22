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
    func testWritePlatformImageToTempDisk() throws {
        let testImageType = TestPlatformImageType.small
        let imageFileName = testImageType.rawValue + ".bmp"
        let image = try XCTUnwrap(TestPlatformImage.image(size: testImageType))
        let tmpDir = try image.tempDirectory()
        FileManager.deleteAllFiles(directoryURL: tmpDir)
        let url = try image.writeToDisk(filename: imageFileName)
        XCTAssertTrue(FileManager.fileExists(file: url))
        let imageSize = try XCTUnwrap(image.pngData())
        let resultImageData = try Data(contentsOf: url)
        XCTAssertEqual(resultImageData.count, imageSize.count)
    }
}


enum TestPlatformImageType: String {
    case small, small_center
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
