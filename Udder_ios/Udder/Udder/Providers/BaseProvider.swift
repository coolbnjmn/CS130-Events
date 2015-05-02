//
//  BaseProvider.swift
//  Udder
//
//  Created by Collin Yen on 4/29/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

@objc protocol ViewControllerProtocolDelegate {
    func pushViewController(viewController:UIViewController, animated:Bool);
}

class BaseProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    var delegate:ViewControllerProtocolDelegate?;
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Should be implemented by subclass");
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Should be implemented by subclass");
        return UITableViewCell();
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Should be implemented by subclass");
        return
    }
}
