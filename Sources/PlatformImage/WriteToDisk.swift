//
//  WriteToTemp.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//
import Foundation
import OSLog

extension PlatformImage {
    /// Writes PlatformImage to temporary directory als PNG file
    @discardableResult
    public func writeToDisk(filename: String) throws -> URL {
        let testDir = try self.tempDirectory()
        let fileURL: URL
        // write image to disk for preview
        if #available(iOS 16.0, *) {
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
    
    func tempDirectory() throws -> URL {
        let testDir: URL
        let subDirPath = Bundle.main.bundleIdentifier ?? "main"
        if #available(iOS 16.0, *) {
            testDir = FileManager().temporaryDirectory.appending(path: subDirPath)
        } else {
            testDir = FileManager().temporaryDirectory.appendingPathComponent(subDirPath)
        }
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        return testDir
    }
    
}
