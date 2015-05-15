//
//  BaseSearchProvider.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit


class BaseSearchProvider: NSObject, UISearchResultsUpdating, UISearchControllerDelegate {
    var searchController: UISearchController?
    var tableView: UITableView?
    var tableViewProvider: EventTableViewControllerProvider?
    var searchProvider: EventTableViewControllerProvider?
    var data: NSMutableArray?
    var searchResults : NSMutableArray?
    
    func setSearchTableView(tableView: UITableView, provider: BaseProvider) {
        self.tableView = tableView
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.delegate = self
            
            self.tableView?.tableHeaderView = controller.searchBar
            return controller;
        })()
    }
    
    func configure(data: NSMutableArray, provider: EventTableViewControllerProvider) {
        self.data = data
        self.tableViewProvider = provider
    }
    
    func applySearch(sender: AnyObject) {
        println("to be implemented by the provider subclass")
    }
    

    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.applySearch(self)
        if let searchResults = self.searchResults {
            if(searchResults.count == 0 && count(searchController.searchBar.text) == 0) {
                self.searchProvider?.configure(self.data!)
            } else {
                self.searchProvider?.configure(self.searchResults!)
            }
        } else {
            self.searchProvider?.configure(self.data!)
        }
        self.tableView?.reloadData()
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        println("will present search controller")
        if let searchResults = self.searchResults {
            self.searchProvider?.configure(self.searchResults!)
        } else {
            self.searchProvider?.configure(self.data!)
        }
        self.tableView?.dataSource = self.searchProvider
        self.tableView?.delegate = self.searchProvider
        self.tableView?.reloadData()
    }
    func willDismissSearchController(searchController: UISearchController) {
        println("will dismiss search controller")
        self.tableView?.dataSource = self.tableViewProvider
        self.tableView?.delegate = self.tableViewProvider
        self.tableView?.reloadData()

    }
   


}
