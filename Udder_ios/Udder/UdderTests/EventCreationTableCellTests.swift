//
//  EventCreationTableCellTests.swift
//  Udder
//
//  Created by shai segal on 5/28/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import XCTest

class EventCreationTableCellTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    func testECTableCellsLayout() {
        
        //Make sure that the Event Creation Table is there and test it
        let datasource:WholeViewController = WholeViewController(nibName:"WholeViewController", bundle:nil)
        datasource.loadView()
        XCTAssertNotNil(datasource.ECtable, "ECtable is nil");
        let numberOfRows = datasource.tableView(datasource.ECtable, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 9, "9 rows in number of rows");
        
        //Testing RegEventCreationTableViewCell
        datasource.ECtable.registerNib(UINib(nibName: "RegEventCreationTableViewCell", bundle: NSBundle(forClass:RegEventCreationTableViewCell.classForCoder())), forCellReuseIdentifier: "regcell")
        let firstRowIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let firstRowCell = datasource.tableView(datasource.ECtable, cellForRowAtIndexPath: firstRowIndexPath) as!RegEventCreationTableViewCell
        XCTAssertNotNil(firstRowCell, "First Row Cell is not nil")
        XCTAssertNotNil(firstRowCell.titleTitleLabel, "Title title label is not nil")
        XCTAssertTrue(firstRowCell.titleTitleLabel.text == "Title", "Title title label is Title")
        XCTAssertLessThan(firstRowCell.titleTitleLabel.frame.size.width, datasource.view.frame.size.width, "Title title label is in bounds")
        //Test putting long title in cell's textview
        firstRowCell.titleTextField.text = "this should be a really really really really really really really really really long text"
        XCTAssertEqual(firstRowCell.titleTextField.text,"this should be a really really really really really really really really really long text", "checking set string correctly before testing bounds")
        XCTAssertLessThan(firstRowCell.titleTextField.frame.size.width, datasource.view.frame.size.width, "Title title text field is in bounds")
        
        //Testing TimeTableViewCell
        datasource.ECtable.registerNib(UINib(nibName: "TimeTableViewCell", bundle: NSBundle(forClass:TimeTableViewCell.classForCoder())), forCellReuseIdentifier: "TimeCell")
        let secondRowIndexPath = NSIndexPath(forRow:1, inSection: 0)
        let secondRowCell = datasource.tableView(datasource.ECtable, cellForRowAtIndexPath: secondRowIndexPath) as! TimeTableViewCell
        XCTAssertNotNil(secondRowCell, "Second Row Cell is not nil")
        XCTAssertNotNil(secondRowCell.timeTitleLabel, "Time title label is not nil")
        XCTAssertTrue(secondRowCell.timeTitleLabel.text == "Start Time", "Time title label is Start Time")
        XCTAssertLessThan(secondRowCell.timeTitleLabel.frame.size.width, datasource.view.frame.size.width, "Time title label is in bounds")
        //Test putting long time in cell's textview
        secondRowCell.timeInputTextField.text = "this should be a really really really really really really really really really long text"
        XCTAssertEqual(secondRowCell.timeInputTextField.text,"this should be a really really really really really really really really really long text", "checking set string correctly before testing bounds")
        XCTAssertLessThan(secondRowCell.timeInputTextField.frame.size.width, datasource.view.frame.size.width, "Time text field is in bounds")
        
        //Testing WhereTableViewCell
        datasource.ECtable.registerNib(UINib(nibName: "WhereTableViewCell", bundle: NSBundle(forClass:WhereTableViewCell.classForCoder())), forCellReuseIdentifier: "WhereCell")
        let thirdRowIndexPath = NSIndexPath(forRow: 3, inSection: 0)
        let thirdRowCell = datasource.tableView(datasource.ECtable, cellForRowAtIndexPath: thirdRowIndexPath) as! WhereTableViewCell
        XCTAssertNotNil(thirdRowCell, "Third Row Cell is not nil")
        XCTAssertNotNil(thirdRowCell.locationTitleLabel, "Where title label is not nil")
        XCTAssertTrue(thirdRowCell.locationTitleLabel.text == "Location", "Where title label is Location")
        XCTAssertLessThan(thirdRowCell.locationTitleLabel.frame.size.width, datasource.view.frame.size.width, "Where title label is in bounds")
        //Test putting long time in cell's textview
        thirdRowCell.locationInputLabel.text = "this should be a really really really really really really really really really long text"
        XCTAssertTrue(thirdRowCell.locationInputLabel.text == "this should be a really really really really really really really really really long text", "checking set string correctly before testing bounds")
        XCTAssertLessThan(thirdRowCell.locationInputLabel.frame.size.width, datasource.view.frame.size.width, "Where input text field is in bounds")
        
