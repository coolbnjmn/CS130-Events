//
//  EventTableViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventTableViewController: BaseViewController {
    
    var eventTableViewControllerProvider:EventTableViewControllerProvider = EventTableViewControllerProvider();
    var eventManagerModel:EventManagerModel = EventManagerModel(userId: "123");
        
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
//        self.tableView.registerClass(EventTableViewCell.self, forCellReuseIdentifier: "eventCell")
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationItem.title = "Home"
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController!.navigationBar.backgroundColor = UIColor.whiteColor()
        navigationController!.navigationBar.barTintColor = UIColor.themeColor()

        self.setupMenuBarButtonItems()
        
        self.tableView.dataSource = self.eventTableViewControllerProvider;
        self.tableView.delegate = self.eventTableViewControllerProvider;
        
        self.eventTableViewControllerProvider.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchData();
    }
    
    func fetchData() {
        var successBlock: NSMutableArray -> Void = {
            (eventArray: NSMutableArray) -> Void in
            self.eventTableViewControllerProvider.configure(eventArray);
            self.tableView.reloadData();
        }
        
        var failureBlock: NSError -> Void = {
            (error: NSError) -> Void in
            println("Error: \(error)");
        }
        
        eventManagerModel.retrieveUpcomingEvents(successBlock, failure: failureBlock);
    }
    
    func setupMenuBarButtonItems() {
        self.navigationItem.leftBarButtonItem = self.leftMenuBarButtonItem()
        self.navigationItem.rightBarButtonItem = self.rightMenuBarButtonItem()
    }
    
    
    func leftMenuBarButtonItem() -> UIBarButtonItem {
        let leftButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-menu.png"), style:UIBarButtonItemStyle.Plain, target: self, action: "leftSideMenuButtonPressed:")
        leftButton.tintColor = UIColor.whiteColor()
        return leftButton
    }
    
    func rightMenuBarButtonItem() -> UIBarButtonItem {
        let rightButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-plus.png"), style:UIBarButtonItemStyle.Plain, target: self, action: "rightPlusButtonPressed:")
        rightButton.tintColor = UIColor.whiteColor()
        return rightButton
    }
    
    func leftSideMenuButtonPressed(sender: AnyObject) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({
            self.setupMenuBarButtonItems()
        })
    }
    
    func rightPlusButtonPressed(sender: AnyObject) {
        NSLog("Pressed + button")
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

   
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
