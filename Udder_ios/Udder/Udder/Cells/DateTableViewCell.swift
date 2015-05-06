//
//  DateTableViewCell.swift
//  
//
//  Created by shai segal on 4/24/15.
//
//

import UIKit

@objc protocol DateCellDelegate{
    optional func setactualdate(cell:DateTableViewCell)
}

class DateTableViewCell: UITableViewCell{

    var delegate: DateCellDelegate?
    
    @IBOutlet weak var actualdate: UITextField!
    //actualdate.delegate = self
   
   
    @IBAction func actualdateclicked(sender: UITextField) {
        var DatePickerView  : UIDatePicker = UIDatePicker()
        DatePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = DatePickerView
        //println("god damn")
        DatePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
   
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        actualdate.text = dateFormatter.stringFromDate(sender.date)
        delegate?.setactualdate!(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func textFieldDidEndEditing(textField: UITextField){
        delegate?.setactualdate!(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
