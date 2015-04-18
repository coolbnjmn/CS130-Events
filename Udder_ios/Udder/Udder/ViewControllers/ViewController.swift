//
//  ViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tapHereButton: UIButton!
    
    @IBAction func tapHereWasPressed(sender: AnyObject) {
        if(self.tapHereButton.backgroundColor == UIColor.whiteColor()) {
            self.tapHereButton.backgroundColor = UIColor.brownColor()
        } else {
            self.tapHereButton.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tapHereButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        self.setupMenuBarButtonItems()
        self.tapHereButton.backgroundColor = UIColor.whiteColor()
    }
    
    func setupMenuBarButtonItems() {
        self.navigationItem.leftBarButtonItem = self.leftMenuBarButtonItem()
        
    }
    
    
    func leftMenuBarButtonItem() -> UIBarButtonItem {
        // another way of adding the button but by an icon, will need this soon
        //        return UIBarButtonItem(image: UIImage(named: "menu-icon.png"), style:UIBarButtonItemStyle.Plain, target: self, action: "leftSideMenuButtonPressed:")
        return UIBarButtonItem(title: "Left", style: .Plain, target: self, action: "leftSideMenuButtonPressed:")
        
    }
    
    func leftSideMenuButtonPressed(sender: AnyObject) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({
            self.setupMenuBarButtonItems()
        })
    }
    
    
}


