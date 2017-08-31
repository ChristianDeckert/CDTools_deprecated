//
//  CDTableViewTableModel.swift
//
//
//  Created by Christian Deckert on 21.10.16.
//  Copyright (c) 2014 Christian Deckert GmbH. All rights reserved.
//

import Foundation
import UIKit

open class CDTableViewModelItem<T: Equatable> {
    open var item: T
    var expanded: Bool
    var level: Int = 0
    open var isChild: Bool = false
    
    public init(item: T) {
        self.item = item
        self.expanded = false
    }
}

open class CDTableViewModelSection<T: Equatable> {
    
    weak var tabletableModel: CDTableViewTableModel<T>?
    
    open var items: [CDTableViewModelItem<T>]
    open var title: String = ""
    open var subTitle: String = ""
    
    
    // hierarchy
    open var expanded: Bool = false
    open var level: Int = 0
    
    
    /// Count objects
    /// :returns: Count of all objects
    open var count: Int {
        get {
            return self.items.count
        }
    }
    open var numberOfItems: Int {
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
    
    open func indexOf(_ item: T) -> Int? {
        
        var index = 0
        for currentItem in self.items {
            let c: T = currentItem.item
            if c == item {
                return index
            }
            index += 1
        }
        
        return nil
    }
    
    /// Append a new item of type T
    @discardableResult open func append(_ item: T) -> CDTableViewModelItem<T> {
        let newItem = CDTableViewModelItem(item: item)
        self.items.append(newItem)
        return newItem
    }
    
    /// Insert a new item of type T at a specific index
    open func insert(_ item: T, atIndex: NSInteger) -> CDTableViewModelItem<T> {
        let newItem = CDTableViewModelItem(item: item)
        self.items.insert(newItem, at: atIndex)
        return newItem
    }
    
    /// Remove an item of type T at index
    @discardableResult open func remove(_ index: Int) -> T {
        let item = self.items.remove(at: index)
        return item.item
    }
    
    /// Retreive objects
    /// :returns: Object at given index
    open func item(atIndex index: Int) -> T {
        let item = self.items[index]
        return item.item
    }
    
    open func itemUnwrap<U>(atIndex index: Int) -> U {
        return self.item(atIndex: index) as! U
    }
    
    
    open func maximumValue<T: Comparable>(_ first: T, _ second: T) -> T {
        
        if (first >= second) {
            return first
        }
        
        return second
    }
    
    /// Clear data source
    open func removeAll() {
        self.items.removeAll(keepingCapacity: true)
    }
    
    /// toggleExpanded()
    /// Toggle a table view items expanded flag.
    /// :param: completion Argument isExpanded returns current state. Caller must return list of children for expand/collapse animation
    open func toggleExpanded(atIndexPath indexPath: IndexPath, completion: ((_ isExpanded: Bool) -> Array<T>) ) {
        self.toggleExpanded(atIndex: indexPath.row, section: indexPath.section, completion: completion)
    }
    
    open func toggleExpanded(atIndex index: Int, section: Int, completion: ((_ isExpanded: Bool) -> Array<T>) ) {
        let expanded = self.isExpanded(index)
        let isExpanded = !expanded
        setExpanded(isExpanded, atIndex: index)
        
        
        if let tableView = self.tabletableModel?.tableController?.tableView {
            let children = completion(isExpanded)
            let currentLevel = self.level(atIndex: index)
            var indexPaths = Array<IndexPath>()
            tableView.beginUpdates()
            if isExpanded {
                var childIndex = index + 1
                for child in children
                {
                    let childItem = self.insert(child, atIndex: childIndex)
                    childItem.isChild = true
                    self.setLevel(currentLevel + 1, atIndex: childIndex)
                    indexPaths.append(IndexPath(row: childIndex, section: section))
                    
                    childIndex += 1
                }
                
                tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.top)
            } else {
                
                for (index, _) in children.reversed().enumerated() {
                    self.remove(index)
                    indexPaths.append(IndexPath(row: index, section: section))
                    
                }
                tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.top)
            }
            tableView.endUpdates()
        }
        
    }
    
    open func isExpanded(_ atIndex: Int) -> Bool {
        if atIndex < self.items.count {
            let item = self.items[atIndex]
            return item.expanded
        }
        return false
    }
    
    open func setExpanded(_ expanded: Bool, atIndex: Int) -> Void {
        if atIndex < self.items.count {
            let item = self.items[atIndex]
            item.expanded = expanded
        }
    }
    
    open func level(atIndex index: Int) -> Int {
        if index < self.items.count {
            let item = self.items[index]
            return item.level
        }
        return 0
    }
    
    open func setLevel(_ level: Int, atIndex index: Int) -> Void {
        if index < self.items.count {
            let item = self.items[index]
            item.level = level
        }
    }
}


