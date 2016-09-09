//
//  CDTableViewController.swift
//  
//
//  Created by Christian Deckert on 22.10.16.
//  Copyright (c) 2014 Christian Deckert GmbH. All rights reserved.
//

import Foundation
import UIKit

public extension UINib {
    public static func nibForCDTableViewCell(cell: CDTableViewCell.Type, bundle: NSBundle? = nil) -> UINib {
        return UINib(nibName: cell.cellReuseIdentifier(), bundle: bundle)
    }
}

public extension UITableView {
    public func registerCDTableViewCell(cell: CDTableViewCell.Type, bundle: NSBundle? = nil) {
        self.registerNib(UINib.nibForCDTableViewCell(cell, bundle: bundle ?? NSBundle(forClass: cell.classForCoder())), forCellReuseIdentifier: cell.cellReuseIdentifier())
    }
}

public protocol CDTableControllertableModel: NSObjectProtocol {
    func CDTableControllerGetTableView() -> UITableView?
}

public class CDTableController<T: Equatable>: NSObject, UITableViewDelegate  {
    
    weak var cdTableControllertableModel: CDTableControllertableModel?
    var tableView: UITableView? {
        get {
            return self.cdTableControllertableModel?.CDTableControllerGetTableView()
        }
    }
    
    var tableModel = CDTableViewTableModel<T>()

    weak var weakTableViewController: CDTableViewController? //STRONG TABLEVIEW TO BE DEFINED IN SUBCLASSES
    
    public init(CDTableControllertableModel tableModel: CDTableControllertableModel?) {
        self.cdTableControllertableModel = tableModel
        super.init()
        commontInit()
    }
    
    public required init(tableViewController: CDTableViewController) {
        super.init()
        self.weakTableViewController = tableViewController
        commontInit()
    }
    
    public override init() {
        super.init()
        commontInit()
    }
    
    func commontInit() {
        self.tableModel.tableController = self
    }
    
    // MARK: - UITableViewDelegate & -tableModel
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = self.tableModel.numberOfItemsInSection(section)
        return numberOfItems
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CDTableViewCell = tableView.dequeueReusableCellWithIdentifier(CDTableViewCell.cellReuseIdentifier()) as! CDTableViewCell
        
        if let item = self.tableModel.item(atIndex: indexPath) as? NSObject {
            cell.textLabel?.text = item.description
        } else {
            cell.textLabel?.text = "Please override cellForRowAtIndexPath"
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return 44.0
        }
        
        return 64.0
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cdCell = cell as? CDTableViewCell else {
            return
        }
        
        cdCell.indexPath = indexPath
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableModel.numberOfSections
    }
    
    public func hightlightSelectedBackgroundView(indexPath: NSIndexPath) -> Void {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = self.weakTableViewController?.selectedBackgroundViewColor
        let cell = weakTableViewController?.weakTableView?.cellForRowAtIndexPath(indexPath)
        cell?.selectedBackgroundView = selectedBackgroundView
    }

}

/// A custom view controller with a tableview embedded
///
/// ###Benefits
/// - Embedded tableModel and controller will drastically improve implementation speeds
/// - Type safety data
/// - Automatically returns number of sections/rows by implementing UITableViewtableModel / UITableViewDelegate
//public class CDTableViewController<T: Equatable>: CDBaseViewController, UITableViewtableModel, UITableViewDelegate,
public class CDTableViewController: CDBaseViewController, UITableViewDataSource, UITableViewDelegate,
UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, CDTableControllertableModel {
    
    public var selectedBackgroundViewEnabled: Bool = true
    public var selectedBackgroundViewColor = UIColor.whiteColor()
    public var cdTableController = CDTableController<NSObject>(CDTableControllertableModel: nil)
    public var tableModel: CDTableViewTableModel<NSObject> {
        get {
            return self.cdTableController.tableModel
        }
    }
    
    public var searchController: UISearchController?
    
    public weak var weakTableView: UITableView? //STRONG TABLEVIEW TO BE DEFINED IN SUBCLASSES (Storyboard) AN SET WEAK VAR IN LOADVIEW()
    public var refreshControl: UIRefreshControl?
    
    
    // MARK: - Life cycle
    
    public override func loadView() {
        super.loadView()
        self.cdTableController.cdTableControllertableModel = self
        findTableView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cdTableController.weakTableViewController = self
        if let tv = self.weakTableView {
            tv.delegate = self
            tv.dataSource = self
            tv.separatorInset = UIEdgeInsetsZero
            tv.separatorColor = UIColor.clearColor()
        }
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Batch Updates
    
    public func insertAnimated(sectionIndizes: NSIndexSet, rowIndizes: Array<NSIndexPath>, animation: UITableViewRowAnimation) -> Void {
        
        if let tv = self.weakTableView {
            tv.beginUpdates()
            
            if sectionIndizes.count > 0 {
                tv.insertSections(sectionIndizes, withRowAnimation: animation)
            }
            if !rowIndizes.isEmpty {
                tv.insertRowsAtIndexPaths(rowIndizes, withRowAnimation: animation)
            }
            tv.endUpdates()
        }
    }
    
    public func deleteAnimated(sectionIndizes: NSIndexSet, rowIndizes: Array<NSIndexPath>, animation: UITableViewRowAnimation) -> Void {
        
        if let tv = self.weakTableView {
            tv.beginUpdates()
            
            if sectionIndizes.count > 0 {
                tv.deleteSections(sectionIndizes, withRowAnimation: animation)
            }
            if !rowIndizes.isEmpty {
                tv.deleteRowsAtIndexPaths(rowIndizes, withRowAnimation: animation)
            }
            tv.endUpdates()
        }
    }
    
    // MARK: - Refresh Control
    
    public func addRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAction), forControlEvents: UIControlEvents.ValueChanged)
        if let tableView = self.weakTableView {
            tableView.addSubview(refreshControl)
        }
    }
    
    
    // MARK: - Refresh Control
    
    public func refreshAction() {
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - UITableViewDelegate & -tableModel
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cdTableController.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cdTableController.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cdTableController.numberOfSectionsInTableView(tableView)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cdTableController.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.self.cdTableController.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        if self.selectedBackgroundViewEnabled {
            self.self.cdTableController.hightlightSelectedBackgroundView(indexPath)
        }
    }
    
    // MARK: - Search Controller
    
    public func addSearchController() {
        
        let uselessView = UIView()
        uselessView.backgroundColor = UIColor.clearColor()
        self.weakTableView?.backgroundView = uselessView
        
        self.searchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.definesPresentationContext = true
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()

            self.weakTableView?.tableHeaderView = controller.searchBar
            
            return controller
        }()

    
    }
    
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
    
    // MARK: - CDTableControllertableModel
    
    public func CDTableControllerGetTableView() -> UITableView? {
        return self.weakTableView
    }
    
    // MARK: - Other
    
    private func findTableView() {
        
        guard nil == self.weakTableView else {
            return
        }
        
        for view in self.view.subviews {
            if let tableView = view as? UITableView {
                self.weakTableView = tableView
                
                tableView.registerClass(CDTableViewCell.self, forCellReuseIdentifier: CDTableViewCell.cellReuseIdentifier())
                break;
            }
        }
    }
    
}

