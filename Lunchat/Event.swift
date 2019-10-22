//
//  Event.swift
//  Lunchat
//
//  Created by 杨昱程 on 20/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

import Foundation

class EventModel {
    var eventID: String?
    var host: String?
    var location: String?
    var maxParticipant: Int?
    var past: String?
    var theme: String?
    var time: String?
    var title: String?
}

extension EventModel {
    static func transformEvent(dict: [String: Any], key: String) -> EventModel {
        let event = EventModel()
        event.eventID = dict["eventID"] as? String
        event.host = dict["host"] as? String
        event.location = dict["location"] as? String
        event.maxParticipant = dict["maxParticipant"] as? Int
        event.past = dict["past"] as? String
        event.theme = dict["theme"] as? String
        event.time = dict["time"] as? String
        event.title = dict["title"] as? String
        
        return event
    }
}
