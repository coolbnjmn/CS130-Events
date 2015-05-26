//
//  editViewController.swift
//  
//
//  Created by shai segal on 5/23/15.
//
//

import UIKit
import Parse

class editViewController: WholeViewController {
    var event:EventModel?
    var location:PlacesModel?
    
    var dateFormatter = NSDateFormatter()
    func setupWithEvent(eventModel:EventModel?) {
        self.event = eventModel
    }
    
    override func rightSideMenuButtonPressed(sender: AnyObject) {
        var query = PFQuery(className: Constants.DatabaseClass.kEventClass)
        query.getObjectInBackgroundWithId(event?.eventId) { (changedEvent:PFObject!, error:NSError!) -> Void in
            if error != nil{
                println("houston we have a problem")
            }
            else if let changedEvent = changedEvent{
                changedEvent[Constants.EventDatabaseFields.kEventTitle] = self.title_string
                changedEvent[Constants.EventDatabaseFields.kEventDescription] = self.des_string;
                changedEvent[Constants.EventDatabaseFields.kEventStartTime] = self.start_date;
                changedEvent[Constants.EventDatabaseFields.kEventEndTime] = self.end_date;
                changedEvent[Constants.EventDatabaseFields.kEventCategory] = self.cat_string;
                changedEvent[Constants.EventDatabaseFields.kEventPrivate] = self.priv_bool;
                changedEvent[Constants.EventDatabaseFields.kEventLocation] = self.selectedLocation!.placeLocationName;
                changedEvent[Constants.EventDatabaseFields.kEventGeoCoordinate] = self.selectedLocation!.geoPoint;
                changedEvent[Constants.EventDatabaseFields.kEventAddress] = self.selectedLocation!.placeAddress;
                changedEvent.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    if(success){
                        println("should have saved")
                    }
                    else{
                        println("wtf")
                    }
                })
            }
        }
        var homePage:EventTableViewController =  EventTableViewController(nibName: "EventTableViewController", bundle: nil);
        var viewControllers:NSMutableArray = NSMutableArray(array: self.navigationController!.viewControllers);
        viewControllers.removeObjectIdenticalTo(self);
        viewControllers.addObject(homePage);
        self.navigationController?.setViewControllers(viewControllers as [AnyObject], animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Event";
        self.navigationItem.rightBarButtonItem?.enabled = true
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        self.title_string = event!.eventTitle!
        self.start_date = event!.eventStartTime!
        self.end_date = event!.eventEndTime!
        self.cat_string = event!.eventCategory!
        self.priv_bool = event!.eventPrivate!
        self.des_string = event!.eventDescription!
        self.loc_string = event!.locationObject!.placeLocationName!
        self.selectedLocation = event!.locationObject!
        // Do any additional setup after loading the view.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if(tableView.tag==0){
            if(cellnames[row] == "Title"){
                var cell:RegEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("regcell") as! RegEventCreationTableViewCell
                cell.cellname?.text=cellnames[row]
                cell.addtext.text = self.title_string
                cell.delegate = self
                cell_title = cell
                return cell
            }
                
            else if (cellnames[row] == "Start Time"){
                var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
                cell.textLabel?.text="Start Time"
                cell.timetext.text = dateFormatter.stringFromDate(self.start_date)
                cell.delegate = self
                cell_start = cell
                return cell
                
            }
            else if (cellnames[row] == "End Time"){
                var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
                cell.textLabel?.text="End Time"
                cell.timetext.text = dateFormatter.stringFromDate(self.end_date) 
                cell.delegate = self
                cell_end = cell
                return cell
                
            }
            else if (cellnames[row] == "Location"){
                var cell:WhereTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("WhereCell") as! WhereTableViewCell
                cell.locationLabel.text = self.loc_string; 
                cell.selectionStyle = UITableViewCellSelectionStyle.None;
                cell_loc = cell
                return cell
                
            }
            else if (cellnames[row] == "Private Event"){
                var cell:PrivateEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("PrivateCell") as! PrivateEventCreationTableViewCell
                cell.cellname?.text=cellnames[row] 
                cell.switchSwitch(self.priv_bool)
                cell.delegate = self
                return cell
                
            }
            else if (cellnames[row] == "Categories"){
                var cell:CatTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("CatCell") as! CatTableViewCell
                cell.cattext.text = self.cat_string
                cell.delegate = self
                return cell
                
            }
            else if (cellnames[row] == "textview"){
                var cell:textviewTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("tvCell") as! textviewTableViewCell
                cell.delegate = self
                cell.mytext.text = self.des_string
                cell.my_int = 0
                cell.mytext.textColor = UIColor.blackColor()
                return cell
            }
            else {
                var cell:DescriptionEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("DescriptionCell") as! DescriptionEventCreationTableViewCell
                return cell
            }
        }
        return UITableViewCell();
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
