//
//  EventModel.swift
//  Udder
//
//  Created by Collin Yen on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AddressBookUI
import Foundation

class EventModel: BaseModel {
    var eventId: String!;
    var eventTitle: String!;
    var eventDescription: String!;
    var locationObject: PlacesModel!;
    var eventStartTime: NSDate!;
    var eventEndTime: NSDate!;
    var eventImage: String!;
    var eventHost: PFUser!;
    var eventCategory: String!;
    var eventInvitees: NSArray?;
    var eventPrivate: Bool!;
    var eventInvitation: InvitationModel?; // The invitation received by the current user for the event
    var eventObject: PFObject!; // The parse event object
    
    var phonebookContacts: Dictionary<String, String>?
    var facebookFriends: NSMutableArray?
    var attendees: [ContactModel]?
    
    init?(eventObject: PFObject, invitation: PFObject) {
        super.init();
        
        self.setupEvent(eventObject);
        self.setupInvitation(invitation);
        
        // Check to make sure all required fields are set
        if (self.eventTitle == nil || self.eventStartTime == nil || self.eventEndTime == nil || self.eventHost == nil) {
            return nil;
        }
    }
    
    init?(eventObject: PFObject) {
        super.init();
        self.setupEvent(eventObject);
        
        // Check to make sure all required fields are set
        if (self.eventTitle == nil || self.eventStartTime == nil || self.eventEndTime == nil || self.eventHost == nil) {
            return nil;
        }
    }
    
    func setupInvitation(invitation: PFObject) {
        self.eventInvitation = InvitationModel(invitation: invitation);
    }
    
    func setupEvent(eventObject:PFObject) {
        self.eventObject = eventObject;
        self.eventId = eventObject.objectId;
        
        if let tempTitle = eventObject[Constants.EventDatabaseFields.kEventTitle] as? String {
            self.eventTitle = tempTitle;
        }
        
        var geoCoordinate = eventObject[Constants.EventDatabaseFields.kEventGeoCoordinate] as? PFGeoPoint;
        var location = eventObject[Constants.EventDatabaseFields.kEventLocation] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        var address = eventObject[Constants.EventDatabaseFields.kEventAddress] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        
        self.locationObject = PlacesModel(address: address, geoPoint: geoCoordinate, locationName: location);
        
        self.eventDescription = eventObject[Constants.EventDatabaseFields.kEventDescription] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        
        self.eventImage = eventObject[Constants.EventDatabaseFields.kEventImageURL] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        
        if let tempStartTime = eventObject[Constants.EventDatabaseFields.kEventStartTime] as? NSDate {
            self.eventStartTime = tempStartTime;
        }
        
        // TODO: Set default event end time to one hour
        if let tempEventTime = eventObject[Constants.EventDatabaseFields.kEventEndTime] as? NSDate {
            self.eventEndTime = tempEventTime;
        }
        
        if let tempEventHost = eventObject[Constants.EventDatabaseFields.kEventHost] as? PFUser {
            self.eventHost = tempEventHost;
        }
        
        self.eventCategory = eventObject[Constants.EventDatabaseFields.kEventCategory] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        
        self.eventPrivate = eventObject[Constants.EventDatabaseFields.kEventPrivate] as? Bool ?? false;
    }
    
    func updateInvitationResponse(response: Bool, success: () -> Void, failure: NSError -> Void) {
        // If there already is an invitation then update the response of the invitation
        if let eventInvitation = self.eventInvitation {
            var invitationObject:PFObject = eventInvitation.invitationObject;
            invitationObject[Constants.InvitationDatabaseFields.kInvitationResponse] = response;
            invitationObject.saveInBackgroundWithBlock({ (isSuccessful, error) -> Void in
                if isSuccessful {
                    eventInvitation.invitationResponse = response;
                    success();
                }
                else {
                    failure(error);
                }
            });
        }
        // If there is no invitatin then create one for the event
        else {
            self.createInvitation(response, success: success, failure: failure);
        }
    }
    
