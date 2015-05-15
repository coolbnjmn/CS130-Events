//
//  BaseEventTableViewController.swift
//  Udder
//
//  Created by Collin Yen on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class BaseEventTableViewController : BaseViewController {
    
    var eventTableViewControllerProvider:EventTableViewControllerProvider = EventTableViewControllerProvider();
    var eventManagerModel:EventManagerModel = EventManagerModel.sharedInstance;
    var searchProvider: EventSearchProvider = EventSearchProvider()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.setupMenuBarButtonItems()
        
        self.tableView.dataSource = self.eventTableViewControllerProvider;
        self.tableView.delegate = self.eventTableViewControllerProvider;
        
        self.eventTableViewControllerProvider.delegate = self;
        
        self.searchProvider.setSearchTableView(self.tableView, provider: self.eventTableViewControllerProvider)
        definesPresentationContext = true

    }
    
    
    override func viewWillAppear(animated: Bool) {
        fetchData();
    }
    
    func fetchData() {
        println("To be implemented by subclass...");

    }
    
    func setupMenuBarButtonItems() {
        self.navigationItem.leftBarButtonItem = self.leftMenuBarButtonItem()
        self.navigationItem.rightBarButtonItem = self.rightMenuBarButtonItem()
    }
    
    
    func leftMenuBarButtonItem() -> UIBarButtonItem {
        let leftButton:UIBarButtonItem = UIBarButtonItem(image: Constants.Images.NavBarIcon, style:UIBarButtonItemStyle.Plain, target: self, action: "leftSideMenuButtonPressed:")
        leftButton.tintColor = UIColor.whiteColor()
        return leftButton
    }
    
    func rightMenuBarButtonItem() -> UIBarButtonItem {
        let rightButton:UIBarButtonItem = UIBarButtonItem(image: Constants.Images.PlusIcon, style:UIBarButtonItemStyle.Plain, target: self, action: "rightPlusButtonPressed:")
        rightButton.tintColor = UIColor.whiteColor()
        return rightButton
    }
    
    func leftSideMenuButtonPressed(sender: AnyObject) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({
            self.setupMenuBarButtonItems()
        })
    }
    
    func rightPlusButtonPressed(sender: AnyObject) {
        var wholeViewController:WholeViewController = WholeViewController(nibName: "WholeViewController", bundle: nil);
        self.navigationController?.pushViewController(wholeViewController, animated: true);
    }
    
    func rightSideMenuButtonPressed(sender: AnyObject) {
        // let createVC = WholeViewController(nibName: "WholeViewController", bundle: nil)
        // self.presentViewController(createVC, animated: false, completion: nil)
        
        let nibNameToSwitchTo: String?
        let navController: UINavigationController?
        nibNameToSwitchTo = "WholeViewController";
        navController = UINavigationController(rootViewController: WholeViewController(nibName: nibNameToSwitchTo, bundle:nil))
        self.menuContainerViewController.centerViewController = navController
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
