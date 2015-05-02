//
//  BaseViewController.swift
//  Udder
//
//  Created by Collin Yen on 5/2/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ViewControllerProtocolDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushViewController(viewController: UIViewController, animated:Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated);
    }

}
