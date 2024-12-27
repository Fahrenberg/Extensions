//
//  ByteCountFormatter.swift
//  Extensions
//
//  Created by Jean-Nicolas on 27.12.2024.
//
import Foundation

public extension Int64 {
     var outputKBytes: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useKB
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = false
        return formatter.string(fromByteCount: self)
    }
    
    var outputMBytes: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useMB
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = false
        return formatter.string(fromByteCount: self)
    }
    
}

public extension Int {
    var outputKBytes: String {
        let bytes = Int64(self)
        return bytes.outputKBytes
    }
    
    var outputMBytes: String {
        let bytes = Int64(self)
        return bytes.outputMBytes
    }
}

public extension UInt64 {
    var outputKBytes: String {
        let bytes = Int64(self)
        return bytes.outputKBytes
    }
    
    var outputMBytes: String {
        let bytes = Int64(self)
        return bytes.outputMBytes
    }
}
