//
//  InviteContactTableViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/2/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import AddressBookUI
import UIKit

import Foundation

extension Array {
    func indexOfObject(object : AnyObject) -> NSInteger {
        return self._bridgeToObjectiveC().indexOfObject(object)
    }
    
    mutating func removeObject(object : AnyObject) {
        for var index = self.indexOfObject(object); index != NSNotFound; index = self.indexOfObject(object) {
            self.removeAtIndex(index)
        }
    }
}

class InviteContactTableViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate, UISearchResultsUpdating {
    
    var contactDataArray : Array<ContactModel> = []
    var mySearchController : UISearchController?
    var searchResults : Array<ContactModel> = []
    var selectedResultsIndices : [NSIndexPath]?
    var selectedDataArray : Array<ContactModel> = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        let addressBookRef: ABAddressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        if (ABAddressBookGetAuthorizationStatus() == .NotDetermined || ABAddressBookGetAuthorizationStatus() == .Authorized) {
            let block : ABAddressBookRequestAccessCompletionHandler = { ABAddressBookRequestAccessCompletionHandler in
                let addressBook : ABAddressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
                let allPeople : NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
                let nPeople : CFIndex = ABAddressBookGetPersonCount(addressBook)
                
                for record:ABRecordRef in allPeople {
                    var contactPerson: ABRecordRef = record
                    var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
                    
                    /* Get all the phone numbers this user has */
                    let unmanagedPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty)
                    let phones: ABMultiValueRef = unmanagedPhones.takeRetainedValue()
                    let countOfPhones = ABMultiValueGetCount(phones)
                    
                    // TODO: what to do with multiple phone numbers per contact?
                    for index in 0..<countOfPhones{
                        let unmanagedPhone = ABMultiValueCopyValueAtIndex(phones, index)
                        let phone: String = unmanagedPhone.takeRetainedValue() as! String
                        
                        if(index == 0) {
                            let contactModel : ContactModel? = ContactModel(name: contactName, phone: phone)
                            
                            self.contactDataArray.append(contactModel!)
                        }
                    }
                }
                
                self.tableView.reloadData()

            }
           
            ABAddressBookRequestAccessWithCompletion(addressBookRef, block)
        } else {
            var alert = UIAlertController(title: "Please let us use your contacts.", message: "So you can invite your friends! Go to settings now!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }

        self.tableView.allowsMultipleSelection = true
        
        self.mySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal

            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()


    }
    
    func applySearch(sender: AnyObject) {
        self.searchResults.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", self.mySearchController!.searchBar.text)
        let filteredArray = self.contactDataArray.filter({
            if var name:String = $0.name {
                return name.lowercaseString.hasPrefix(self.mySearchController!.searchBar.text.lowercaseString)
            }
            return false
        })
        
        if(filteredArray.count != 0) {
            self.searchResults = filteredArray
        }
        
        if var refreshControl = self.refreshControl {
            refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.applySearch(self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Invite these people"
        } else {
            return "Contacts"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0) {
            return self.selectedDataArray.count
        } else {
            if var searchController = self.mySearchController {
                if(0 == count(searchController.searchBar.text)) {
                    return self.contactDataArray.count
                } else {
                    return self.searchResults.count
                }
            }
            
            return self.contactDataArray.count

        }
        
    }
    
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! UITableViewCell
        println("did deselect")
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! UITableViewCell
        println("select row")
        
        if(indexPath.section == 0) {
            var tmp : ContactModel = self.selectedDataArray[indexPath.row]
            self.contactDataArray.append(tmp)
            self.selectedDataArray.removeObject(tmp)
            
            if(self.mySearchController?.searchBar.text != "") {
                self.mySearchController?.active = false
            }
        } else if(indexPath.section == 1 && self.mySearchController?.searchBar.text == ""){
            var tmp : ContactModel = self.contactDataArray[indexPath.row]
            self.selectedDataArray.append(tmp)
            self.contactDataArray.removeObject(tmp)
        } else {
            var tmp : ContactModel = self.searchResults[indexPath.row]
            self.selectedDataArray.append(tmp)
            self.contactDataArray.removeObject(tmp)
            self.mySearchController?.active = false
        }
        self.tableView.reloadData()

        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! UITableViewCell
        
        if(indexPath.section == 0) {
            let contactModel = self.selectedDataArray[(indexPath.row)] as ContactModel
            
            cell.textLabel?.text = contactModel.name
            cell.accessoryType = .Checkmark
        } else {
            if var searchController = self.mySearchController {
                if(0 == count(searchController.searchBar.text)) {
                    let contactModel = self.contactDataArray[(indexPath.row)] as ContactModel
                    
                    cell.textLabel?.text = contactModel.name
                } else {
                    let contactModel = self.searchResults[(indexPath.row)] as ContactModel
                    
                    cell.textLabel?.text = contactModel.name
                }
            } else {
                let contactModel = self.searchResults[(indexPath.row)] as ContactModel
                
                cell.textLabel?.text = contactModel.name
            }
            cell.accessoryType = .None
        }
        

        return cell
    }
}


