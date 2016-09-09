//
//  CDAppCache.swift
//  AdlerMannheimFanApp
//
//  Created by Christian Deckert on 06.07.16.
//  Copyright © 2016 Christian Deckert. All rights reserved.
//

import Foundation

// MARK: - CDAppCache: a simple singelton to cache and persist stuff 

public typealias WatchAppCacheObserverCallback = (object: AnyObject?, key: String) -> Void

let _appCacheInstance = CDAppCache()
public class CDAppCache {
    
    private var cache = Dictionary<String, AnyObject>()
    public var suitName: String? = nil {
        didSet {
            if let suitName = self.suitName {
                userDefaults = NSUserDefaults(suiteName: suitName)!
            } else {
                userDefaults = NSUserDefaults.standardUserDefaults()
            }
        }
    }
    
    public var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    public static func sharedCache() -> CDAppCache {
        return _appCacheInstance
    }
    
    public func clear() {
        _appCacheInstance.clear()
    }
    
    public func add(objectToCache object: AnyObject, forKey: String) -> Bool {
        cache[forKey] = object
        notifyObservers(forKey)
        return true
    }
    
    public func objectForKey(key: String) -> AnyObject? {
        return cache[key]
    }
    
    public func stringForKey(key: String) -> String? {
        return objectForKey(key) as? String
    }
    
    public func integerForKey(key: String) -> Int? {
        return objectForKey(key) as? Int
    }
    
    public func doubleForKey(key: String) -> Double? {
        return objectForKey(key) as? Double
    }
    
    public func dictionaryForKey(key: String) -> Dictionary<String, AnyObject>? {
        return objectForKey(key) as? Dictionary<String, AnyObject>
    }
    
    public func remove(key: String) {
        cache[key] = nil
        notifyObservers(key)
    }
    
    // MARK: - Oberserver
    private var observers = Array<_WatchAppCacheObserver>()
    
    // MARK: Private Helper Class _WatchAppCacheObserver
    private class _WatchAppCacheObserver: NSObject {
        weak var observer: NSObject?
        var keys = Array<String>()
        var callback: WatchAppCacheObserverCallback? = nil
        
        func isObservingKey(key: String) -> Bool {
            for k in keys {
                if key == k {
                    return true
                }
            }
            return false
        }
        
        init(observer: NSObject) {
            self.observer = observer
        }
    }
    
    public func addObserver(observer: NSObject, forKeys keys: Array<String>, callback: WatchAppCacheObserverCallback) {
        let (internalObserverIndex, internalObserver) = findObserver(observer)
        
        let newObserver: _WatchAppCacheObserver
        if let internalObserver = internalObserver {
            newObserver = internalObserver
        } else {
            newObserver = _WatchAppCacheObserver(observer: observer)
        }
        newObserver.keys.appendContentsOf(keys)
        newObserver.callback = callback
        
        if -1 == internalObserverIndex {
            self.observers.append(newObserver)
            self.notifyObserver(newObserver, keys: keys)
        }
    }
    
    public func removeObserver(observer: NSObject) -> Bool {
        
        let (internalObserverIndex, _) = findObserver(observer)
        
        if -1 != internalObserverIndex {
            self.observers.removeAtIndex(internalObserverIndex)
            return true
        }
        return false
    }
    
    private func findObserver(observer: NSObject) -> (Int, _WatchAppCacheObserver?) {
        
        for (index, o) in self.observers.enumerate() {
            if let obs = o.observer where obs == observer {
                return (index, o)
            }
        }
        return (-1, nil)
    }
    
    
    private func notifyObservers(key: String) {
        for internalObserver in self.observers {
            self.notifyObserver(internalObserver, key: key)
        }
    }
    
    private func notifyObserver(observer: _WatchAppCacheObserver, keys: [String]) {
        for key in keys {
            self.notifyObserver(observer, key: key)
        }
    }
    
    private func notifyObserver(observer: _WatchAppCacheObserver, key: String) {
        if observer.isObservingKey(key) {
            observer.callback?(object: self.objectForKey(key), key: key)
        }
    }
}


public extension CDAppCache {

    
    public func persistObject(objectToPersist object: AnyObject, forKey key: String) {
        userDefaults.setObject(object, forKey: key)
        userDefaults.synchronize()
    }
    
    public func persistImage(imageToPersist image: UIImage, forKey: String) {
        
        let persistBase64: NSData -> Void = { (imageData) in
            let base64image = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
            self.userDefaults.setObject(base64image, forKey: forKey)
            self.userDefaults.synchronize()
        }
        if let imageData = UIImagePNGRepresentation(image) {
            persistBase64(imageData)
        } else if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            persistBase64(imageData)
        }
    }
    
    public func unpersistImage(forKey: String) {
        self.removePersistedObject(forKey)
    }
    
    public func removePersistedObject(forKey: String) {
        userDefaults.removeObjectForKey(forKey)
        userDefaults.synchronize()
    }
    
    public func persistedObject(forKey: String) -> AnyObject? {
        return userDefaults.objectForKey(forKey)
    }
    
    public func persistedImage(forKey: String) -> UIImage? {
        
        if let base64string = persistedObject(forKey) as? String {
            if let imageData = NSData.init(base64EncodedString: base64string, options: NSDataBase64DecodingOptions()) {
                return UIImage(data: imageData)
            }
        }
        
        return nil
    }
    
    public func persistedInt(forKey: String) -> Int? {
        return persistedObject(forKey) as? Int
    }
    
}