open class CDTableViewTableModel<T: Equatable> {
    
    open weak var tableController: CDTableController<T>?
    
    open var sections = Array<CDTableViewModelSection<T>>()
    
    open var numberOfSections: Int {
        get {
            return self.sections.count
        }
    }
    
    /// Init
    public init() {
    }
    
    open func item(atIndex indexPath: IndexPath) -> T? {
        if indexPath.section < self.sections.count {
            let section = self.sections[indexPath.section]
            
            if indexPath.row < section.items.count {
                let item = section.item(atIndex: indexPath.row)
                return item
            }
        }
        return nil
    }
    
    open func itemIsChild(atIndexPath indexPath: IndexPath) -> Bool {
        if indexPath.section < self.sections.count {
            let section = self.sections[indexPath.section]
            
            if indexPath.row < section.items.count {
                let item = section.items[indexPath.row]
                return item.isChild
            }
        }
        return false
    }
    
    
    open func numberOfItemsInSection( _ sectionNumber: Int) -> Int {
        if sectionNumber < self.sections.count {
            let section = self.sections[sectionNumber]
            
            return section.numberOfItems
        }
        return 0
    }
    
    @discardableResult open func addSection(_ title: String, subtitle: String?) -> CDTableViewModelSection<T> {
        let section = CDTableViewModelSection<T>()
        section.title = title
        if let sub = subtitle {
            section.subTitle = sub
        }
        self.sections.append(section)
        section.tabletableModel = self
        return section
    }
    
    @discardableResult open func addSection() -> CDTableViewModelSection<T> {
        return self.addSection("", subtitle: nil)
    }
    
    open func sectionAt(_ index: Int) -> CDTableViewModelSection<T>? {
        if index < self.sections.count {
            return self.sections[index]
        }
        
        return nil
    }
    
    open func append(item newItem: T, inSection sectionIndex: Int = 0) -> CDTableViewModelItem<T>? {
        
        while nil == self.sectionAt(sectionIndex) {
            self.addSection()
        }
        
        let section = self.sectionAt(sectionIndex)
        return section?.append(newItem)
    }
    
    open func insert(_ item: T, atIndex:NSInteger, inSection sectionIndex: Int = 0) -> CDTableViewModelItem<T>? {
        
        while nil == self.sectionAt(sectionIndex) {
            self.addSection()
        }
        
        let section = self.sectionAt(sectionIndex)
        return section?.insert(item, atIndex: atIndex)
    }
    
    open func remove(_ atIndex:NSInteger, inSection: Int) -> T? {
        let section = self.sectionAt(inSection)
        return section?.remove(atIndex)
    }
    
    open func removeAll() {
        self.sections.removeAll()
    }
    
    open func enumerate<U>(_ callback: (_ index: Int, _ item: U) -> Void) -> Bool {
        return self.enumerate(section: 0, callback: callback)
    }
    
    @discardableResult open func enumerate<U>(section sectionNumber: Int, callback: (_ index: Int, _ item: U) -> Void) -> Bool {
        
        guard let section = self.sectionAt(sectionNumber) else {
            return false
        }
        
        for (index, item) in section.items.enumerated() {
            callback(index, item.item as! U)
        }
        return true
    }
    
    open func isExpanded(_ atIndex: Int, inSection: Int) -> Bool {
        
        if let section = self.sectionAt(inSection) {
            return section.isExpanded(atIndex)
        }
        return false
    }
    
    open func isExpanded(_ atIndexPath: IndexPath) -> Bool {
        
        return self.isExpanded(atIndexPath.row, inSection: atIndexPath.section)
    }
    
    open func setExpanded(_ expanded: Bool, atIndex: Int, inSection: Int) -> Void {
        if let section = self.sectionAt(inSection) {
            return section.setExpanded(expanded, atIndex: atIndex)
        }
    }
    
    open func setExpanded(_ expanded: Bool, atIndexPath: IndexPath) -> Void {
        self.setExpanded(expanded, atIndex: atIndexPath.row, inSection: atIndexPath.section)
    }
    
    
    open func level(atIndexPath indexPath: IndexPath) -> Int {
        
        if let section = self.sectionAt(indexPath.section) {
            return section.level(atIndex: indexPath.row)
        }
        
        return 0
    }
    
    open func setLevel(_ level: Int, atIndexPath: IndexPath) -> Void {
        if let section = self.sectionAt(atIndexPath.section) {
            return section.setLevel(level, atIndex: atIndexPath.row)
        }
    }
    
    open func toggleExpanded(atIndexPath indexPath: IndexPath, completion: ((_ isExpanded: Bool) -> Array<T>) ) {
        if let section = self.sectionAt(indexPath.section) {
            section.toggleExpanded(atIndexPath: indexPath, completion: completion)
        }
    }
}
