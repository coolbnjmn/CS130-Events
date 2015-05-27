//
//  WholeViewController.swift
//  Udder
//
//  Created by shai segal on 4/24/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import MapKit



class WholeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UITextViewDelegate,RegCellDelegate, DateCellDelegate, TimeCellDelegate,CatCellDelegate, PrivateCellDelegate, tvCellDelegate, LocationPickerProtocolDelegate {
    
    struct CreateTableSegment {
        static let kSegmentLocation = 3;
    }
    
    var eventManagerModel:EventManagerModel = EventManagerModel.sharedInstance;

    @IBOutlet weak var ECtable: UITableView!
    @IBOutlet weak var placestable: UITableView!
    
    var set_placesTable: Int = 0
    var moveApple: Int = 0
    var places_add: [PlacesModel] = [PlacesModel] ()
    var places_loc: CLLocation = CLLocation ()
    var submitButton:UIButton?
    
    var selectedLocation:PlacesModel?;
    
    var cell_title: RegEventCreationTableViewCell = RegEventCreationTableViewCell()
    var cell_start: TimeTableViewCell = TimeTableViewCell()
    var cell_end: TimeTableViewCell = TimeTableViewCell()
    var cell_loc: WhereTableViewCell = WhereTableViewCell()
    var cell_arr:[UITableViewCell] = [UITableViewCell]()
    
    func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        self.view.backgroundColor = Constants.Colors.BackgroundGrayColor
        tableView.scrollEnabled = false
        if(tableView.tag == 0){
            let row = indexPath.row
            if (row==7){
                return Constants.EventDetail.TableConstraints.kEventCreationDescriptionCellHeight
            }
            else if (row == 8) {
                return 10000
            }
        }

