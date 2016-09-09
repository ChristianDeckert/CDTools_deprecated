//
//  CDTableViewTableModel.swift
//  
//
//  Created by Christian Deckert on 21.10.16.
//  Copyright (c) 2014 Christian Deckert GmbH. All rights reserved.
//

import Foundation
import UIKit

public class CDTableViewModelItem<T: Equatable> {
    public var item: T
    var expanded: Bool
    var level: Int = 0
    public var isChild: Bool = false
    
    public init(item: T) {
        self.item = item
        self.expanded = false
    }
}

public class CDTableViewModelSection<T: Equatable> {
    
    weak var tabletableModel: CDTableViewTableModel<T>?
    
    public var items: [CDTableViewModelItem<T>]
    public var title: String = ""
    public var subTitle: String = ""
    
    
    // hierarchy
    public var expanded: Bool = false
    public var level: Int = 0
    
    
    /// Count objects
    /// :returns: Count of all objects
    public var count: Int {
        get {
            return self.items.count
        }
    }
    public var numberOfItems: Int {
        get {
            return self.items.count
        }
    }
    
    /// Init
    public init() {
        self.items = [CDTableViewModelItem<T>]()
    }
    
    /// Init and copy data source
    public init(arrayOfItems items: [CDTableViewModelItem<T>]?) {
        if let i = items {
            self.items = i
        } else {
            self.items = [CDTableViewModelItem<T>]()
        }
    }
    
    public func indexOf(item: T) -> Int? {

        var index = 0
        for currentItem in self.items {
            if let c: T = currentItem.item {
                if c == item {
                    return index
                }
                index += 1
            }
        }
        
        return nil
    }
    
    /// Append a new item of type T
    public func append(item: T) -> CDTableViewModelItem<T> {
        let newItem = CDTableViewModelItem(item: item)
        self.items.append(newItem)
        return newItem
    }
    
    /// Insert a new item of type T at a specific index
    public func insert(item: T, atIndex: NSInteger) -> CDTableViewModelItem<T> {
        let newItem = CDTableViewModelItem(item: item)
        self.items.insert(newItem, atIndex: atIndex)
        return newItem
    }
    
    /// Remove an item of type T at index
    public func remove(index: Int) -> T {
        let item = self.items.removeAtIndex(index)
        return item.item
    }
    
    /// Retreive objects
    /// :returns: Object at given index
    public func item(atIndex index: Int) -> T {
        let item = self.items[index]
        return item.item
    }
    
    public func itemUnwrap<U>(atIndex index: Int) -> U {
        return self.item(atIndex: index) as! U
    }
    
    
    public func maximumValue<T: Comparable>(first: T, _ second: T) -> T {
        
        if (first >= second) {
            return first
        }
        
        return second
    }
    
    /// Clear data source
    public func removeAll() {
        self.items.removeAll(keepCapacity: true)
    }
    
    /// toggleExpanded()
    /// Toggle a table view items expanded flag.
    /// :param: completion Argument isExpanded returns current state. Caller must return list of children for expand/collapse animation
    public func toggleExpanded(atIndexPath indexPath: NSIndexPath, completion: ((isExpanded: Bool) -> Array<T>) ) {
        self.toggleExpanded(atIndex: indexPath.row, section: indexPath.section, completion: completion)
    }
    
    public func toggleExpanded(atIndex index: Int, section: Int, completion: ((isExpanded: Bool) -> Array<T>) ) {
        let expanded = self.isExpanded(index)
        let isExpanded = !expanded
        setExpanded(isExpanded, atIndex: index)
        
        
        if let tableView = self.tabletableModel?.tableController?.tableView {
            let children = completion(isExpanded: isExpanded)
            let currentLevel = self.level(atIndex: index)
            var indexPaths = Array<NSIndexPath>()
            tableView.beginUpdates()
            if isExpanded {
                var childIndex = index + 1
                for child in children
                {
                    let childItem = self.insert(child, atIndex: childIndex)
                    childItem.isChild = true
                    self.setLevel(currentLevel + 1, atIndex: childIndex)
                    indexPaths.append(NSIndexPath(forRow: childIndex, inSection: section))
                    
                    childIndex += 1
                }
                
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Top)
            } else {
                
                for (index, _) in children.reverse().enumerate() {
                    self.remove(index)
                    indexPaths.append(NSIndexPath(forRow: index, inSection: section))
                    
                }
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Top)
            }
            tableView.endUpdates()
        }
        
    }
    
    public func isExpanded(atIndex: Int) -> Bool {
        if atIndex < self.items.count {
            let item = self.items[atIndex]
            return item.expanded
        }
        return false
    }
    
    public func setExpanded(expanded: Bool, atIndex: Int) -> Void {
        if atIndex < self.items.count {
            let item = self.items[atIndex]
            item.expanded = expanded
        }
    }
    
    public func level(atIndex index: Int) -> Int {
        if index < self.items.count {
            let item = self.items[index]
            return item.level
        }
        return 0
    }
    
    public func setLevel(level: Int, atIndex index: Int) -> Void {
        if index < self.items.count {
            let item = self.items[index]
            item.level = level
        }
    }
}


