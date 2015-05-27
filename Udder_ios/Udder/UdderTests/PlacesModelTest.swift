//
//  PlacesModelTest.swift
//  Udder
//
//  Created by Collin Yen on 5/26/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import XCTest
import Parse

class PlacesModelTest: XCTestCase {
    
    let constantAddress: String = "address";
    let constantLocationName: String = "name";
    let constantIcon: String = "icon";
    let constantLatitude: Double = 1;
    let constantLongitude: Double = 2;
    let constantCoordinate: PFGeoPoint = PFGeoPoint(latitude: 1, longitude: 2);
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    let locationData:NSDictionary = [
        Constants.GoogleLocationKeys.kName: "name",
        Constants.GoogleLocationKeys.kAddress: "address",
        Constants.GoogleLocationKeys.kIcon: "icon",
        "geometry": [
            "location": [
                "lat": 1,
                "lng": 2
            ]
        ],
        Constants.GoogleLocationKeys.kLatitude: 1,
        Constants.GoogleLocationKeys.kLongitude: 2
    ]
    
    func testPlaceInitializerGivenValues() {
        var placesModel:PlacesModel = PlacesModel(address: constantAddress, geoPoint: constantCoordinate, locationName: constantLocationName);
        
        XCTAssertEqual(placesModel.placeLocationName, constantLocationName, "Location names should match");
        XCTAssertEqual(placesModel.placeAddress!, constantAddress, "Address should match");
        XCTAssertEqual(placesModel.geoPoint!, constantCoordinate, "Coordinate should match");
    }
    
    func testPlaceInitializerGivenDataFromGoogle() {
        var placesModel:PlacesModel? = PlacesModel(object: locationData);
        
        XCTAssertEqual(placesModel!.placeLocationName, constantLocationName, "Location names should match");
        XCTAssertEqual(placesModel!.placeAddress!, constantAddress, "Address should match");
        XCTAssertEqual(placesModel!.geoPoint!.latitude, constantCoordinate.latitude, "Latitudes should match");
        XCTAssertEqual(placesModel!.geoPoint!.longitude, constantCoordinate.longitude, "Longitudes should match");
    }
    
    let locationDataMissingName:NSDictionary = [
        Constants.GoogleLocationKeys.kAddress: "address",
        Constants.GoogleLocationKeys.kIcon: "icon",
        "geometry": [
            "location": [
                "lat": 1,
                "lng": 2
            ]
        ]
    ]
    
    func testPlaceMissingName() {
        var placesModel:PlacesModel? = PlacesModel(object: locationDataMissingName);
        XCTAssertNil(placesModel, "Places model should have failed to initialize");
    }
}
