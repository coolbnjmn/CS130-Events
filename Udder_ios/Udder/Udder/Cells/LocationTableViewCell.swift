//
//  LocationTableViewCell.swift
//  Udder
//
//  Created by Collin Yen on 4/30/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import MapKit
import Parse

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
    
    func configure(event:EventModel) {
        locationLabel.text = event.eventLocation;

        if let geoCoordinate = event.eventGeoCoordinate {
            let location = CLLocationCoordinate2D(
                latitude: geoCoordinate.latitude,
                longitude: geoCoordinate.longitude
            )
            
            let span = MKCoordinateSpanMake(0.05, 0.05);
            let region = MKCoordinateRegion(center: location, span: span);
            mapView.setRegion(region, animated: true);
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = location;
            
            annotation.title = event.eventLocation;
            annotation.subtitle = "10980 Wellworth Ave"; // TODO: Change this to actual address
            mapView.addAnnotation(annotation);
        }
    }
}