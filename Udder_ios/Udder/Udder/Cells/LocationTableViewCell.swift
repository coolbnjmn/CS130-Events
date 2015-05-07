//
//  LocationTableViewCell.swift
//  Udder
//
//  Created by Collin Yen on 4/30/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.clearColor();
        self.backgroundColor = UIColor.clearColor();
        self.selectionStyle = UITableViewCellSelectionStyle.None;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(location:String) {
        locationLabel.text = location;

        let location = CLLocationCoordinate2D(
            latitude: 34.069201,
            longitude: -118.445192
        )

        let span = MKCoordinateSpanMake(0.05, 0.05);
        let region = MKCoordinateRegion(center: location, span: span);
        mapView.setRegion(region, animated: true);
        
        let annotation = MKPointAnnotation();
        annotation.coordinate = location;

        annotation.title = "UCLA";
        annotation.subtitle = "An Udder Event";
        mapView.addAnnotation(annotation);
    }
}