//
//  CDFileManager.swift
//   
//
//  Created by Christian Deckert on 08.07.14.
//  Copyright (c) 2016 Christian Deckert. All rights reserved.
//

import Foundation


open class CDFileManager {
    
    open class func getRootDirectory(_ subfolder: String?) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if var documentsDirectory = paths.first {
            if let sub = subfolder {
                documentsDirectory = documentsDirectory.nsString.appendingPathComponent(sub)
                do {
                    try FileManager.default.createDirectory(atPath: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
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
    
    open class func getDocumentsDirectory(_ subfolder: String?) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documentsDirectory = paths.first {
            if let sub = subfolder {
                do {
                    try FileManager.default.createDirectory(atPath: documentsDirectory.nsString.appendingPathComponent(sub), withIntermediateDirectories: true, attributes: nil)
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
    
    open class func getCachesDirectory(_ subfolder: String?) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if var theDir = paths.first {
            if let sub = subfolder {
                theDir = theDir.stringByAppendingPathComponent(sub)
                do {
                    try FileManager.default.createDirectory(atPath: theDir, withIntermediateDirectories: true, attributes: nil)
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
    

    
    open class func pathForFile (_ fileName: String, optionalSubFolder subFolder: String?) -> String? {
        var ret: String?
        
        ret = CDFileManager.getRootDirectory(subFolder)
        if var dir = ret {
            dir = dir.stringByAppendingPathComponent(fileName)            
            ret = dir
        }
        
        return ret
    }
    
    open class func writeToFile(_ content: String, fileName name: String, optionalSubFolder subFolder: String?) -> Bool {
        
        var path = CDFileManager.getRootDirectory(subFolder)
        path = path.stringByAppendingPathComponent(name)
        
        
        let fileData = content.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let fd = fileData {
            var success = true
            
            do {
                try fd.write(to: URL(fileURLWithPath: path), options: NSData.WritingOptions.atomicWrite)
                
            } catch let error as NSError {
                print(error.localizedDescription)
                success = false
            }
            
            
            return success
        }
        
        return false
    }
    
    open class func writeFileToPath(_ path: String, content: String) -> Bool {
        
        
        let fileData = content.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let fd = fileData {
            var success = true
            do {
                try
                    fd.write(to: URL(fileURLWithPath: path), options: NSData.WritingOptions.atomicWrite)
                
            } catch let error as NSError {
                print(error.localizedDescription)
                success = false
            }
            
            return success
        }
        
        return false
    }
    
    open class func deleteFile(_ path: String) -> Bool {
        if nil == (try? FileManager.default.removeItem(atPath: path)) {
            return false
        }
        return true
    }
    
    open class func contentsOfDirectory(_ path: String, filter: [String]?) -> [String]? {
        
        if (path == "" || path.nsString.length == 0) {
            return nil
        }
        
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: path) {
            if let fileFilter = filter {
                var filteredContents = Array<String>()
                for f: String in contents {
                    
                    var addFile = false
                    for string in fileFilter {
                        if (f.range(of: string, options: .caseInsensitive) != nil) {
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
    
    open class func fileExists(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
