//
//  LocationPickerTableViewCell.swift
//  Udder
//
//  Created by Collin Yen on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class LocationPickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func configure(location:PlacesModel) {
        let iconString = location.placeIcon ?? "";
        var imageUrl:NSURL = NSURL(string: iconString)!;
        
        self.locationImage.sd_setImageWithURL(imageUrl, placeholderImage: Constants.PlaceHolders.LocationImage);
        
        self.locationNameLabel.text = location.placeLocationName;
        
        var address:String = location.placeAddress ?? "";
        self.addressLabel.text = address;
    }
}
