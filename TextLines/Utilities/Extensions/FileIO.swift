//
//  FileIO.swift
//  FileIO
//
//  Created by Stuart Rankin on 7/18/21. Adapted from Flatland View.
//

import Foundation
import UIKit
import ImageIO

/// Class to help with file I/O operations.
class FileIO
{
    /// Initialize needed file structures and databases.
    /// - Warning: This function *must* be called prior to using external maps, the earthquake history database,
    ///            and World Heritage Sites. If any is used prior to calling this function, Flatland will be in
    ///            an undefined state.
    public static func Initialize()
    {
    }
    
    /// Return an array of non-hidden file objects in the passed directory.
    /// - Parameter Directory: The directory whose non-hidden items are returned.
    /// - Returns: Array of file item URLs.
    public static func FilesIn(Directory: URL) -> [URL]
    {
        var FileList = [URL]()
        do
        {
            let Items = try FileManager.default.contentsOfDirectory(at: Directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for Item in Items
            {
                FileList.append(Item)
            }
        }
        catch
        {
            Debug.Print("Error getting contents of \(Directory.path): \(error.localizedDescription)")
        }
        return FileList
    }
    
    /// Deletes the contents of the passed directory. Only non-hidden items are deleted.
    /// - Parameter Directory: The URL of the directory to clear.
    public static func DeleteContentsOf(Directory: URL)
    {
        let AllFiles = FilesIn(Directory: Directory)
        if AllFiles.isEmpty
        {
            return
        }
        do
        {
            for File in AllFiles
            {
                if FileManager.default.fileExists(atPath: File.path)
                {
                    try FileManager.default.removeItem(at: File)
                }
            }
        }
        catch
        {
            Debug.Print("Error deleting files: \(error.localizedDescription)")
        }
    }
    
    /// Add a list of sub-directories to the passed parent directory.
    /// - Parameter To: The parent directory URL.
    /// - Parameter SubDirectory: Array of sub-directory names.
    public static func AddSubDirectories(To Directory: URL, SubDirectory Names: [String])
    {
        for Name in Names
        {
            let NameDirectory = Directory.appendingPathComponent(Name)
            if !DirectoryExists(NameDirectory.path)
            {
                do
                {
                    try FileManager.default.createDirectory(atPath: NameDirectory.path, withIntermediateDirectories: true,
                                                            attributes: nil)
                }
                catch
                {
                    Debug.Print("Error creating \(NameDirectory.path): \(error.localizedDescription)")
                }
            }
        }
    }
    
    public static func ImageFromFile(WithName: String) -> UIImage?
    {
        let Image = UIImage(named: WithName, in: Bundle(for: self), compatibleWith: nil)
        return Image
        /*
        if let DocDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        {
            let Image = UIImage(named: WithName, in: Bundle(for: self), compatibleWith: nil)
            //let Image = UIImage(contentsOf: DocDir.appendingPathComponent(WithName))
            return Image
        }
        return nil
           */
    }
    
    public static func ResourceFileList() -> [String]
    {
        var FileList = [String]()
        do
        {
            FileList = try FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath)
            return FileList
        }
        catch
        {
            print("ResourceFileList error: \(error)")
            return []
        }
    }
    
    /// Determines if the passed file exists.
    /// - Parameter FinalURL: The URL of the file.
    /// - Returns: True if the file exists, false if not.
    public static func FileExists(_ FinalURL: URL) -> Bool
    {
        return FileManager.default.fileExists(atPath: FinalURL.path)
    }
    
    /// Determines if a given directory exists.
    /// - Parameter DirectoryName: The name of the directory to check for existence.
    /// - Returns: True if the directory exists, false if not.
    public static func DirectoryExists(_ DirectoryName: String) -> Bool
    {
        let CPath = GetDocumentDirectory()?.appendingPathComponent(DirectoryName)
        if CPath == nil
        {
            return false
        }
        return FileManager.default.fileExists(atPath: CPath!.path)
    }
    
    /// Create a directory in the document directory.
    /// - Parameter DirectoryName: Name of the directory to create.
    /// - Returns: URL of the newly created directory on success, nil on error.
    @discardableResult public static func CreateDirectory(DirectoryName: String) -> URL?
    {
        var CPath: URL!
        do
        {
            CPath = GetDocumentDirectory()?.appendingPathComponent(DirectoryName)
            try FileManager.default.createDirectory(atPath: CPath!.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch
        {
            return nil
        }
        return CPath
    }
    
    /// Returns the URL of the passed directory. The directory is assumed to be a sub-directory of the
    /// document directory.
    /// - Parameter DirectoryName: Name of the directory whose URL is returned.
    /// - Returns: URL of the directory on success, nil if not found.
    public static func GetDirectoryURL(DirectoryName: String) -> URL?
    {
        if !DirectoryExists(DirectoryName)
        {
            return nil
        }
        let CPath = GetDocumentDirectory()?.appendingPathComponent(DirectoryName)
        return CPath
    }
    
    /// Returns BlockCam's document directory.
    /// - Returns: The URL of the app's document directory.
    public static func GetDocumentDirectory() -> URL?
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    /// Delete the specified file.
    /// - Parameter FileURL: The URL of the file to delete.
    public static func DeleteFile(_ FileURL: URL)
    {
        do
        {
            try FileManager.default.removeItem(at: FileURL)
        }
        catch
        {
            return
        }
    }
    
    /// Delete the specified file. If the file does not exist, return without any errors being issued.
    /// - Parameter FileURL: The URL of the file to delete.
    public static func DeleteIfPresent(_ FileURL: URL)
    {
        if FileManager.default.fileExists(atPath: FileURL.path)
        {
            DeleteFile(FileURL)
        }
    }
    
    /// Loads an image from the file system. This is not intended for images from the photo album (and probably
    /// wouldn't work) but for images in our local directory tree.
    /// - Parameter Name: The name of the image to load.
    /// - Parameter InDirectory: Name of the directory where the file resides.
    /// - Returns: The image if found, nil if not found.
    public static func LoadImage(_ Name: String, InDirectory: String) -> UIImage?
    {
        if !DirectoryExists(InDirectory)
        {
            return nil
        }
        let DirURL = GetDirectoryURL(DirectoryName: InDirectory)
        return UIImage(contentsOfFile: (DirURL?.appendingPathComponent(Name).path)!)
    }
    
    /// Returns a listing of the contents of the specified directory.
    /// - Parameter Directory: The directory whose contents will be returned.
    /// - Returns: Array of strings representing the contents of the specified directory on success, nil on error.
    public static func ContentsOfDirectory(_ Directory: String) -> [String]?
    {
        do
        {
            let Results = try FileManager.default.contentsOfDirectory(atPath: Directory)
            return Results
        }
        catch
        {
            return nil
        }
    }
}