    // Helper functions
    func createInvitation(response: Bool, success: () -> Void, failure: NSError -> Void) {
        var invitation = PFObject(className: Constants.DatabaseClass.kInvitationClass);
        invitation[Constants.InvitationDatabaseFields.kInvitationEvent] = self.eventObject;
        invitation[Constants.InvitationDatabaseFields.kInvitationUser] = PFUser.currentUser();
        invitation[Constants.InvitationDatabaseFields.kInvitationResponse] = response;
        
        invitation.saveInBackgroundWithBlock { (isSuccessful, error) -> Void in
            if isSuccessful {
                var invitationModel:InvitationModel = InvitationModel(invitation: invitation);
                self.eventInvitation = invitationModel;
                success();
            }
            else {
                println("Unable to create invitation: \(error)");
                failure(error);
            }
        }
    }
    
    func printEvent() {
        println("Event ID: \(self.eventId)");
        println("Title: \(self.eventTitle)");
        println("Location: \(self.locationObject)");
        println("Description: \(self.eventDescription)");
        println("Image: \(self.eventImage)");
        println("Start Time: \(self.eventStartTime)");        
        
        println("Host: \(self.eventHost)");
        println("Category: \(self.eventCategory)");
        println("Is Private: \(self.eventPrivate)");
    }
    
    func getAttendeesIfNeeded(success: Void -> Void, alert:UIAlertController -> Void) {
    
        if (phonebookContacts == nil) {
            
            let contactServer: Void -> Void = {
                for (phone, name) in self.phonebookContacts! {
                    println(phone + ": " + name)
                }
                println("Total of \(self.phonebookContacts!.count) contacts found")
                
                self.getFBFriends(success)
            }
            
            self.getPhonebookContacts(contactServer, presentAlert: alert)
        }
        
        //Don't ever reach here?
//        else if (self.attendees == nil) {
//            self.contactServerForEventAttendees(success)
//        }
    }
    
