//
//  CDDispatch.swift
//  QualiFood
//
//  Created by Christian Deckert on 28.06.16.
//  Copyright © 2016 Christian Deckert. All rights reserved.
//

import Foundation

public enum CDDispatchQueue {
    case PriorityMainThread
    case PriorityHigh
    case PriorityDefault
    case PriorityLow
    case PriorityBackground

}

public class BackgroundDispatchQueue: DispatchQueue {
    
    public init(preferredDelay delay: Double = 0) {
        super.init(preferredQueue: .PriorityBackground, preferredDelay: delay)
    }
}

public class DefaultDispatchQueue: DispatchQueue {
    
    public init(preferredDelay delay: Double = 0) {
        super.init(preferredQueue: .PriorityDefault, preferredDelay: delay)
    }
}

public class MainDispatchQueue: DispatchQueue {
    
    public init(preferredDelay delay: Double = 0) {
        super.init(preferredQueue: .PriorityMainThread, preferredDelay: delay)
    }
}

public class DispatchResult: NSObject {
    
    weak var dispatchQueue: DispatchQueue?
    private var thenBlock: ((successful: Bool) -> Void)? = nil
    
    deinit {
        self.dispatchQueue = nil
    }
    
    public init(queue: DispatchQueue) {
        self.dispatchQueue = queue
        super.init()
    }
    
    public func then(completionBlock: (successful: Bool) -> Void) {
        self.thenBlock = completionBlock
    }
}

public class DispatchQueue: NSObject {
    
    static var results: [DispatchResult] = [DispatchResult]()
    private var q: dispatch_queue_t?
    private var preferredDelay: Double? = 0
    private var preferredQueue: CDDispatchQueue?
    
    deinit {    
    }
    
    public init(preferredQueue queue: CDDispatchQueue? = .PriorityMainThread, preferredDelay: Double? = 0) {
        self.preferredQueue = queue
        self.preferredDelay = preferredDelay
    }
    
    public func dispatch(block dispatchBlock: dispatch_block_t) -> DispatchResult {
        let result = DispatchResult(queue: self)
        DispatchQueue.results.append(result)
        self.dispatch(block: dispatchBlock, delay: self.preferredDelay ?? 0, completion: { [weak result] (successful) in
            result?.thenBlock?(successful: successful)
            for (index, r) in DispatchQueue.results.enumerate() {
                if result == r {
                    DispatchQueue.results.removeAtIndex(index)
                }
            }
            
        })
        return result
    }
    
    public func dispatch(block dispatchBlock: dispatch_block_t, delay: Double? = 0, completion: ((successful: Bool) -> Void)? = nil) {
        guard let preferredQueue = self.preferredQueue else {
            completion?(successful: false)
            return
        }
        
        if nil == self.q {
            switch preferredQueue {
            case .PriorityDefault:
                self.q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            case .PriorityHigh:
                self.q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
            case .PriorityLow:
                self.q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
            case .PriorityBackground:
                self.q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
            default:
                self.q = dispatch_get_main_queue()
            }
        }
        
        guard let q = self.q else {
            completion?(successful: false)
            return
        }
        
        var finalDelay: Double = 0
        if let delay = delay {
            finalDelay = delay
        } else if let preferredDelay = self.preferredDelay {
            finalDelay = preferredDelay
        }
        
        CDDispatch.dispatchOnQueue(queue: q, dispatchBlock: dispatchBlock, delay: finalDelay) {
            completion?(successful: true)
        }
    }
    
}

public class CDDispatch {
    
    /// Dispatch closure after given delay on main thread
    public class func onMainQueueAfter(delay: Double, block dispatchBlock: dispatch_block_t, completion: (Void -> Void)? = nil) {
        CDDispatch.dispatchOnQueue(queue: dispatch_get_main_queue(), dispatchBlock: dispatchBlock, delay: delay)
    }
    
    /// Dispatch closure after given delay on background thread
    public class func onBackgroundQueueAfter(delay: Double, block dispatchBlock: dispatch_block_t, completion: (Void -> Void)? = nil) {
        CDDispatch.dispatchOnQueue(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), dispatchBlock: dispatchBlock, delay: delay)
    }
    
    public class func dispatchOnQueue(queue q: dispatch_queue_t, dispatchBlock: dispatch_block_t, delay: Double, completion: (Void -> Void)? = nil) {
        let d = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        dispatch_after(time, q, dispatchBlock)
        
        if let completion = completion {
            CDDispatch.dispatchOnQueue(queue: dispatch_get_main_queue(), dispatchBlock: completion, delay: delay + 0.01)
        }
    }
    
    public class func newDispatchTimer(interval: Double, queue: dispatch_queue_t,  repeats: Bool, block: dispatch_block_t?) -> dispatch_source_t? {
        
        let fireAfter = UInt64(interval * Double(NSEC_PER_SEC))
        
        var repeatAfter = UInt64(DISPATCH_TIME_FOREVER) // one-shot timer
        if repeats {
            repeatAfter = fireAfter
        }
        
        let d = interval * Double(NSEC_PER_SEC)
        _ = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(fireAfter))
        dispatch_source_set_timer(timer, dispatchTime, repeatAfter, NSEC_PER_SEC)
        if let block = block {
            dispatch_source_set_event_handler(timer, block)
        }
        return timer
    }
    
    public class func newDispatchTimer(interval: Double, queue: dispatch_queue_t,  repeats: Bool) -> dispatch_source_t? {
        return newDispatchTimer(interval, queue: queue, repeats: repeats, block: nil)
    }
    
    
    public class func startTimer(timer: dispatch_source_t) {
        dispatch_resume(timer)
    }
    
    public class func startTimer(timer: dispatch_source_t, block: dispatch_block_t) {
        dispatch_source_set_event_handler(timer, block)
        dispatch_resume(timer)
    }
    
    public class func cancelTimer(timer: dispatch_source_t) {
        dispatch_source_cancel(timer)
    }

}
