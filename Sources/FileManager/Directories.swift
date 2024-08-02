// --------------------------------------------------------------------------------------
// -------------------------   Filemanager - Directories - Extensions -------------------------------
// --------------------------------------------------------------------------------------

import Foundation
import OSLog

extension FileManager {
    /// Checks if a file or folder at the given URL exists and if it is a directory or a file.
    /// - Parameter path: The path to check.
    /// - Returns: A tuple with the first ``Bool`` representing if the path exists and the second ``Bool`` representing if the found is a directory (`true`) or not (`false`).
    ///  See [https://stackoverflow.com/a/70759674/808593]
    static func fileExistsAndIsDirectory(atPath path: String) -> (fileExists: Bool, isDirectory: Bool) {
        var fileIsDirectory: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &fileIsDirectory)
        return (fileExists, fileIsDirectory.boolValue)
    }
    
    public static func directoryExists(directory: URL) ->  Bool {
        let (fileExist, fileIsDirectory) = FileManager.fileExistsAndIsDirectory(atPath: directory.path)
        return fileExist && fileIsDirectory
    }
    @available(*, deprecated, renamed: "documentDirectory")
    public static func localDocumentDirectory() -> URL {
        //        #if targetEnvironment(macCatalyst)
        //        let directory = URL(fileURLWithPath: NSHomeDirectory())
        //        #else
        let directory = FileManager.documentDirectory()
        //        #endif
        
        print("LocalStorageController ImagePickers FileManager localDocumentDirectory: ", directory.path )
        return directory
    }
    
    public static func documentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    public static func cloudDirectory() -> URL {
        guard let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            fatalError("Cannot get iCloud directory")
        }
        return driveURL
        
    }
    
    /// Creates directory if it doen't exits
    public static func createDirectory(directory: URL) {
         if directoryExists(directory: directory) { return }
         // create new directory
         do {
             try FileManager.default.createDirectory(atPath: directory.path,
                 withIntermediateDirectories: true, attributes: nil)
             Logger.fileManager.debug("FileManager-Extension - created directory: \(directory.path)")
             } catch {
                 Logger.fileManager.fault("FileManager-Extension - cannot create directory: \(directory.path)")
                 fatalError("FileManager-Extension - createdirectory: \(error.localizedDescription)")
             }
     }
    /// Delete all files in directoryURL and returns count of deleted files
    ///
    /// Default directory is documentDirectory()
    ///
    public static func deleteAllFiles(directoryURL: URL = FileManager.documentDirectory()) -> Int {
        let fm = FileManager()
        do {
            let files = try fm.contentsOfDirectory(at: directoryURL,
                                                   includingPropertiesForKeys: nil,
                                                   options: .skipsHiddenFiles)
         
            files.forEach {fileURL in try? fm.removeItem(at: fileURL) }
            return files.count

        } catch {
            // failed to read directory – bad permissions, perhaps?
            print(error.localizedDescription)
            return 0
        }
    }
    
    public static func countFiles(directoryURL: URL) -> Int {
        let fm = FileManager()
        do {
            let files = try fm.contentsOfDirectory(at: directoryURL,
                                                   includingPropertiesForKeys: nil,
                                                   options: .skipsHiddenFiles)
         
            return files.count

        } catch {
            // failed to read directory – bad permissions, perhaps?
            fatalError(error.localizedDescription)
        }
    }
    
    ///  Calculates byte size of all files in directoryURL
    ///
    ///  - Returns 0 if no files found.
    ///  - FatalError if directory not found!
    ///
    public static func directoryFileSize(directoryURL: URL) -> Int64 {
        let fm = FileManager()
        do {
            let files = try fm.contentsOfDirectory(at: directoryURL,
                                                   includingPropertiesForKeys: nil,
                                                   options: .skipsHiddenFiles)
         
            let filesSizes = files.map { url in
                if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
                    if let bytes = fileAttributes[.size] as? Int64 {
                     return bytes
                    }
                }
                return 0
            }
            return filesSizes.reduce(0, +)

        } catch {
            // failed to read directory – bad permissions, perhaps?
            fatalError(error.localizedDescription)
        }
    }
    
    /// Calculates byte size of file url
    ///
    /// Throws if file not found
    ///
    public static func fileSize(url: URL) throws -> Int64  {
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
        guard let bytes = fileAttributes[.size] as? Int64 else  { throw "fileSize: Cannot convert fileAttributes .size for \(url.absoluteString)  to Int64" }
        return bytes
    }
}

extension Logger {
    fileprivate static let fileManager = Logger(subsystem: subsystem, category: "Database")
}
