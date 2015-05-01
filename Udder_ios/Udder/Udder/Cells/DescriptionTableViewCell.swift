//
//  DescriptionTableViewCell.swift
//  Udder
//
//  Created by Collin Yen on 4/29/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    var defaultDescriptionCellFrame:CGRect?;
    
    @IBOutlet weak var descriptionLabel:TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(description:String, shouldShowReadMore:Bool) {
        // Set the default description cell frame to the one created in the xib
        if self.defaultDescriptionCellFrame == nil {
            self.defaultDescriptionCellFrame = self.descriptionLabel.frame;
        }
        
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.text = description;
        
        var attr = [NSFontAttributeName: UIFont(name: Constants.EventDetail.TableConstraints.kDescriptionTextFont, size: Constants.EventDetail.TableConstraints.kDescriptionTextSize)!, NSForegroundColorAttributeName: UIColor.lightBlueColor()];
        
        self.descriptionLabel.truncationTokenString = "    More";
        self.descriptionLabel.truncationTokenStringAttributes = attr;
        
        self.descriptionLabel.sizeToFit();
        
        if !shouldShowReadMore && descriptionLabel.frame.size.height > self.defaultDescriptionCellFrame!.size.height {
            descriptionLabel.frame = self.defaultDescriptionCellFrame!
        }
        
        self.selectionStyle = UITableViewCellSelectionStyle.None;
        
        self.hidden = false;
    }

}
