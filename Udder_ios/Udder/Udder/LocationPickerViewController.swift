//
//  LocationPickerViewController.swift
//  Udder
//
//  Created by Collin Yen on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class LocationPickerViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationPickerProvider = LocationPickerProvider();
    var locationPickerModel = LocationPickerModel();

    var timer: NSTimer? = nil
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.None;
        
        self.searchField.delegate = self;
        
        self.tableView.delegate = locationPickerProvider;
        self.tableView.dataSource = locationPickerProvider;
        
//        let timeInfoTableViewCellNib = UINib(nibName: "TimeInfoTableViewCell", bundle: nil);
//        self.infoTableView.registerNib(timeInfoTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kTimeInfoTableViewCell);
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.kStandardTableViewCell);
    }
    
    func fetchData(timer:NSTimer) {
        var textField = timer.userInfo as! UITextField;
        var text = textField.text;
        var successBlock = {
            (locationArray: NSMutableArray) -> Void in
            println("Success: \(locationArray)");
            self.locationPickerProvider.configure(locationArray);
            self.tableView.reloadData();
        }
        
        var failureBlock = {
            (error: NSError) -> Void in
            println("Error: \(error)");
        }
        
        locationPickerModel.searchForText(text, success: successBlock, failure: failureBlock);
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("fetchData:"), userInfo: textField, repeats: false)
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.locationPickerProvider.configure(NSMutableArray());
        self.tableView.reloadData();
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
