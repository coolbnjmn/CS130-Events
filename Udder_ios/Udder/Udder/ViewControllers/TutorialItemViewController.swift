//
//  TutorialItemViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/27/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class TutorialItemViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var pageIndex: Int!
    var imageName : String!
    var text : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.imageView.image = UIImage(named: imageName);
        self.textLabel.text = self.text;
        self.textLabel.numberOfLines = 0;
        self.textLabel.sizeToFit()
        self.view.backgroundColor = Constants.Colors.BackgroundGrayColor
        
        self.textLabel.alpha = 0
        self.textLabel.font = UIFont(name: Constants.StandardFormats.kStandardTextFont, size: 18.0)
        
        UIView.animateWithDuration(2, animations: {
            self.textLabel.alpha = 1.0
        })
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
