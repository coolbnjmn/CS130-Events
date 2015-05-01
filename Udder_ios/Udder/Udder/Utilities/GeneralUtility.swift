//
//  GeneralUtility.swift
//  Udder
//
//  Created by Collin Yen on 4/30/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class GeneralUtility {
    class func heightForString(text:String, attrs:[NSObject:AnyObject!], width:CGFloat) -> CGFloat {
        var constrainedSize:CGSize = CGSizeMake(width, 999999);
        
        var descriptionString:NSAttributedString = NSAttributedString(string: text, attributes: attrs);
        
        var requiredHeight:CGRect = descriptionString.boundingRectWithSize(constrainedSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading, context: nil);
        
        return ceil(requiredHeight.height);
    }
}
