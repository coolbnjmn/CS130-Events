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

class LocationTableViewCell: UITableViewCell{
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var directionsButton: UIButton!
    
    var event:EventModel?

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
        self.event = event
        var placesModel:PlacesModel = event.locationObject;
        
        locationLabel.text = placesModel.placeLocationName;
        
        if let address = placesModel.placeAddress {
            addressLabel.text = placesModel.placeAddress;
        }
        else {
            addressLabel.hidden = true;
        }


        if let geoCoordinate = placesModel.geoPoint {
            let location = CLLocationCoordinate2D(
                latitude: geoCoordinate.latitude,
                longitude: geoCoordinate.longitude
            )
            
            let span = MKCoordinateSpanMake(0.05, 0.05);
            let region = MKCoordinateRegion(center: location, span: span);
            mapView.setRegion(region, animated: true);
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = location;
            
            annotation.title = placesModel.placeLocationName;
            annotation.subtitle = placesModel.placeAddress; // TODO: Change this to actual address
            mapView.addAnnotation(annotation);
        }
    }
    
    @IBAction func openMap(sender: AnyObject) {
        if(self.event != nil) {
            var placesModel:PlacesModel = self.event!.locationObject
            
            if let geoCoordinate = placesModel.geoPoint {
                let latitute:CLLocationDegrees = geoCoordinate.latitude
                let longitute:CLLocationDegrees = geoCoordinate.longitude
               
                let regionDistance:CLLocationDistance = 10000
                var coordinates = CLLocationCoordinate2DMake(latitute, longitute)
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                var options = [
                    MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span),
                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                ]
                var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                var mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "\(placesModel.placeLocationName)"
                mapItem.openInMapsWithLaunchOptions(options)
            }
        }
    }

}