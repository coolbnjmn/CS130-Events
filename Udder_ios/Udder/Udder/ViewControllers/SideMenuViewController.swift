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
        self.tableView.scrollEnabled = false
        self.tableView.alwaysBounceVertical = false
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var cellText: String?;
        
        switch indexPath.row {
        case 0:
            cellText = PFUser.currentUser().objectForKey("full_name") as? String ?? ""
            cell.backgroundColor = UIColor.themeColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.font = UIFont(name: Constants.StandardFormats.kStandardTextFont, size: Constants.StandardFormats.kSideBarNavNameFontSize)
            cell.textLabel?.numberOfLines = 2
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.clipsToBounds = true
            cell.selectionStyle = .None
            
            if (profPic == nil) {
                self.getProfPic()
            }
            if (profPic != nil) {
                profPic = cropToSquare(image: profPic!)
                cell.imageView?.layer.cornerRadius = (profPic?.size.width)!/2.0;
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
            cell.textLabel?.textColor = UIColor.standardRedColor()
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
        let nibNameToSwitchTo:String = "EventTableViewController"
        let navController: UINavigationController?
        
        switch indexPath.row {
        case 0:
            return
        case 1: //Home
            navController = UINavigationController(rootViewController: EventTableViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 2: //MyEvents
            navController = UINavigationController(rootViewController: MyEventsViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 3: //Upcoming Events
            navController = UINavigationController(rootViewController: UpcomingEventsViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 4: //Events Near Me
            // TODO: SWITCH BACK
            navController = UINavigationController(rootViewController: EventsNearMeViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 5: //Pending Invitations
            navController = UINavigationController(rootViewController: PendingInvitationsViewController(nibName: nibNameToSwitchTo, bundle:nil))
            break;
        case 6: //Logout
            
            let alertController = UIAlertController(title: "Logout?", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            alertController.addAction(UIAlertAction(title: "Yes", style:UIAlertActionStyle.Default) {
                UIAlertAction in
                    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
                    appdelegate.FBlogout()
                })
            self.presentViewController(alertController, animated: true, completion: nil)
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
            var imgURLString = "http://graph.facebook.com/" + fid! + "/picture?type=normal" //type=normal
            var imgURL = NSURL(string: imgURLString)
            var imageData = NSData(contentsOfURL: imgURL!)
            profPic = UIImage(data: imageData!)
        }
    }
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
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
