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
    
    @IBOutlet var timeTitleLabel: UILabel!
    @IBOutlet var timeInputTextField: UITextField!
    
    @IBAction func timetextclicked(sender: UITextField) {
        var DatePickerView  : UIDatePicker = UIDatePicker()
       // DatePickerView.datePickerMode = UIDatePickerMode.Time
        if(enable){
        sender.inputView = DatePickerView
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        sender.text = dateFormatter.stringFromDate(DatePickerView.date)
        DatePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)}
        else{
            //do nothing
        }
    }
  
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        timeInputTextField.text = dateFormatter.stringFromDate(sender.date)
        date = sender.date
        delegate?.settimetext!(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeInputTextField.borderStyle = UITextBorderStyle.None

    }

    
    func textFieldDidEndEditing(textField: UITextField){
        delegate?.settimetext!(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }
    
}
