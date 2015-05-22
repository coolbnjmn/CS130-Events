//
//  LocationPickerProvider.swift
//  Udder
//
//  Created by Collin Yen on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

@objc protocol LocationPickerProtocolDelegate {
    func updateWithLocation(location:PlacesModel);
}

class LocationPickerProvider: BaseProvider {
    var locations:NSMutableArray = NSMutableArray();
    var locationPickerDelegate:LocationPickerProtocolDelegate?;
    
    func configure(locations:NSMutableArray) {
        self.locations = locations;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var currentLocation:PlacesModel = locations[indexPath.row] as! PlacesModel;
        
        let cell:LocationPickerTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kLocationPickerTableViewCell) as! LocationPickerTableViewCell;
        
        cell.configure(currentLocation);
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var location:PlacesModel = locations[indexPath.row] as! PlacesModel;
        if let locationPickerDelegate = locationPickerDelegate {
            self.locationPickerDelegate?.updateWithLocation(location);
        }
        self.delegate?.popViewController();
    }
}
