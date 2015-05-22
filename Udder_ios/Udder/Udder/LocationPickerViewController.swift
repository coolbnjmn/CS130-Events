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
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.None;
        
        self.searchField.delegate = self;
        
        self.tableView.delegate = locationPickerProvider;
        self.tableView.dataSource = locationPickerProvider;
        
//        let timeInfoTableViewCellNib = UINib(nibName: "TimeInfoTableViewCell", bundle: nil);
//        self.infoTableView.registerNib(timeInfoTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kTimeInfoTableViewCell);
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.kStandardTableViewCell);
    }
    
    func fetchData(text:String) {
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
        NSRunLoop.cancelPreviousPerformRequestsWithTarget(self);
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1*Double(NSEC_PER_SEC)));
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.fetchData(textField.text);
        }
        
        return true;
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
