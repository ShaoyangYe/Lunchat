//
//  Event.swift
//  Lunchat
//
//  Created by Jiaqing Chen on 7/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation

class Event: Codable {
    
    var eventID:Int?
    var title:String?
    var time:String?
    var location:String?
    var participants:[Int]?
    var maxParticipants:Int?
    var theme:String?
    var host:Int?
    var past:Int?
    
}
