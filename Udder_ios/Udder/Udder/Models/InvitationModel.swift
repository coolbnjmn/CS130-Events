//
//  InvitationModel.swift
//  
//
//  Created by Collin Yen on 5/14/15.
//
//
import Parse

class InvitationModel: BaseModel {
    var invitationObject:PFObject!;
    var invitationResponse: Bool?;
    
    init(invitation:PFObject) {
        super.init();
        
        self.invitationResponse = invitation[Constants.InvitationDatabaseFields.kInvitationResponse] as? Bool;
    }
}
