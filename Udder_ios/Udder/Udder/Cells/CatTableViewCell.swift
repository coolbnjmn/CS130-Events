//
//  CatTableViewCell.swift
//  
//
//  Created by shai segal on 4/26/15.
//
//

import UIKit

@objc protocol CatCellDelegate{
    optional func setcattext(cell:CatTableViewCell)
}

class CatTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: CatCellDelegate?
    @IBOutlet weak var catlabel: UILabel!
    @IBOutlet weak var cattext: UITextField!
    @IBAction func clickedcattext(sender: UITextField) {
        var PickerView  : UIPickerView = UIPickerView()
        PickerView.delegate = self
        PickerView.dataSource = self
        sender.inputView = PickerView
       // DatePickerView.datePickerMode = UIDatePickerMode.Date
        //sender.inputView = DatePickerView
        //println("god damn")
        //DatePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
 /*   func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        cattext.text = dateFormatter.stringFromDate(sender.date)
    }*/
    
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func numberOfComponentsInPickerView(__pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String!{
            if (row == 0){
                return "Fitness"
                
            }
            else if (row == 1){
                return "Food"
                
            }
            else if (row == 2){
                return "Entertainment"
                
            }
            else if (row == 3){
                return "Music"
                
            }
            else if (row == 4){
                return "Academic"
                
            }
            else if (row == 5){
                return "Social"
                
            }
            else{
                return "Other"
            }
    }
    
    func pickerView(pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int){
            if (row == 0){
                cattext.text? = "Fitness"
                
            }
            else if (row == 1){
                cattext.text? =  "Food"
                
            }
            else if (row == 2){
                cattext.text? =  "Entertainment"
                
            }
            else if (row == 3){
                cattext.text? =  "Music"
                
            }
            else if (row == 4){
                cattext.text? =  "Academic"
                
            }
            else if (row == 5){
                cattext.text? =  "Social"
                
            }
            else{
                cattext.text? =  "Other"
            }
            delegate?.setcattext!(self)
            
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
