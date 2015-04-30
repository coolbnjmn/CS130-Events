//
//  BaseEventProvider.swift
//  Udder
//
//  Created by Collin Yen on 4/29/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class BaseEventProvider:BaseProvider {
    var event:EventModel?;
    
    init(eventModel:EventModel?) {
        super.init();
        self.event = eventModel;
    }
}
