//
//  ViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController {
    
    @IBOutlet weak var tapHereButton: UIButton!
    
    @IBAction func tapHereWasPressed(sender: AnyObject) {
        PFUser.logOut()
        NSLog("Logged out")
        self.redirectToLogin()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoutText: String = "Logout: " + (PFUser.currentUser().objectForKey("full_name") as? String ?? "")
        tapHereButton.setTitle(logoutText, forState: UIControlState.Normal)
        
        /*var eventManagerModel:EventManagerModel = EventManagerModel(userId: "123");
        
        var successBlock: NSMutableArray -> Void = {
            (eventArray: NSMutableArray) -> Void in
            for event in eventArray {
                if let eventModel = event as? EventModel {
                    //eventModel.printEvent();
                    var eventDetailViewController:EventDetailViewController = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil);
                    eventDetailViewController.setupWithEvent(eventModel);
                    self.navigationController?.pushViewController(eventDetailViewController, animated: true);
                    break;
                }
            }
        }
        
        var failureBlock: NSError -> Void = {
            (error: NSError) -> Void in
            println("Error2: \(error)");
        }
        
        eventManagerModel.retrieveUpcomingEvents(successBlock, failure: failureBlock);*/
    }
    
    func setupMenuBarButtonItems() {
        self.navigationItem.leftBarButtonItem = self.leftMenuBarButtonItem()
        
    }
    
    
    func leftMenuBarButtonItem() -> UIBarButtonItem {
        // another way of adding the button but by an icon, will need this soon
        //        return UIBarButtonItem(image: UIImage(named: "menu-icon.png"), style:UIBarButtonItemStyle.Plain, target: self, action: "leftSideMenuButtonPressed:")
        return UIBarButtonItem(title: "Left", style: .Plain, target: self, action: "leftSideMenuButtonPressed:")
        
    }
    
    func leftSideMenuButtonPressed(sender: AnyObject) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({
            self.setupMenuBarButtonItems()
        })
    }
    
    func redirectToLogin() {
        let leftMenuViewController : SideMenuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle:nil)
        let navController : UINavigationController = UINavigationController(rootViewController: LoginViewController(nibName: "LoginViewController", bundle:nil))
        
        let container : MFSideMenuContainerViewController = MFSideMenuContainerViewController.containerWithCenterViewController(navController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
        self.presentViewController(container, animated: true, completion: nil)
    }
    
    
}


