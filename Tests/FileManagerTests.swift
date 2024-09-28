//
//  FileManager.swift
//  
//
//  Created by Jean-Nicolas on 12.10.22.
//

import XCTest
import OSLog

@testable import Extensions

final class FileManagerTests: XCTestCase {

    
    func testDocumentDirectory() throws {
        let localDocDir = FileManager.documentDirectory()
        
        XCTAssertTrue(localDocDir.isFileURL)
        XCTAssertTrue(localDocDir.hasDirectoryPath)

    }

    func testIsDirectory() {
        let fm = FileManager()
        let tmpDirectory = fm.temporaryDirectory
        XCTAssertFalse(FileManager.fileExists(file: tmpDirectory))
        XCTAssertTrue(FileManager.directoryExists(directory: tmpDirectory))
    }
    
    func testIsFile() {
        let fm = FileManager()
        let tmpFile = fm.temporaryDirectory.appendingPathComponent("empty.txt")
        Logger.test.info("\(tmpFile)")
        try? fm.removeItem(at: tmpFile)
        try? "testfile".write(to: tmpFile, atomically: true, encoding: .utf8)
        XCTAssertTrue(FileManager.fileExists(file: tmpFile))
        XCTAssertFalse(FileManager.directoryExists(directory: tmpFile))
    }
    
    func testNoFile() {
        let fm = FileManager()
        let tmpFile = fm.temporaryDirectory.appendingPathComponent("empty.txt")
        Logger.test.info("\(tmpFile)")
        try? fm.removeItem(at: tmpFile)
        XCTAssertFalse(FileManager.fileExists(file: tmpFile))
        XCTAssertFalse(FileManager.directoryExists(directory: tmpFile))
    }
  
    
    func testCreateValidDirectory() throws {
        let fm = FileManager()
        let newDirectory = fm.temporaryDirectory.appendingPathComponent("ValidTestDirectory")
        Logger.test.info("new directory: \(newDirectory.absoluteString)")
        XCTAssertNotNil(try? FileManager.createDirectory(at: newDirectory))
    }
    
    func testCreateInValidDirectory() throws {
        let newDirectory = URL(string: "file://io.d")!
        Logger.test.info("invalid directory: \(newDirectory.absoluteString)")
        XCTAssertNil(try? FileManager.createDirectory(at: newDirectory))
    }
    
    
    func testCreateDirectoryDepreciated() throws {
        let fm = FileManager()
        let newValidDirectory = fm.temporaryDirectory.appendingPathComponent("ValidTestDirectory")
        FileManager.createDirectory(directory: newValidDirectory)
        XCTAssertTrue(FileManager.directoryExists(directory: newValidDirectory))
        let newInvalidDirectory = URL(string: "file://io.d")!
        Logger.test.info("invalid directory: \(newInvalidDirectory.absoluteString)")
        throw XCTSkip("Crashing test for invalid directory.")
        FileManager.createDirectory(directory: newInvalidDirectory)
    }
}


extension Logger {
    fileprivate static let test = Logger(subsystem: subsystem, category: "FileManagerTests")
}

