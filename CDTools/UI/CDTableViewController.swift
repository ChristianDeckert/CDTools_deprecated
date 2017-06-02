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
    public static func nibForCDTableViewCell(_ cell: CDTableViewCell.Type, bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: cell.cellReuseIdentifier(), bundle: bundle)
    }
}

public extension UITableView {
    public func registerCDTableViewCell(_ cell: CDTableViewCell.Type, bundle: Bundle? = nil) {
        self.register(UINib.nibForCDTableViewCell(cell, bundle: bundle ?? Bundle(for: cell.classForCoder())), forCellReuseIdentifier: cell.cellReuseIdentifier())
    }
}

public protocol CDTableControllertableModel: NSObjectProtocol {
    func CDTableControllerGetTableView() -> UITableView?
}

open class CDTableController<T: Equatable>: NSObject, UITableViewDelegate  {
    
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
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = self.tableModel.numberOfItemsInSection(section)
        return numberOfItems
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell: CDTableViewCell = tableView.dequeueReusableCell(withIdentifier: CDTableViewCell.cellReuseIdentifier()) as! CDTableViewCell
        
        if let item = self.tableModel.item(atIndex: indexPath) as? NSObject {
            cell.textLabel?.text = item.description
        } else {
            cell.textLabel?.text = "Please override cellForRowAtIndexPath"
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 44.0
        }
        
        return 64.0
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cdCell = cell as? CDTableViewCell else {
            return
        }
        
        cdCell.indexPath = indexPath
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    open func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return self.tableModel.numberOfSections
    }
    
    open func hightlightSelectedBackgroundView(_ indexPath: IndexPath) -> Void {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = self.weakTableViewController?.selectedBackgroundViewColor
        let cell = weakTableViewController?.weakTableView?.cellForRow(at: indexPath)
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
open class CDTableViewController: CDBaseViewController, UITableViewDataSource, UITableViewDelegate,
UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, CDTableControllertableModel {
    
    open var selectedBackgroundViewEnabled: Bool = true
    open var selectedBackgroundViewColor = UIColor.white
    open var cdTableController = CDTableController<NSObject>(CDTableControllertableModel: nil)
    open var tableModel: CDTableViewTableModel<NSObject> {
        get {
            return self.cdTableController.tableModel
        }
    }
    
    open var searchController: UISearchController?
    
    open weak var weakTableView: UITableView? //STRONG TABLEVIEW TO BE DEFINED IN SUBCLASSES (Storyboard) AN SET WEAK VAR IN LOADVIEW()
    open var refreshControl: UIRefreshControl?
    
    
    // MARK: - Life cycle
    
    open override func loadView() {
        super.loadView()
        self.cdTableController.cdTableControllertableModel = self
        findTableView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cdTableController.weakTableViewController = self
        if let tv = self.weakTableView {
            tv.delegate = self
            tv.dataSource = self
            tv.separatorInset = UIEdgeInsets.zero
            tv.separatorColor = UIColor.clear
        }
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Batch Updates
    
    open func insertAnimated(_ sectionIndizes: IndexSet, rowIndizes: Array<IndexPath>, animation: UITableViewRowAnimation) -> Void {
        
        if let tv = self.weakTableView {
            tv.beginUpdates()
            
            if sectionIndizes.count > 0 {
                tv.insertSections(sectionIndizes, with: animation)
            }
            if !rowIndizes.isEmpty {
                tv.insertRows(at: rowIndizes, with: animation)
            }
            tv.endUpdates()
        }
    }
    
    open func deleteAnimated(_ sectionIndizes: IndexSet, rowIndizes: Array<IndexPath>, animation: UITableViewRowAnimation) -> Void {
        
        if let tv = self.weakTableView {
            tv.beginUpdates()
            
            if sectionIndizes.count > 0 {
                tv.deleteSections(sectionIndizes, with: animation)
            }
            if !rowIndizes.isEmpty {
                tv.deleteRows(at: rowIndizes, with: animation)
            }
            tv.endUpdates()
        }
    }
    
    // MARK: - Refresh Control
    
    open func addRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAction), for: UIControlEvents.valueChanged)
        if let tableView = self.weakTableView {
            tableView.addSubview(refreshControl)
        }
    }
    
    
    // MARK: - Refresh Control
    
    open func refreshAction() {
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - UITableViewDelegate & -tableModel
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cdTableController.tableView(tableView, heightForRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cdTableController.tableView(tableView, numberOfRowsInSection: section)
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.cdTableController.numberOfSectionsInTableView(tableView)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cdTableController.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.self.cdTableController.tableView(tableView, didSelectRowAt: indexPath)
        if self.selectedBackgroundViewEnabled {
            self.self.cdTableController.hightlightSelectedBackgroundView(indexPath)
        }
    }
    
    // MARK: - Search Controller
    
    open func addSearchController() {
        
        let uselessView = UIView()
        uselessView.backgroundColor = UIColor.clear
        self.weakTableView?.backgroundView = uselessView
        
        self.searchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.definesPresentationContext = true
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            
            self.weakTableView?.tableHeaderView = controller.searchBar
            
            return controller
        }()
        
        
    }
    
    open func updateSearchResults(for searchController: UISearchController) {
    }
    
    // MARK: - CDTableControllertableModel
    
    open func CDTableControllerGetTableView() -> UITableView? {
        return self.weakTableView
    }
    
    // MARK: - Other
    
    fileprivate func findTableView() {
        
        guard nil == self.weakTableView else {
            return
        }
        
        for view in self.view.subviews {
            if let tableView = view as? UITableView {
                self.weakTableView = tableView
                
                tableView.register(CDTableViewCell.self, forCellReuseIdentifier: CDTableViewCell.cellReuseIdentifier())
                break;
            }
        }
    }
    
}

