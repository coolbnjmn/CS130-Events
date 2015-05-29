//
//  BaseEventTableViewController.swift
//  Udder
//
//  Created by Collin Yen on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class BaseEventTableViewController : BaseViewController, EventTableDelegate {
    
    // Table
    var eventTableViewControllerProvider:EventTableViewControllerProvider = EventTableViewControllerProvider();
    var eventManagerModel:EventManagerModel = EventManagerModel.sharedInstance;
    var eventSearchProvider: EventSearchProvider = EventSearchProvider();
    var storeHouseRefreshControl:CBStoreHouseRefreshControl?;
    
    @IBOutlet var tableView: UITableView!
    
    // Reloading
    var reloading:Bool = false;
    
    // Completion blocks for retrieving data: Override in subclasses for customization
    var successBlock: NSMutableArray -> Void = {(event: NSMutableArray) -> Void in};
    var failureBlock: NSError -> Void = {(error: NSError) -> Void in};
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.whiteColor();
        self.tableView.alwaysBounceVertical = true;
        self.tableView.backgroundView = UIView();
        
        self.setupMenuBarButtonItems()
        
        self.tableView.dataSource = self.eventTableViewControllerProvider;
        self.tableView.delegate = self.eventTableViewControllerProvider;
        
        self.storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: "refreshTriggered", plist: "storehouse", color: UIColor.darkGrayColor(), lineWidth: 1.5, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: true, internalAnimationFactor: 0.5);
        
        self.eventTableViewControllerProvider.delegate = self;
        self.eventSearchProvider.setSearchTableView(self.tableView, provider: self.eventTableViewControllerProvider)
        definesPresentationContext = true
        
        self.successBlock = {
            (eventArray: NSMutableArray) -> Void in
            self.eventTableViewControllerProvider.configure(eventArray);
            self.eventTableViewControllerProvider.eventTableDelegate = self;
            self.eventSearchProvider.configure(eventArray, provider:self.eventTableViewControllerProvider);
            self.eventSearchProvider.delegate = self
            self.tableView.reloadData();
            
            if self.reloading {
                self.storeHouseRefreshControl?.finishingLoading();
                self.reloading = false;
            }
            else {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true);
            }
        }
        
        self.failureBlock = {
            (error: NSError) -> Void in
            println("Error: \(error)");
            
            if self.reloading {
                self.storeHouseRefreshControl?.finishingLoading();
                self.reloading = false;
            }
        }
        
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
    
    func rightPlusButtonPressed(sender: AnyObject) {
        var wholeViewController:WholeViewController = WholeViewController(nibName: "WholeViewController", bundle: nil);
        self.navigationController?.pushViewController(wholeViewController, animated: true);
    }
    
    func leftSideMenuButtonPressed(sender: AnyObject) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({
            self.setupMenuBarButtonItems()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoreData(page: Int, success: NSMutableArray -> Void, failure: NSError -> Void) {
        println("To be implemented by subclass...");
    }
    
    // MARK: Scrollview Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.storeHouseRefreshControl?.scrollViewDidScroll();
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.storeHouseRefreshControl?.scrollViewDidEndDragging();
    }
    
    func refreshTriggered() {
        self.reloading = true;
        self.fetchData();
    }

}
