//
//  BaseSearchProvider.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit


class BaseSearchProvider: BaseProvider, UISearchResultsUpdating, UISearchControllerDelegate {
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
            controller.searchBar.backgroundColor = Constants.Colors.BackgroundGrayColor
            
            var textFieldInsideSearchBar = controller.searchBar.valueForKey("searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
            
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
            if let data = self.data {
                self.searchProvider?.configure(self.data!)
            } else {
                self.searchProvider?.configure(NSMutableArray())
            }
        }
        self.tableView?.reloadData()
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        let uiButton = searchController.searchBar.valueForKey("cancelButton") as? UIButton
        uiButton?.titleLabel?.textColor = UIColor.whiteColor()
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        println("will present search controller")
        
        if let searchResults = self.searchResults {
            self.searchProvider?.configure(self.searchResults!)
        } else {
            if let data = self.data {
                self.searchProvider?.configure(self.data!)
            } else {
                self.searchProvider?.configure(NSMutableArray())
            }
        }
        self.searchProvider!.delegate = self.delegate
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
