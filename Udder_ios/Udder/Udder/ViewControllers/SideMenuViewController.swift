//
//  SideMenuViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SideMenuViewController: UITableViewController {
    
    var profPic: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 7
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        var cellText: String?;
        
        switch indexPath.row {
        case 0:
            cellText = PFUser.currentUser().objectForKey("full_name") as? String ?? ""
            cellText = cellText! + "\n" + (PFUser.currentUser().objectForKey("email") as? String ?? "");
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = UIColor.blueColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.numberOfLines = 2
            cell.imageView?.backgroundColor = UIColor.blueColor()
            
            if (profPic == nil) {
                self.getProfPic()
            }
            if (profPic != nil) {
                cell.imageView?.image = profPic
            }
            break;
        case 1:
            cellText = "Home";
            break;
        case 2:
            cellText = "My Events";
            break;
        case 3:
            cellText = "Upcoming Events";
            break;
        case 4:
            cellText = "Events Near Me";
            break;
        case 5:
            cellText = "Pending Invitations";
            break;
        case 6:
            cellText = "Logout";
            break;
        default:
            cellText = "";
            break;
        }
        
        cell.textLabel!.text = cellText;

        
        // Configure the cell...
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        let nibNameToSwitchTo: String?
        let navController: UINavigationController?
        
        switch indexPath.row {
        case 0:
            selectedCell.backgroundColor = UIColor.blueColor()
            return
        case 1: //Home
            nibNameToSwitchTo = "EventTableViewController";
            navController = UINavigationController(rootViewController: EventTableViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 2: //MyEvents
            nibNameToSwitchTo = "MyEventsViewController";
            navController = UINavigationController(rootViewController: MyEventsViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 3: //Upcoming Events
            nibNameToSwitchTo = "UpcomingEventsViewController";
            navController = UINavigationController(rootViewController: UpcomingEventsViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 4: //Events Near Me
            nibNameToSwitchTo = "EventsNearMeViewController";
            navController = UINavigationController(rootViewController: EventsNearMeViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 5: //Pending Invitations
            nibNameToSwitchTo = "PendingInvitationsViewController";
            navController = UINavigationController(rootViewController: PendingInvitationsViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 6: //Logout
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
            appdelegate.FBlogout()
            return
        default:
            return
        }

        self.menuContainerViewController.centerViewController = navController
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let regular_height: CGFloat = 50.0
        let larger_height: CGFloat = 100.0
        
        switch indexPath.row {
        case 0:     return larger_height
        case 1:     return regular_height
        case 2:     return regular_height
        case 3:     return regular_height
        case 4:     return regular_height
        case 5:     return regular_height
        case 6:     return regular_height
        default:    return 0
        }
        
    }
    
    func getProfPic() {
        var fid: String? = PFUser.currentUser().objectForKey("facebookId") as? String ?? ""
        if (fid != "") {
        var imgURLString = "http://graph.facebook.com/" + fid! + "/picture?type=small"
        var imgURL = NSURL(string: imgURLString)
        var imageData = NSData(contentsOfURL: imgURL!)
            profPic = UIImage(data: imageData!)
        }
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
