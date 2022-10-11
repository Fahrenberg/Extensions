// --------------------------------------------------------------------------------------
// -------------------------   Filemanager - Directories - Extensions -------------------------------
// --------------------------------------------------------------------------------------

import Foundation

extension FileManager {
    /// Checks if a file or folder at the given URL exists and if it is a directory or a file.
    /// - Parameter path: The path to check.
    /// - Returns: A tuple with the first ``Bool`` representing if the path exists and the second ``Bool`` representing if the found is a directory (`true`) or not (`false`).
  ///  See [https://stackoverflow.com/a/70759674/808593]
  public static func fileExistsAndIsDirectory(atPath path: String) -> (Bool, Bool) {
      var fileIsDirectory: ObjCBool = false
      let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &fileIsDirectory)
      return (fileExists, fileIsDirectory.boolValue)
    }
    
    
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
    
    
}
