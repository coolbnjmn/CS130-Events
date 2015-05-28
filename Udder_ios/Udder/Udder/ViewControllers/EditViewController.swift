//
//  editViewController.swift
//  
//
//  Created by shai segal on 5/23/15.
//
//

import UIKit
import Parse

@objc protocol EditEventProtocolDelegate {
    func updateEvent(eventModel:EventModel);
}

class editViewController: WholeViewController {
    var event:EventModel?
    var location:PlacesModel?
    var delegate:EditEventProtocolDelegate?;
    
    var dateFormatter = NSDateFormatter()
    func setupWithEvent(eventModel:EventModel?) {
        self.event = eventModel
    }
    
    override func submitButtonPressed(sender: AnyObject) {
        println("Controller Title: \(self.title_string)");
        var successBlock: EventModel -> Void = {
            (eventModel: EventModel) -> Void in

            if let delegate = self.delegate {
                 self.delegate!.updateEvent(eventModel);
            }

            self.navigationController?.popViewControllerAnimated(true);
        }
        
        var failureBlock: NSError -> Void = {
            (error: NSError) -> Void in
            println("Error: \(error)");
        }
        
        self.event?.save(self.title_string, description: self.des_string, startDate: self.start_date, endDate: self.end_date, category: self.cat_string, isPrivate: self.priv_bool, location: self.selectedLocation, successBlock: successBlock, failureBlock: failureBlock);
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
            
            switch(row) {
            case 0: //Title
                var cell:RegEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("regcell") as! RegEventCreationTableViewCell
                cell.titleTitleLabel?.text=cellnames[row]
                cell.titleTextField.text = self.title_string
                cell.delegate = self
                cell_title = cell
                cell.selectionStyle = .None
                return cell
                
            case 1: //Start Time
                var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
                cell.timeTitleLabel?.text="Start Time"
                cell.timeInputTextField.text = dateFormatter.stringFromDate(self.start_date)
                cell.delegate = self
                cell_start = cell
                cell.selectionStyle = .None
                return cell
                
            case 2: //End Time
                var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
                cell.timeTitleLabel?.text="End Time"
                cell.timeInputTextField.text = dateFormatter.stringFromDate(self.end_date)
                cell.delegate = self
                cell_end = cell
                cell.selectionStyle = .None
                return cell
                
            case 3: //Location
                var cell:WhereTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("WhereCell") as! WhereTableViewCell
                cell.locationTitleLabel.text = "Location"
                cell.locationInputLabel.text = self.loc_string;
                cell.selectionStyle = UITableViewCellSelectionStyle.None;
                cell_loc = cell
                return cell
             
            case 4: //Categories
                var cell:CatTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("CatCell") as! CatTableViewCell
                cell.categoryTextField.text = self.cat_string
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
                
            case 5: //Private Event
                var cell:PrivateEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("PrivateCell") as! PrivateEventCreationTableViewCell
                cell.cellname?.text=cellnames[row] 
                cell.switchSwitch(self.priv_bool)
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
             
            case 6: //Description Label
                var cell:DescriptionEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("DescriptionCell") as! DescriptionEventCreationTableViewCell
                cell.selectionStyle = .None
                cell.backgroundColor = Constants.Colors.BackgroundGrayColor
                return cell
                
            case 7: //TextView
                var cell:textviewTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("tvCell") as! textviewTableViewCell
                cell.delegate = self
                cell.mytext.text = self.des_string
                cell.my_int = 0
                cell.mytext.textColor = UIColor.blackColor()
                cell.selectionStyle = .None
                return cell
            
            case 8: //Submit Button
                var cell:EventCreationSubmitButtonTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("submitCell") as! EventCreationSubmitButtonTableViewCell
                cell.backgroundColor = Constants.Colors.BackgroundGrayColor
                cell.delegate = self
                submitButton = cell.submitButton
                cell.addButtonAction(self.submitButtonPressed)
                cell.selectionStyle = .None
                cell.submitButton.enabled = true
                return cell

            default:
                return UITableViewCell()
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
