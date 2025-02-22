//
//  WriteToTemp.swift
//  Extensions
//
//  Created by Jean-Nicolas on 22.02.2025.
//
import Foundation
import OSLog

extension PlatformImage {
    func writeToDisk(filename: String) throws {
        let testDir: URL
        let fileURL: URL
        // write image to disk for preview
        let subDirPath = Bundle.main.bundleIdentifier ?? "main"
        if #available(iOS 16.0, *) {
            testDir = FileManager().temporaryDirectory.appending(path: subDirPath)
            fileURL = testDir.appending(path: "\(filename)")
        } else {
            testDir = FileManager().temporaryDirectory.appendingPathComponent(subDirPath)
            fileURL = testDir.appendingPathComponent("\(filename)")
        }
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        guard let data = self.pngData() else {
            throw "Cannot save image to URL:\n\(fileURL.absoluteString)"
        }
        try data.write(to: fileURL)
        Logger.extensions.info("Saved Image to URL:\n\(fileURL.absoluteString)")
    }
    
}
