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

    @IBOutlet var categoryTitleLabel: UILabel!

    @IBOutlet var categoryTextField: UITextField!
    
    @IBAction func clickedcattext(sender: UITextField) {
        sender.text?="Fitness"
        delegate?.setcattext!(self)
        var PickerView  : UIPickerView = UIPickerView()
        PickerView.delegate = self
        PickerView.dataSource = self
        sender.inputView = PickerView
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
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
                categoryTextField.text? = "Fitness"
            }
            else if (row == 1){
                categoryTextField.text? =  "Food"
            }
            else if (row == 2){
                categoryTextField.text? =  "Entertainment"
            }
            else if (row == 3){
                categoryTextField.text? =  "Music"
            }
            else if (row == 4){
                categoryTextField.text? =  "Academic"
            }
            else if (row == 5){
                categoryTextField.text? =  "Social"
            }
            else{
                categoryTextField.text? =  "Other"
            }
            delegate?.setcattext!(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryTextField.borderStyle = UITextBorderStyle.None
        categoryTextField.textAlignment = .Left
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
