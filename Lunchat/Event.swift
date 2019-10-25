//
//  Event.swift
//  Lunchat
//
//  Created by 杨昱程 on 20/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation

struct Event {
    
    var eventID: String?
    var host: String?
    var location: String?
    var maxParticipants: Int?
    var participants: [String:String]?
    var past: Int?
    var theme: String?
    var time: String?
    var title: String?
    var latitude: String?
    var longitude: String?
    
}

// For registered user
struct Participants {
    
    var id: String?
    var username: String?
    var profileImageUrl: String?
    
}
