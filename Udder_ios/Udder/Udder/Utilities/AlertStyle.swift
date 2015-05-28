//
//  AlertStyle.swift
//  Udder
//
//  Created by Collin Yen on 5/28/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class AlertStyle: NSObject, TWMessageBarStyleSheet {

    func backgroundColorForMessageType(type: TWMessageBarMessageType) -> UIColor! {
        return UIColor.backgroundColor();
    }

    func strokeColorForMessageType(type: TWMessageBarMessageType) -> UIColor! {
        return self.textColorForType(type);
    }

    func iconImageForMessageType(type: TWMessageBarMessageType) -> UIImage! {
        var icon:UIImage;
        
        if type == TWMessageBarMessageType.Success {
            icon = Constants.Images.SuccessAlertIcon;
        }
        else {
            icon = Constants.Images.FailureAlertIcon;
        }
        
        return icon;
    }
    
    func titleColorForMessageType(type: TWMessageBarMessageType) -> UIColor! {
        return self.textColorForType(type);
    }
    
    func descriptionColorForMessageType(type: TWMessageBarMessageType) -> UIColor! {
        return self.textColorForType(type);
    }
    
    func textColorForType(type: TWMessageBarMessageType) -> UIColor! {
        if type == TWMessageBarMessageType.Success {
            return UIColor.themeColor();
        }
        else {
            return UIColor.standardRedColor();
        }
    }
}