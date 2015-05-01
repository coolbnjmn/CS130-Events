//
//  PhoneNumberViewController.swift
//  Udder
//
//  Created by Matthew Clark on 4/30/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Step 1 of 2"
        var nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor(red: (86/255), green: (206/255), blue: (106/255), alpha: 1.0)
        nav?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        NSLog("Made it to phone")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
