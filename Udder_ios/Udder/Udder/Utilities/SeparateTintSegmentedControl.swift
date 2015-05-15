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
    
    var leftView:UIView?;
    var rightView:UIView?;
    
    func configure(selectColorLeft:UIColor, selectColorRight:UIColor, unselectColor:UIColor, textAttrs:[NSObject: AnyObject]) {
        self.selectedTintColorLeft = selectColorLeft;
        self.selectedTintColorRight = selectColorRight;
        self.unselectedTintColor = unselectColor;
        
        self.tintColor = UIColor.whiteColor();
        self.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal);
        self.setTitleTextAttributes(textAttrs, forState: UIControlState.Selected);
        
        self.leftView = self.subviews[0] as? UIView;
        self.rightView = self.subviews[1] as? UIView;
    }
    
    func valueChanged() {
        let selectedSegment:Int = self.selectedSegmentIndex;
        
        var selectedView:UIView?;
        var unselectedView:UIView?;
        var selectedColor:UIColor;
        
        switch selectedSegment {
        case 0:
            selectedView = self.rightView;
            unselectedView = self.leftView;
            selectedColor = self.selectedTintColorLeft;
        case 1:
            selectedView = self.leftView;
            unselectedView = self.rightView;
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
    
    func deselectControl() {
        self.tintColor = self.unselectedTintColor;
        self.selectedSegmentIndex = UISegmentedControlNoSegment;
        if let leftView = leftView {
            leftView.tintColor = self.unselectedTintColor;
        }
        
        if let rightView = rightView {
            rightView.tintColor = self.unselectedTintColor;
        }
    }
}
