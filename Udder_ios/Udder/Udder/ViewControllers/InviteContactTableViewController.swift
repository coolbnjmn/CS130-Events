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
import Parse

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
    var event : EventModel?
    var attendees: [ContactModel]?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        self.tableView.registerClass(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        
        if (attendees == nil) {
            attendees = [ContactModel]()
        }
        
        let addressBookRef: ABAddressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        if (ABAddressBookGetAuthorizationStatus() == .NotDetermined || ABAddressBookGetAuthorizationStatus() == .Authorized) {
            let block : ABAddressBookRequestAccessCompletionHandler = { ABAddressBookRequestAccessCompletionHandler in
                let addressBook : ABAddressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
                let allPeople : NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
                let nPeople : CFIndex = ABAddressBookGetPersonCount(addressBook)
                
                for record:ABRecordRef in allPeople {
                    var contactPerson: ABRecordRef = record
                    if let validatedName = ABRecordCopyCompositeName(contactPerson) {
                        var contactName: String = validatedName.takeRetainedValue() as String
                        
                        /* Get all the phone numbers this user has */
                        let unmanagedPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty)
                        let phones: ABMultiValueRef = unmanagedPhones.takeRetainedValue()
                        let countOfPhones = ABMultiValueGetCount(phones)
                        
                        // TODO: what to do with multiple phone numbers per contact?
                        for index in 0..<countOfPhones{
                            let label:NSString = ABMultiValueCopyLabelAtIndex(phones, index).takeRetainedValue() as NSString
                            if (label == kABPersonPhoneMobileLabel) {
                                let unmanagedPhone = ABMultiValueCopyValueAtIndex(phones, index)
                                let phone: String = unmanagedPhone.takeRetainedValue() as! String
                                
                                if(!self.alreadyInvited(phone)) {
                                    let contactModel : ContactModel? = ContactModel(name: contactName, phone: phone)
                                    self.contactDataArray.append(contactModel!)
                                }
                                break
                            }
                        }
                    }
                }
                

                self.contactDataArray.sort {a,b in
                    return a.name.localizedCaseInsensitiveCompare(b.name) == .OrderedAscending
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
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

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: UIBarButtonItemStyle.Plain, target: self, action: "inviteContacts:")
        self.navigationItem.hidesBackButton = true
        
    }
    
    func setupWithEvent(eventModel:EventModel?) {
        self.event = eventModel
        self.attendees = self.event?.attendees
    }
    
    func alreadyInvited(phone: String) -> Bool {
        
        if (attendees == nil) {
            attendees = [ContactModel]()
            return false
        }
        
        var num = stripNumber(phone)
        if(count(num) == 10) {
            num = "1" + num
        }
        
        for c:ContactModel in attendees! {
            var c_num = stripNumber(c.phone)
            if(count(c_num) == 10) {
                c_num = "1" + c_num
            }
            
            if(num == c_num) {
                return true
            }
        }
        
        return false
    }
    
    func inviteContacts(sender: AnyObject) {
        
        var invitees = [Dictionary<String, String>]()
        for contact: ContactModel in selectedDataArray {
            var num = stripNumber(contact.phone)
            if(count(num)==11) {
                var idx = advance(num.startIndex,1)
                num = num.substringFromIndex(idx)
            }
            invitees.append(["name": contact.name!, "phoneNumber": num])
        }
        
        var params = Dictionary<String, AnyObject>()
        params.updateValue((event?.eventId)!, forKey: "eventId")
        params.updateValue(invitees, forKey: "invitees")

        println(params)

        PFCloud.callFunctionInBackground("sendInvitations", withParameters: params as [NSObject : AnyObject]) {results, error in
        
        }
        
        var eventDetailViewController:EventDetailViewController =  EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
        eventDetailViewController.setupWithEvent(self.event)
        
        var viewControllers:NSMutableArray = NSMutableArray(array: self.navigationController!.viewControllers);
        viewControllers.removeObjectIdenticalTo(self);
        viewControllers.addObject(eventDetailViewController)
        
        self.navigationController?.setViewControllers(viewControllers as [AnyObject], animated: true);
    }
    
    func setAttendeesList(att: [ContactModel]) {
        self.attendees = att
    }
    
    func stripNumber(num: String) -> String {
        let digits = num.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return "".join(digits)
    }

    func applySearch(sender: AnyObject) {
        self.searchResults.removeAll(keepCapacity: false)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as? ContactCell
       
        println("did deselect")
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
        
        if(indexPath.section == 0) {
            let contactModel = self.selectedDataArray[(indexPath.row)] as ContactModel
            
            cell.textLabel?.text = contactModel.name
            cell.detailTextLabel?.text = contactModel.phone
            cell.accessoryType = .Checkmark
        } else {
            if var searchController = self.mySearchController {
                if(0 == count(searchController.searchBar.text)) {
                    let contactModel = self.contactDataArray[(indexPath.row)] as ContactModel
                    
                    cell.textLabel?.text = contactModel.name
                    cell.detailTextLabel?.text = contactModel.phone
                } else {
                    let contactModel = self.searchResults[(indexPath.row)] as ContactModel
                    
                    cell.textLabel?.text = contactModel.name
                    cell.detailTextLabel?.text = contactModel.phone
                }
            } else {
                let contactModel = self.searchResults[(indexPath.row)] as ContactModel
                
                cell.textLabel?.text = contactModel.name
                cell.detailTextLabel?.text = contactModel.phone
            }
            cell.accessoryType = .None
        }
        

        return cell
    }
}


