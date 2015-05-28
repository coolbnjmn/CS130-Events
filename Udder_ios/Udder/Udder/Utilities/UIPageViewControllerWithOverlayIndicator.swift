//
//  UIPageViewControllerWithOverlayIndicator.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/27/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class UIPageViewControllerWithOverlayIndicator: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        let mainView : UIView = self.view;
        let subviews: [UIView] = mainView.subviews as! [UIView];
        
        for subview : UIView in subviews {
            if subview is UIScrollView {
                subview.frame = self.view.bounds
            } else if subview is UIPageControl {
                if(subview.frame.origin.y > 0) {
                    subview.removeFromSuperview();
                    subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y - 77 - subview.frame.size.height, subview.frame.size.width, subview.frame.size.height)
                    self.view.addSubview(subview)
                }
                
            }
        }
        
        super.viewDidLayoutSubviews();
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