        return tableView.rowHeight
    }
    
    func setaddtext(cell:RegEventCreationTableViewCell) {
        title_string = cell.titleTextField?.text ?? ""
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.submitButton?.enabled = true
        }
        else{
            self.submitButton?.enabled = false
        }
       
    }
    var title_string:String = String()

    func settimetext(cell: TimeTableViewCell) {
        if cell.timeTitleLabel.text == "Start Time"{
            start_date = cell.date!
            if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
                self.submitButton?.enabled = true
            }
            else{
                self.submitButton?.enabled = false
            }
        }
        else{
          
            end_date = cell.date!
            if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
                self.submitButton?.enabled = true
            }
            else{
                self.submitButton?.enabled = false
            }
        }
    }
    var start_date: NSDate = NSDate()
    var end_date: NSDate = NSDate()
   
    func setwheretext(cell:WhereTableViewCell){
        placestable.reloadData()
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.submitButton?.enabled = true
        }
        else{
            self.submitButton?.enabled = false
        }
    }
    func placesTableHidden(){
        placestable.hidden = false
        //here want to disable all cells of of ECtable
        cell_title.disable()
        cell_start.enable = false
        cell_end.enable = false
    }
    var loc_string:String = String()
    func setcattext(cell:CatTableViewCell){
        cat_string = cell.categoryTextField.text
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.submitButton?.enabled = true
        }
        else{
            self.submitButton?.enabled = false
        }
    }
    var cat_string:String = String()
    func setswitch(cell:PrivateEventCreationTableViewCell){
        priv_bool = cell.Private
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.submitButton?.enabled = true
        }
        else{
            self.submitButton?.enabled = false
        }
    }
    var priv_bool:Bool = true
    func up(){
         self.view.frame.origin.y -= 200
    }
    func down(cell: textviewTableViewCell){
        self.view.frame.origin.y += 200
        des_string = cell.mytext.text
    }
    func save(cell: textviewTableViewCell){
        des_string = cell.mytext.text
    }
    var des_string:String = String()
    
    var my_int:Int = 1
    var lat:CLLocationDegrees = 0.0
    var long:CLLocationDegrees = 0.0
    
    let cellnames = ["Title", "Start Time", "End Time", "Location", "Categories","Private Event","Description", "textview"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ECtable.editing = false
        ECtable.dataSource = self
        ECtable.delegate = self
        placestable.dataSource = self
        placestable.delegate = self
        placestable.hidden = true
        var nav = self.navigationController?.navigationBar

        self.navigationItem.title = "Create Event";
        
        self.setupMenuBarButtonItems()

        self.ECtable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.placestable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        
        var nib = UINib (nibName: "RegEventCreationTableViewCell", bundle: nil)
        ECtable.registerNib(nib, forCellReuseIdentifier: "regcell")
        var nib1a = UINib (nibName: "regularCell", bundle: nil)
        placestable.registerNib(nib1a, forCellReuseIdentifier: "regularCell")
        
        var nib1 = UINib (nibName: "DescriptionEventCreationTableViewCell", bundle: nil)
        ECtable.registerNib(nib1, forCellReuseIdentifier: "DescriptionCell")
        
        var nib2 = UINib (nibName: "ButtonCreationEventTableViewCell", bundle: nil)
        ECtable.registerNib(nib2, forCellReuseIdentifier: "ButtonCell")
        
        var nib3 = UINib (nibName: "PrivateEventCreationTableViewCell", bundle: nil)
        ECtable.registerNib(nib3, forCellReuseIdentifier: "PrivateCell")
        
        var nib4 = UINib (nibName: "DateTableViewCell", bundle: nil)
        ECtable.registerNib(nib4, forCellReuseIdentifier: "DateCell")
        
        var nib5 = UINib (nibName: "TimeTableViewCell", bundle: nil)
        ECtable.registerNib(nib5, forCellReuseIdentifier: "TimeCell")
        
        var nib6 = UINib (nibName: "WhereTableViewCell", bundle: nil)
        ECtable.registerNib(nib6, forCellReuseIdentifier: "WhereCell")
        
        var nib7 = UINib (nibName: "CatTableViewCell", bundle: nil)
        ECtable.registerNib(nib7, forCellReuseIdentifier: "CatCell")
        
        var nib8 = UINib (nibName: "textviewTableViewCell", bundle: nil)
        ECtable.registerNib(nib8, forCellReuseIdentifier: "tvCell")
        
        var nib9 = UINib(nibName: "EventCreationSubmitButtonTableViewCell", bundle: nil)
        ECtable.registerNib(nib9, forCellReuseIdentifier: "submitCell")


        // Do any additional setup after loading the view.
    }

    func setupMenuBarButtonItems() {
        self.navigationItem.rightBarButtonItem = self.rightMenuBarButtonItem()
        self.navigationItem.rightBarButtonItem?.enabled = true
        
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func rightMenuBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelPressed:")
    }
    
    func cancelPressed(sender: AnyObject) {
        self.popViewController()
    }
    
    func submitButtonPressed(sender: AnyObject) {
        var successBlock: EventModel -> Void = {
            (eventModel: EventModel) -> Void in
            var invitePage:InviteContactTableViewController =  InviteContactTableViewController(nibName: "InviteContactTableViewController", bundle: nil);
            invitePage.setupWithEvent(eventModel);
            
            var viewControllers:NSMutableArray = NSMutableArray(array: self.navigationController!.viewControllers);
            viewControllers.removeObjectIdenticalTo(self);
            viewControllers.addObject(invitePage);
            self.navigationController?.setViewControllers(viewControllers as [AnyObject], animated: true);
        }
        
        var failureBlock: NSError -> Void = {
            (error: NSError) -> Void in
            println("Error: \(error)");
        }
        
        eventManagerModel.createEvent(title_string, description: des_string, locationObject: self.selectedLocation!, startTime: start_date, endTime: end_date, category: cat_string, image: "", isPrivate: priv_bool, success: successBlock, failure: failureBlock);
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if(tableView.tag==0)
        {return 1}
        else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(tableView.tag==0)
        {return 9}
        else{
            return 4
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
      let row = indexPath.row
        if(tableView.tag == 1){
            if(set_placesTable == 0)
            {
                //do nothing
            }
            else{
            self.view.endEditing(true)
            placestable.hidden = true
            cell_title.enable()
            cell_start.enable = true
            cell_end.enable = true
            //places_loc = places_add[row].location
            println(places_loc.coordinate.latitude)
            println(places_loc.coordinate.longitude)
            }
        }
        else {
            if (row == CreateTableSegment.kSegmentLocation) {
                var locationPickerViewController = LocationPickerViewController(nibName: "LocationPickerViewController", bundle: nil);
                locationPickerViewController.invokerViewController = self;
                self.pushViewController(locationPickerViewController, animated: true);
                
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        ["Title", "Start Time", "End Time", "Location", "Categories","Private Event","Description", "textview"]
        let row = indexPath.row
        if(tableView.tag==0){
            
            switch(row) {
                
            case 0: //Title
                var cell:RegEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("regcell") as! RegEventCreationTableViewCell
                
                cell.titleTitleLabel.text=cellnames[row]
                cell.titleTextField.placeholder = "Ex: Venice Beach Run"
                cell.delegate = self
                cell_title = cell
                cell.selectionStyle = .None
                return cell
            
            case 1: //Start Time
                var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
                cell.timeTitleLabel.text="Start Time"
                cell.timeInputTextField.placeholder = "04/18/15 4:00 PM"
                cell.delegate = self
                cell_start = cell
                cell.selectionStyle = .None
                return cell
                
            case 2: //End Time
                var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
                cell.timeTitleLabel.text="End Time"
                cell.timeInputTextField.placeholder = "04/18/15 6:00 PM"
                cell.delegate = self
                cell_end = cell
                cell.selectionStyle = .None
                return cell
                
            case 3: //Location
                var cell:WhereTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("WhereCell") as! WhereTableViewCell
                
                cell.locationTitleLabel.text = "Location"
                cell.locationInputLabel.text = self.selectedLocation?.placeLocationName;
                cell.selectionStyle = UITableViewCellSelectionStyle.None;
                cell_loc = cell
                return cell
              
            case 4: //Categories
                var cell:CatTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("CatCell") as! CatTableViewCell
                cell.categoryTextField?.placeholder = "Ex. Fitness"
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
                
            case 5: //Private
                var cell:PrivateEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("PrivateCell") as! PrivateEventCreationTableViewCell
                cell.cellname?.text=cellnames[row]
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
                
            case 6: //Description Label
                var cell:DescriptionEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("DescriptionCell") as! DescriptionEventCreationTableViewCell
                cell.backgroundColor = Constants.Colors.BackgroundGrayColor
                cell.selectionStyle = .None
                return cell
                
            case 7: //TextView
                var cell:textviewTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("tvCell") as! textviewTableViewCell
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
                
            case 8: //Submit Button
                var cell:EventCreationSubmitButtonTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("submitCell") as! EventCreationSubmitButtonTableViewCell
                cell.backgroundColor = Constants.Colors.BackgroundGrayColor
                cell.delegate = self
                submitButton = cell.submitButton
                cell.addButtonAction(submitButtonPressed)
                cell.selectionStyle = .None
                cell.submitButton.enabled = false
                return cell
                
                
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }


    // MARK: Location picker delegate
    func updateWithLocation(location: PlacesModel) {
        self.selectedLocation = location;
        self.loc_string = location.placeLocationName;
        self.ECtable.reloadData();
        
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.submitButton?.enabled = true
        }
        else{
            self.submitButton?.enabled = false
        }
    }

}
