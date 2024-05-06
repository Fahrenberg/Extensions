//
//  FileManager.swift
//  
//
//  Created by Jean-Nicolas on 12.10.22.
//

import XCTest
@testable import Extensions

final class FileManagerTests: XCTestCase {

    
    func testDocumentDirectory() throws {
        let localDocDir = FileManager.documentDirectory()
        
        XCTAssertTrue(localDocDir.isFileURL)
        XCTAssertTrue(localDocDir.hasDirectoryPath)

    }

  
    
}