    func getPhonebookContacts(success: Void -> Void, presentAlert: UIAlertController -> Void) {
        let addressBookRef: ABAddressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        
        if (ABAddressBookGetAuthorizationStatus() == .NotDetermined || ABAddressBookGetAuthorizationStatus() == .Authorized) {
            self.phonebookContacts = Dictionary<String,String>()
            
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
                            let unmanagedPhone = ABMultiValueCopyValueAtIndex(phones, index)
                            var phone: String = unmanagedPhone.takeRetainedValue() as! String
                            
                            if(index == 0) {
                                phone = self.stripNumber(phone)
                                if(count(phone) == 10) {
                                    phone = "1" + phone
                                }
                                self.phonebookContacts?.updateValue(contactName, forKey: phone)
                            }
                        }
                    }
                }
                
                success()
            }
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef, block)
        } else {
            var alert = UIAlertController(title: "Please let us use your contacts.", message: "So you can invite your friends! Go to settings now!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            presentAlert(alert)
            success()
        }
    }
    
    func contactServerForEventAttendees(success: Void -> Void) {
        if (attendees == nil) {
            
            let parameters = ["eventId": eventId]
            PFCloud.callFunctionInBackground("getAttendees", withParameters: parameters) { results, error in
                if error != nil {
                    
                }
                else {
                    
                    let list:[PFObject] = results as! [PFObject]
                    self.attendees = [ContactModel]()
                    for user:PFObject in list {
                        var user_name: String = user.objectForKey("user").objectForKey("full_name") as? String ?? ""
                        let user_phone: String = "1" + (user.objectForKey("user").objectForKey("phoneNumber") as? String ?? "")
                        let user_fbid: String = user.objectForKey("user").objectForKey("facebookId") as? String ?? ""
                        
                        let isContact: Bool = (self.phonebookContacts?[user_phone] != nil) ?? false
                        let isFriend: Bool = self.facebookFriends?.containsObject(user_fbid) ?? false
                        
                        //Prefer name in your address book to their FB name
                        if(isContact) {
                            user_name = self.phonebookContacts![user_phone]!
                        }
                        
                        self.attendees?.append(ContactModel(name: user_name, phone: user_phone, fb: user_fbid, inPhoneBook: isContact, fbFriend: isFriend)!)
                    }
                    
//                    self.attendees.sort({$0.name < $1.name})
//                            if($0.fbFriend && $0.inPhoneBook && (!$1.fbFriend || !$1.inPhoneBook))
//                                return true
//                            else if ($1.fbFriend && $1.inPhoneBook && (!$0.fbFriend || !$0.inPhoneBook))
//                                return false
//                            else if ($0.inPhoneBook && !$1.inPhoneBook)
//                                return true
//                            else if ($1.inPhoneBook && !$0.inPhoneBook)
//                                return false
//                            else if ($0.fbFriend && !$1.fbFriend)
//                                return true
//                            else if ($1.fbFriend && !$0.fbFriend)
//                                return false
//                            else
//                                return $0.name < $1.name
//                    })
                    
                    success()
                }
            }
        }
    }
    
    func getFBFriends(success: Void -> Void) {
  
//        FBRequestConnection.startForMyFriendsWithCompletionHandler({
//            (conn:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//                println("Received response with FB friends")
//                if(error != nil) {
//                    let friendObjects:[NSDictionary] = result.objectForKey("data") as! [NSDictionary]
//                    self.facebookFriends = NSMutableArray(capacity: friendObjects.count)
//                    for friend:NSDictionary in friendObjects {
//                        self.facebookFriends!.addObject(friend.objectForKey("id") ?? "")
//                    }
//                    println("Found a total of \(self.facebookFriends!.count) Facebook friends")
//                }
//                self.contactServerForEventAttendees(success)
//            })
//        println("Finished sending FB request, waiting for response")
        
        
//        var friendsRequest:FBRequest = FBRequest.requestForMyFriends()
//        friendsRequest.startWithCompletionHandler({(conn, result, error) in
//            println("it worked")
//        })
        
        
        self.contactServerForEventAttendees(success)
        
    }
    
    func stripNumber(num: String) -> String {
        let digits = num.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return "".join(digits)
    }
    
    func save(title:String, description:String, startDate:NSDate, endDate:NSDate, category:String, isPrivate:Bool, location:PlacesModel?, successBlock: EventModel -> Void, failureBlock: NSError -> Void) {
        
        var changedEvent = self.eventObject;
        changedEvent[Constants.EventDatabaseFields.kEventTitle] = title;
        changedEvent[Constants.EventDatabaseFields.kEventDescription] = description;
        changedEvent[Constants.EventDatabaseFields.kEventStartTime] = startDate;
        changedEvent[Constants.EventDatabaseFields.kEventEndTime] = endDate;
        changedEvent[Constants.EventDatabaseFields.kEventCategory] = category;
        changedEvent[Constants.EventDatabaseFields.kEventPrivate] = isPrivate;
        
        if let location = location {
            changedEvent[Constants.EventDatabaseFields.kEventLocation] = location.placeLocationName;
            
            if let coordinate = location.geoPoint {
                changedEvent[Constants.EventDatabaseFields.kEventGeoCoordinate] = coordinate;
            }
            else {
                changedEvent[Constants.EventDatabaseFields.kEventGeoCoordinate] = NSNull();
            }
            
            changedEvent[Constants.EventDatabaseFields.kEventAddress] = location.placeAddress ?? "";
        }
        println("Title: \(changedEvent[Constants.EventDatabaseFields.kEventTitle])");
        
        changedEvent.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            self.eventObject = changedEvent;
            
            if success {
                var newEvent:EventModel? = EventModel(eventObject: changedEvent);
                if let newEvent = newEvent {
                    successBlock(newEvent);
                }
                else {
                    var error:NSError = NSError(domain: "Unable to generate event model", code: 1, userInfo: nil);
                    failureBlock(error);
                }
            }
            else {
                failureBlock(error);
            }
        }
    }
    
}