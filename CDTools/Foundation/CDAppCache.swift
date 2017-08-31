//
//  CDAppCache.swift
//  CDTools
//
//  Created by Christian Deckert on 06.07.16.
//  Copyright © 2016 Christian Deckert. All rights reserved.
//

import Foundation

// MARK: - CDAppCache: a simple singelton to cache and persist stuff 

public typealias WatchAppCacheObserverCallback = (_ object: AnyObject?, _ key: String) -> Void

let _appCacheInstance = CDAppCache()
open class CDAppCache {
    
    fileprivate var cache = Dictionary<String, AnyObject>()
    open var suitName: String? = nil {
        didSet {
            if let suitName = self.suitName {
                userDefaults = UserDefaults(suiteName: suitName)!
            } else {
                userDefaults = UserDefaults.standard
            }
        }
    }
    
    open var userDefaults: UserDefaults = UserDefaults.standard
    
    open static func sharedCache() -> CDAppCache {
        return _appCacheInstance
    }
    
    open func clear() {
        _appCacheInstance.clear()
    }
    
    open func add(objectToCache object: AnyObject, forKey: String) -> Bool {
        cache[forKey] = object
        notifyObservers(forKey)
        return true
    }
    
    open func objectForKey(_ key: String) -> AnyObject? {
        return cache[key]
    }
    
    open func stringForKey(_ key: String) -> String? {
        return objectForKey(key) as? String
    }
    
    open func integerForKey(_ key: String) -> Int? {
        return objectForKey(key) as? Int
    }
    
    open func doubleForKey(_ key: String) -> Double? {
        return objectForKey(key) as? Double
    }
    
    open func dictionaryForKey(_ key: String) -> Dictionary<String, AnyObject>? {
        return objectForKey(key) as? Dictionary<String, AnyObject>
    }
    
    open func remove(_ key: String) {
        cache[key] = nil
        notifyObservers(key)
    }
    
    // MARK: - Oberserver
    fileprivate var observers = Array<_WatchAppCacheObserver>()
    
    // MARK: Private Helper Class _WatchAppCacheObserver
    fileprivate class _WatchAppCacheObserver: NSObject {
        weak var observer: NSObject?
        var keys = Array<String>()
        var callback: WatchAppCacheObserverCallback? = nil
        
        func isObservingKey(_ key: String) -> Bool {
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
    
    open func addObserver(_ observer: NSObject, forKeys keys: Array<String>, callback: @escaping WatchAppCacheObserverCallback) {
        let (internalObserverIndex, internalObserver) = findObserver(observer)
        
        let newObserver: _WatchAppCacheObserver
        if let internalObserver = internalObserver {
            newObserver = internalObserver
        } else {
            newObserver = _WatchAppCacheObserver(observer: observer)
        }
        newObserver.keys.append(contentsOf: keys)
        newObserver.callback = callback
        
        if -1 == internalObserverIndex {
            self.observers.append(newObserver)
            self.notifyObserver(newObserver, keys: keys)
        }
    }
    
    open func removeObserver(_ observer: NSObject) -> Bool {
        
        let (internalObserverIndex, _) = findObserver(observer)
        
        if -1 != internalObserverIndex {
            self.observers.remove(at: internalObserverIndex)
            return true
        }
        return false
    }
    
    fileprivate func findObserver(_ observer: NSObject) -> (Int, _WatchAppCacheObserver?) {
        
        for (index, o) in self.observers.enumerated() {
            if let obs = o.observer, obs == observer {
                return (index, o)
            }
        }
        return (-1, nil)
    }
    
    
    fileprivate func notifyObservers(_ key: String) {
        for internalObserver in self.observers {
            self.notifyObserver(internalObserver, key: key)
        }
    }
    
    fileprivate func notifyObserver(_ observer: _WatchAppCacheObserver, keys: [String]) {
        for key in keys {
            self.notifyObserver(observer, key: key)
        }
    }
    
    fileprivate func notifyObserver(_ observer: _WatchAppCacheObserver, key: String) {
        if observer.isObservingKey(key) {
            observer.callback?(self.objectForKey(key), key)
        }
    }
}


public extension CDAppCache {

    
    public func persistObject(objectToPersist object: AnyObject, forKey key: String) {
        userDefaults.set(object, forKey: key)
        userDefaults.synchronize()
    }
    
    public func persistImage(imageToPersist image: UIImage, forKey: String) {
        
        let persistBase64: (Data) -> Void = { (imageData) in
            let base64image = imageData.base64EncodedString(options: NSData.Base64EncodingOptions())
            self.userDefaults.set(base64image, forKey: forKey)
            self.userDefaults.synchronize()
        }
        if let imageData = UIImagePNGRepresentation(image) {
            persistBase64(imageData)
        } else if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            persistBase64(imageData)
        }
    }
    
    public func unpersistImage(_ forKey: String) {
        self.removePersistedObject(forKey)
    }
    
    public func removePersistedObject(_ forKey: String) {
        userDefaults.removeObject(forKey: forKey)
        userDefaults.synchronize()
    }
    
    public func persistedObject(_ forKey: String) -> AnyObject? {
        return userDefaults.object(forKey: forKey) as AnyObject
    }
    
    public func persistedImage(_ forKey: String) -> UIImage? {
        
        if let base64string = persistedObject(forKey) as? String {
            if let imageData = Data.init(base64Encoded: base64string, options: NSData.Base64DecodingOptions()) {
                return UIImage(data: imageData)
            }
        }
        
        return nil
    }
    
    public func persistedInt(_ forKey: String) -> Int? {
        return persistedObject(forKey) as? Int
    }
    
}
