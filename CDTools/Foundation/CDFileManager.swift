//
//  CDFileManager.swift
//   
//
//  Created by Christian Deckert on 08.07.14.
//  Copyright (c) 2016 Christian Deckert. All rights reserved.
//

import Foundation


public class CDFileManager {
    
    public class func getRootDirectory(subfolder: String?) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if var documentsDirectory = paths.first {
            if let sub = subfolder {
                documentsDirectory = documentsDirectory.nsString.stringByAppendingPathComponent(sub)
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }

            }
            return documentsDirectory
        } else {
            print("Unexpected path")
        }
        
        return ""
    }
    
    public class func getDocumentsDirectory(subfolder: String?) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if let documentsDirectory = paths.first {
            if let sub = subfolder {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(documentsDirectory.nsString.stringByAppendingPathComponent(sub), withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            return documentsDirectory
        } else {
            print("Unexpected path")
        }
        
        return ""
    }
    
    public class func getCachesDirectory(subfolder: String?) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if var theDir = paths.first {
            if let sub = subfolder {
                theDir = theDir.stringByAppendingPathComponent(sub)
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(theDir, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            return theDir
        } else {
            print("Unexpected path")
        }
        
        return ""
    }
    

    
    public class func pathForFile (fileName: String, optionalSubFolder subFolder: String?) -> String? {
        var ret: String?
        
        ret = CDFileManager.getRootDirectory(subFolder)
        if var dir = ret {
            dir = dir.stringByAppendingPathComponent(fileName)            
            ret = dir
        }
        
        return ret
    }
    
    public class func writeToFile(content: String, fileName name: String, optionalSubFolder subFolder: String?) -> Bool {
        
        var path = CDFileManager.getRootDirectory(subFolder)
        path = path.stringByAppendingPathComponent(name)
        
        
        let fileData = content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let fd = fileData {
            var success = true
            
            do {
                try fd.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                
            } catch let error as NSError {
                print(error.localizedDescription)
                success = false
            }
            
            
            return success
        }
        
        return false
    }
    
    public class func writeFileToPath(path: String, content: String) -> Bool {
        
        
        let fileData = content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let fd = fileData {
            var success = true
            do {
                try
                    fd.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                
            } catch let error as NSError {
                print(error.localizedDescription)
                success = false
            }
            
            return success
        }
        
        return false
    }
    
    public class func deleteFile(path: String) -> Bool {
        if nil == (try? NSFileManager.defaultManager().removeItemAtPath(path)) {
            return false
        }
        return true
    }
    
    public class func contentsOfDirectory(path: String, filter: [String]?) -> [String]? {
        
        if (path == "" || path.nsString.length == 0) {
            return nil
        }
        
        if let contents = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(path) {
            if let fileFilter = filter {
                var filteredContents = Array<String>()
                for f: String in contents {
                    
                    var addFile = false
                    for string in fileFilter {
                        if (f.rangeOfString(string, options: .CaseInsensitiveSearch) != nil) {
                            addFile = true
                            break;
                        }
                    }
                    
                    if addFile {
                        filteredContents.append(f)
                    }
                }
                
                return filteredContents
            } else {
                return contents
            }
        }
        
        return nil
    }
    
    public class func fileExists(path: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
}
