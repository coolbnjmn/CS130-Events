//
//  SeparateTintSegmentedControl.swift
//  Udder
//
//  Created by Collin Yen on 5/1/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class SeparateTintSegmentedControl: UISegmentedControl {
    var selectedTintColor:UIColor = UIColor.whiteColor();
    var unselectedTintColor:UIColor = UIColor.whiteColor();
    
    func configure(selectColor:UIColor, unselectColor:UIColor, textAttrs:[NSObject: AnyObject]) {
        self.selectedTintColor = selectColor;
        self.unselectedTintColor = unselectColor;
        self.tintColor = UIColor.whiteColor();
        
        self.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal);
        self.setTitleTextAttributes(textAttrs, forState: UIControlState.Selected);
    }
    
    func valueChanged() {
        let selectedSegment:Int = self.selectedSegmentIndex;
        
        var selectedView:UIView?;
        var unselectedView:UIView?;
        
        switch selectedSegment {
        case 0:
            selectedView = self.subviews[1] as? UIView;
            unselectedView = self.subviews[0] as? UIView;
        case 1:
            selectedView = self.subviews[0] as? UIView;
            unselectedView = self.subviews[1] as? UIView;
        default:
            break;
        }

        if let validatedSelectedView = selectedView  {
            if let validatedUnselectedView = unselectedView {
                validatedSelectedView.tintColor = self.selectedTintColor;
                validatedUnselectedView.tintColor = self.unselectedTintColor;
            }
        }
    }
}
