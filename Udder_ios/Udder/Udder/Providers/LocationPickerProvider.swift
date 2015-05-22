//
//  LocationPickerProvider.swift
//  Udder
//
//  Created by Collin Yen on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class LocationPickerProvider: BaseProvider {
    var locations:NSMutableArray = NSMutableArray();
    
    func configure(locations:NSMutableArray) {
        self.locations = locations;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var currentLocation:PlacesModel = locations[indexPath.row] as! PlacesModel;
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kStandardTableViewCell) as! UITableViewCell;
        
        cell.textLabel?.text = currentLocation.placeLocationName;
        
        return cell
    }
}
