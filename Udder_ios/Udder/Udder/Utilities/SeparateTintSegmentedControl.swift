//
//  SeparateTintSegmentedControl.swift
//  Udder
//
//  Created by Collin Yen on 5/1/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class SeparateTintSegmentedControl: UISegmentedControl {
    var selectedTintColorLeft:UIColor = UIColor.whiteColor();
    var selectedTintColorRight:UIColor = UIColor.whiteColor();
    var unselectedTintColor:UIColor = UIColor.whiteColor();
    
    func configure(selectColorLeft:UIColor, selectColorRight:UIColor, unselectColor:UIColor, textAttrs:[NSObject: AnyObject]) {
        self.selectedTintColorLeft = selectColorLeft;
        self.selectedTintColorRight = selectColorRight;
        self.unselectedTintColor = unselectColor;
        
        self.tintColor = UIColor.whiteColor();
        self.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal);
        self.setTitleTextAttributes(textAttrs, forState: UIControlState.Selected);
    }
    
    func valueChanged() {
        let selectedSegment:Int = self.selectedSegmentIndex;
        
        var selectedView:UIView?;
        var unselectedView:UIView?;
        var selectedColor:UIColor;
        
        switch selectedSegment {
        case 0:
            selectedView = self.subviews[1] as? UIView;
            unselectedView = self.subviews[0] as? UIView;
            selectedColor = self.selectedTintColorLeft;
        case 1:
            selectedView = self.subviews[0] as? UIView;
            unselectedView = self.subviews[1] as? UIView;
            selectedColor = self.selectedTintColorRight;
        default:
            selectedColor = UIColor.whiteColor();
            break;
        }

        if let validatedSelectedView = selectedView  {
            if let validatedUnselectedView = unselectedView {
                validatedSelectedView.tintColor = selectedColor;
                validatedUnselectedView.tintColor = self.unselectedTintColor;
            }
        }
    }
}
