//
//  UIView+Gradient.swift
//  Udder
//
//  Created by Collin Yen on 4/30/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

extension UIView {
    func addGradient() {
        var gradient:CAGradientLayer = CAGradientLayer();
        gradient.frame = self.bounds;
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor];
        self.layer.insertSublayer(gradient, atIndex:0);
    }
}