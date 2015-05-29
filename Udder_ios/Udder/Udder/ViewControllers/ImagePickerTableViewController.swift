//
//  ImagePickerTableViewController.swift
//  Udder
//
//  Created by Ari Ekmekji on 5/28/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ImagePickerTableViewController: UITableViewController {
   
    var event:EventModel?
    var imageURLs: [String]?
    var category:String?
    var new_event:Bool?
    
    
    @IBOutlet var imagesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "Pick an Image"
        self.imagesTableView.delegate = self
        self.imagesTableView.dataSource = self
        self.imagesTableView.separatorStyle = .None
        var nib1 = UINib(nibName: "ImagePickerTableViewCell", bundle: nil)
        imagesTableView.registerNib(nib1, forCellReuseIdentifier: "imageCell")
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: UIBarButtonItemStyle.Plain, target: self, action: "goToNextPage")
    }
    
    func setupWithEvent(some_event:EventModel) {
        
        self.event = some_event
        self.category = self.event?.eventCategory ?? "Other"
        let parameters = ["title": self.event?.eventTitle ?? ""]
        
        PFCloud.callFunctionInBackground("manualGetEventPhoto", withParameters: parameters) { results, error in
            if (error == nil) {
                let list:[String] = results as! [String]
                self.imageURLs = [String]()
                for img:String in list {
                    self.imageURLs!.append(img)
                }
            }
            else {
                println(error)
                self.displayDefaultImage()
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.imagesTableView.reloadData()
        }
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading Event Images"
    }
    
    func setAsNewEvent() {
        self.new_event = true
        self.navigationItem.rightBarButtonItem = nil
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
        if (self.imageURLs == nil) {
            return 0
        }
        return 1+(self.imageURLs!.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(self.imageURLs == nil) {
            return UITableViewCell()
        }
        
        let row:Int = indexPath.row
        let cell:ImagePickerTableViewCell = tableView.dequeueReusableCellWithIdentifier("imageCell") as! ImagePickerTableViewCell
        
        if(row == self.imageURLs!.count) {
            cell.configure("", category: self.category!)
        }
        else {
            cell.configure(self.imageURLs![row], category: self.category ?? "Other")
        }
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.StandardFormats.kImageSelectionCellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        
        if(self.imageURLs == nil) {
            return
        }
        
        let row=indexPath.row
        var chosen_image:String = "default"
        if(row < self.imageURLs!.count) {
            chosen_image = imageURLs![row]
        }
        
        var query = PFQuery(className:"Event")
        query.getObjectInBackgroundWithId(event?.eventId) {
            (object, error) -> Void in
            if error != nil {
                println(error)
            } else {
                if let object = object {
                    object["image_url"] = chosen_image
                }
                object.saveInBackgroundWithBlock(nil)
            }
        }
        self.event?.eventImage = chosen_image

        self.goToNextPage()

    }
    
    func goToNextPage() {
        var viewControllers:NSMutableArray = NSMutableArray(array: self.navigationController!.viewControllers);
        viewControllers.removeObjectIdenticalTo(self);
        
        if(self.new_event ?? false) {
            var invitePage:InviteContactTableViewController =  InviteContactTableViewController(nibName: "InviteContactTableViewController", bundle: nil);
            invitePage.setupWithEvent(self.event!);
            viewControllers.addObject(invitePage)
        }
        else {
            var detailPage:EventDetailViewController = viewControllers.lastObject as! EventDetailViewController
            detailPage.updateEvent(self.event!)
        }
        
        self.navigationController?.setViewControllers(viewControllers as [AnyObject], animated: true);
    }
    
    func displayDefaultImage() {
        imageURLs = [String]()
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