public class CDTableViewTableModel<T: Equatable> {
    
    public weak var tableController: CDTableController<T>?
    
    public var sections = Array<CDTableViewModelSection<T>>()
    
    public var numberOfSections: Int {
        get {
            return self.sections.count
        }
    }
    
    /// Init
    public init() {
    }
    
    public func item(atIndex indexPath: NSIndexPath) -> T? {
        if indexPath.section < self.sections.count {
            let section = self.sections[indexPath.section]
            
            if indexPath.row < section.items.count {
                let item = section.item(atIndex: indexPath.row)
                return item
            }
        }
        return nil
    }
    
    public func itemIsChild(atIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section < self.sections.count {
            let section = self.sections[indexPath.section]
            
            if indexPath.row < section.items.count {
                let item = section.items[indexPath.row]
                return item.isChild
            }
        }
        return false
    }
    
    
    public func numberOfItemsInSection( sectionNumber: Int) -> Int {
        if sectionNumber < self.sections.count {
            let section = self.sections[sectionNumber]
            
            return section.numberOfItems
      }
        return 0
    }
    
    public func addSection(title: String, subtitle: String?) -> CDTableViewModelSection<T> {
        let section = CDTableViewModelSection<T>()
        section.title = title
        if let sub = subtitle {
            section.subTitle = sub
        }
        self.sections.append(section)
        section.tabletableModel = self
        return section
    }
    
    public func addSection() -> CDTableViewModelSection<T> {
        return self.addSection("", subtitle: nil)
    }
    
    public func sectionAt(index: Int) -> CDTableViewModelSection<T>? {
        if index < self.sections.count {
            return self.sections[index]
        }
        
        return nil
    }
    
    public func append(item newItem: T, inSection sectionIndex: Int = 0) -> CDTableViewModelItem<T>? {
        
        while nil == self.sectionAt(sectionIndex) {
            self.addSection()
        }
        
        let section = self.sectionAt(sectionIndex)
        return section?.append(newItem)
    }
    
    public func insert(item: T, atIndex:NSInteger, inSection sectionIndex: Int = 0) -> CDTableViewModelItem<T>? {
        
        while nil == self.sectionAt(sectionIndex) {
            self.addSection()
        }
        
        let section = self.sectionAt(sectionIndex)
        return section?.insert(item, atIndex: atIndex)
    }
    
    public func remove(atIndex:NSInteger, inSection: Int) -> T? {
        let section = self.sectionAt(inSection)
        return section?.remove(atIndex)
    }
    
    public func removeAll() {
        self.sections.removeAll()
    }
    
    public func enumerate<U>(callback: (index: Int, item: U) -> Void) -> Bool {
        return self.enumerate(section: 0, callback: callback)
    }
    
    public func enumerate<U>(section sectionNumber: Int, callback: (index: Int, item: U) -> Void) -> Bool {
        
        guard let section = self.sectionAt(0) else {
            return false
        }
        
        for (index, item) in section.items.enumerate() {
            callback(index: index, item: item.item as! U)
        }
        return true
    }
    
    public func isExpanded(atIndex: Int, inSection: Int) -> Bool {

        if let section = self.sectionAt(inSection) {
            return section.isExpanded(atIndex)
        }
        return false
    }
    
    public func isExpanded(atIndexPath: NSIndexPath) -> Bool {
        
        return self.isExpanded(atIndexPath.row, inSection: atIndexPath.section)
    }
    
    public func setExpanded(expanded: Bool, atIndex: Int, inSection: Int) -> Void {
        if let section = self.sectionAt(inSection) {
            return section.setExpanded(expanded, atIndex: atIndex)
        }
    }
    
    public func setExpanded(expanded: Bool, atIndexPath: NSIndexPath) -> Void {
        self.setExpanded(expanded, atIndex: atIndexPath.row, inSection: atIndexPath.section)
    }
    
    
    public func level(atIndexPath indexPath: NSIndexPath) -> Int {
        
        if let section = self.sectionAt(indexPath.section) {
            return section.level(atIndex: indexPath.row)
        }

        return 0
    }
    
    public func setLevel(level: Int, atIndexPath: NSIndexPath) -> Void {
        if let section = self.sectionAt(atIndexPath.section) {
            return section.setLevel(level, atIndex: atIndexPath.row)
        }
    }
    
    public func toggleExpanded(atIndexPath indexPath: NSIndexPath, completion: ((isExpanded: Bool) -> Array<T>) ) {
        if let section = self.sectionAt(indexPath.section) {
            section.toggleExpanded(atIndexPath: indexPath, completion: completion)
        }
    }
}
