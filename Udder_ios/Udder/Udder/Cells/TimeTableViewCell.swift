//
//  TimeTableViewCell.swift
//  Udder
//
//  Created by shai segal on 4/24/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

@objc protocol TimeCellDelegate{
    optional func settimetext(cell:TimeTableViewCell)
}

class TimeTableViewCell: UITableViewCell {

    var delegate: TimeCellDelegate?
    var date: NSDate?
    var enable: Bool = true
    
    @IBOutlet weak var timelabel: UILabel!
   
    @IBOutlet weak var timetext: UITextField!
    
    @IBAction func timetextclicked(sender: UITextField) {
        var DatePickerView  : UIDatePicker = UIDatePicker()
       // DatePickerView.datePickerMode = UIDatePickerMode.Time
        if(enable){
        sender.inputView = DatePickerView
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        sender.text = dateFormatter.stringFromDate(DatePickerView.date)
        //println("god damn")
            DatePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)}
        else{
            //do nothing
        }
    }
  
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        timetext.text = dateFormatter.stringFromDate(sender.date)
        date = sender.date
        delegate?.settimetext!(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func textFieldDidEndEditing(textField: UITextField){
        delegate?.settimetext!(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }
    
}
