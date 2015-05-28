//
//  TutorialViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/27/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let pageTitles = ["Title 1", "Title 2", "Title 3", "Title 4"]
    var images = ["long3.png","long4.png","long1.png","long2.png"]
    var count = 0
    
    var pageViewController : UIPageViewControllerWithOverlayIndicator!
    var pageControl : UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageViewController = UIPageViewControllerWithOverlayIndicator(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
       
        
        self.pageViewController.setViewControllers([self.viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController!.view)
        
        var pageViewRect = self.view.bounds
        pageViewController!.view.frame = pageViewRect
        pageViewController!.didMoveToParentViewController(self)
        self.view.backgroundColor = UIColor.whiteColor();

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> TutorialItemViewController
    {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return TutorialItemViewController()
        }
        
        var vc: TutorialItemViewController = TutorialItemViewController(nibName: "TutorialItemViewController", bundle: nil)
        vc.pageIndex = index
        return vc
    }
    
    // MARK -- Page View Controller Delegate
    
    // MARK: - Page View Controller Data Source
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int // The number of items reflected in the page indicator.
    {
        return self.pageTitles.count;
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int // The selected item reflected in the page indicator.
    {
        return 0;
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
        var vc = viewController as! TutorialItemViewController
        var index = vc.pageIndex as Int
        
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
            
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! TutorialItemViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count)
        {
            return nil
        }

        return self.viewControllerAtIndex(index)
        
    }


//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int // The number of items reflected in the page indicator.
//    {
//        return 3;
//    }
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int // The selected item reflected in the page indicator. 
//    {
//        return self.currentPage;
//    }
   
}
