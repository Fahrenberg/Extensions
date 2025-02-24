//
//  WriteToTemp.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//
import Foundation
import OSLog

extension PlatformImage {
    /// Convencience function to write PlatformImage to temporary directory als PNG file
    ///
    /// Use URL to get file. Discardable when only log needed for testing.
    ///
    @discardableResult
    public func writeToDisk(filename: String) throws -> URL {
        let testDir = try PlatformImage.tempDirectory()
        let fileURL: URL
        // write image to disk for preview
        if #available(iOS 16.0, macOS 13.0, *)  {
            fileURL = testDir.appending(path: "\(filename)")
        } else {
            fileURL = testDir.appendingPathComponent("\(filename)")
        }
        guard let data = self.pngData() else {
            throw "Cannot save PlatformImage to URL:\n\(fileURL.absoluteString)"
        }
        try data.write(to: fileURL)
        Logger.extensions.info("Saved PlatformImage to URL:\n\(fileURL.absoluteString)")
        return fileURL
    }
    
    public static func tempDirectory() throws -> URL {
        let testDir: URL
        let subDirPath = Bundle.main.bundleIdentifier ?? "main"
        if #available(iOS 16.0, macOS 13.0, *) {
            testDir = FileManager().temporaryDirectory.appending(path: subDirPath)
        } else {
            testDir = FileManager().temporaryDirectory.appendingPathComponent(subDirPath)
        }
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        return testDir
    }
    
}