        //Testing CatTableViewCell
        datasource.ECtable.registerNib(UINib(nibName: "CatTableViewCell", bundle: NSBundle(forClass:CatTableViewCell.classForCoder())), forCellReuseIdentifier: "CatCell")
        let fourthRowIndexPath = NSIndexPath(forRow: 4, inSection: 0)
        let fourthRowCell = datasource.tableView(datasource.ECtable, cellForRowAtIndexPath: fourthRowIndexPath) as! CatTableViewCell
        XCTAssertNotNil(fourthRowCell, "Fourth Row Cell is not nil")
        XCTAssertNotNil(fourthRowCell.categoryTitleLabel, "Cat(egory) title label is not nil")
        XCTAssertTrue(fourthRowCell.categoryTitleLabel!.text == "Category", "Cat(egory) title label is Category")
        XCTAssertLessThan(fourthRowCell.categoryTitleLabel!.frame.size.width, datasource.view.frame.size.width, "Category title label is in bounds")
        //Test putting long time in cell's textview
        fourthRowCell.categoryTextField.text = "this should be a really really really really really really really really really long text"
        XCTAssertTrue(fourthRowCell.categoryTextField.text == "this should be a really really really really really really really really really long text", "checking set string correctly before testing bounds")
        XCTAssertLessThan(fourthRowCell.categoryTextField.frame.size.width, datasource.view.frame.size.width, "Category text field is in bounds")
        
        //Testing PrivateEventCreationTableViewCell
        datasource.ECtable.registerNib(UINib(nibName: "PrivateEventCreationTableViewCell", bundle: NSBundle(forClass:PrivateEventCreationTableViewCell.classForCoder())), forCellReuseIdentifier: "PrivateCell")
        let fifthRowIndexPath = NSIndexPath(forRow: 5, inSection: 0)
        let fifthRowCell = datasource.tableView(datasource.ECtable, cellForRowAtIndexPath: fifthRowIndexPath) as! PrivateEventCreationTableViewCell
        XCTAssertNotNil(fifthRowCell, "Fifth Row Cell is not nil")
        XCTAssertNotNil(fifthRowCell.cellname, "Private title label is not nil")
        XCTAssertTrue(fifthRowCell.cellname!.text == "Private Event", "Private title label is Category")
        XCTAssertLessThan(fifthRowCell.cellname!.frame.size.width, datasource.view.frame.size.width, "Private title label is in bounds")
        
        //Testing DescriptionEventCreationTableViewCell
        datasource.ECtable.registerNib(UINib(nibName: "DescriptionEventCreationTableViewCell", bundle: NSBundle(forClass:DescriptionEventCreationTableViewCell.classForCoder())), forCellReuseIdentifier: "DescriptionCell")
        let sixthRowIndexPath = NSIndexPath(forRow: 6, inSection: 0)
        let sixthRowCell = datasource.tableView(datasource.ECtable, cellForRowAtIndexPath: sixthRowIndexPath) as! DescriptionEventCreationTableViewCell
        XCTAssertNotNil(sixthRowCell, "Sixth Row Cell is not nil")
        XCTAssertNotNil(sixthRowCell.descriptionTitleLabel, "Description title label is not nil")
        XCTAssertTrue(sixthRowCell.descriptionTitleLabel!.text == "Description", "Description title label is Category")
        XCTAssertLessThan(sixthRowCell.descriptionTitleLabel!.frame.size.width, datasource.view.frame.size.width, "Description title label is in bounds")
        
        //Testing textviewTableViewCell
        datasource.ECtable.registerNib(UINib(nibName: "textviewTableViewCell", bundle: NSBundle(forClass:textviewTableViewCell.classForCoder())), forCellReuseIdentifier: "tvCell")
        let seventhRowIndexPath = NSIndexPath(forRow: 7, inSection: 0)
        let seventhRowCell = datasource.tableView(datasource.ECtable, cellForRowAtIndexPath: seventhRowIndexPath) as! textviewTableViewCell
        //Test putting long time in cell's textview
        seventhRowCell.mytext.text = "this should be a really really really really really really really really really long text"
        XCTAssertTrue(seventhRowCell.mytext.text == "this should be a really really really really really really really really really long text", "checking set string correctly before testing bounds")
        XCTAssertLessThan(seventhRowCell.mytext.frame.size.width, datasource.view.frame.size.width, "Description text field is in bounds")
    }
    


}
