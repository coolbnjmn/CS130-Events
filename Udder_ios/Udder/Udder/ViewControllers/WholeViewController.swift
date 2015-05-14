//
//  WholeViewController.swift
//  Udder
//
//  Created by shai segal on 4/24/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class WholeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UITextViewDelegate, RegCellDelegate, DateCellDelegate, TimeCellDelegate,WhereCellDelegate,CatCellDelegate, PrivateCellDelegate, tvCellDelegate {
    
    var eventManagerModel:EventManagerModel = EventManagerModel.sharedInstance;

    @IBOutlet weak var ECtable: UITableView!
    @IBOutlet weak var placestable: UITableView!
    
    var places: [AnyObject] = [AnyObject] ()
    var doneplaces: [AnyObject] = [AnyObject] ()
    var cell_title: RegEventCreationTableViewCell = RegEventCreationTableViewCell()
    var cell_start: TimeTableViewCell = TimeTableViewCell()
    var cell_end: TimeTableViewCell = TimeTableViewCell()
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
            if(tableView.tag == 0){
            let row = indexPath.row
            if (cellnames[row] == "textview"){
                return 300
                }}
            return tableView.rowHeight
    }
    
    func findPlaces(){
        var str1:String = "https://maps.googleapis.com/maps/api/place/textsearch/json?query="
        var str2:String = "&sensor=false&key=AIzaSyCZE_8eTEeIfoKXPWmoMb43k4PYHz0BrXY"
        var str3:String = String()
        for character in loc_string {
            if(character == " "){
                str3 += "+"
            }
            else{
                str3 += String(character)
            }
        }
        var final:String = str1+str3+str2
        println(final)
        var url:NSURL = NSURL(string: final)!
        var request:NSURLRequest = NSURLRequest(URL: url)
        var op:AFHTTPRequestOperation = AFHTTPRequestOperation(request: request)
        op.responseSerializer = AFJSONResponseSerializer()
        op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObject) -> Void in
            var results:String = "results"
            self.places=responseObject.objectForKey(results)! as! [(AnyObject)]
           //println("printing places \(self.places) \n\n")
           //put code here
            }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
                println("failure")
        })
         op.start()
    }
    
    func setaddtext(cell:RegEventCreationTableViewCell) {
        title_string = cell.addtext.text
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        else{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
       
    }
    var title_string:String = String()

    func settimetext(cell: TimeTableViewCell) {
        if cell.textLabel?.text == "Start Time"{
            start_date = cell.date!
            if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
            else{
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
        else{
          
            end_date = cell.date!
            if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
            else{
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
    }
    var start_date: NSDate = NSDate()
    var end_date: NSDate = NSDate()
   
    func setwheretext(cell:WhereTableViewCell){
        loc_string = cell.wheretext.text
        self.findPlaces()
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        else{
            self.navigationItem.rightBarButtonItem?.enabled = false
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
        cat_string = cell.cattext.text
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        else{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    var cat_string:String = String()
    func setswitch(cell:PrivateEventCreationTableViewCell){
        priv_bool = cell.Private
        if(!title_string.isEmpty && !loc_string.isEmpty && !cat_string.isEmpty && (start_date.compare(end_date) == NSComparisonResult.OrderedAscending)){
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        else{
            self.navigationItem.rightBarButtonItem?.enabled = false
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


        // Do any additional setup after loading the view.
    }

    func setupMenuBarButtonItems() {
        self.navigationItem.rightBarButtonItem = self.rightMenuBarButtonItem()
        self.navigationItem.rightBarButtonItem?.enabled = false
        
    }
    
    func rightMenuBarButtonItem() -> UIBarButtonItem {
     
        return UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "rightSideMenuButtonPressed:")
        
    }
    
    func rightSideMenuButtonPressed(sender: AnyObject) {
        println(title_string)
        println(loc_string)
        println(cat_string)
        println("\(priv_bool)")
        println("start date \(start_date)")
        println("end date \(end_date)")
        println(des_string)
        
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
        
        eventManagerModel.createEvent(title_string, description: des_string, location: loc_string, startTime: start_date, endTime: end_date, category: cat_string, image: "", isPrivate: priv_bool, success: successBlock, failure: failureBlock);
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
        {return 8}
        else{
            return 4
        }
    }
    
    func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath){
      let row = indexPath.row
        if(tableView.tag == 1){
            self.view.endEditing(true)
            placestable.hidden = true
            cell_title.enable()
            cell_start.enable = true
            cell_end.enable = true
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if(tableView.tag==0){
        if(cellnames[row] == "Title"){
        var cell:RegEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("regcell") as! RegEventCreationTableViewCell
        cell.cellname?.text=cellnames[row]
        cell.addtext?.placeholder = "Ex. Venice Beach Run"
        cell.delegate = self
        cell_title = cell
        return cell
        }
 
        else if (cellnames[row] == "Start Time"){
            var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
            cell.textLabel?.text="Start Time"
            cell.timetext?.placeholder = "04/18/15 4:00 PM"
            cell.delegate = self
            cell_start = cell
            return cell
            
        }
        else if (cellnames[row] == "End Time"){
            var cell:TimeTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("TimeCell") as! TimeTableViewCell
            cell.textLabel?.text="End Time"
            cell.timetext?.placeholder = "04/18/15 6:00 PM"
            cell.delegate = self
            cell_end = cell
            return cell
            
        }
        else if (cellnames[row] == "Location"){ //SHOULD BE LOCATION
            var cell:WhereTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("WhereCell") as! WhereTableViewCell
            cell.wheretext?.placeholder = "Ex. Venice Beach"
            cell.delegate = self
            return cell
            
        }
        else if (cellnames[row] == "Private Event"){
            var cell:PrivateEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("PrivateCell") as! PrivateEventCreationTableViewCell
            cell.cellname?.text=cellnames[row]
            cell.delegate = self
            return cell
            
        }
        else if (cellnames[row] == "Categories"){ //SHOULD BE CATEGORIES
            var cell:CatTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("CatCell") as! CatTableViewCell
            cell.cattext?.placeholder = "Ex. Fitness"
            cell.delegate = self
            return cell
            
        }
        else if (cellnames[row] == "textview"){
            var cell:textviewTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("tvCell") as! textviewTableViewCell
            cell.delegate = self
            return cell
        }
        else {
            var cell:DescriptionEventCreationTableViewCell = self.ECtable.dequeueReusableCellWithIdentifier("DescriptionCell") as! DescriptionEventCreationTableViewCell
            return cell
            }}
        else{
            var cell:regularCell = self.placestable.dequeueReusableCellWithIdentifier("regularCell") as! regularCell
            return cell
        }
    
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
