//
//  User.swift
//  Lunchat
//
//  Created by Jiaqing Chen on 7/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var userID:Int?
    var name:String?
    var gender:String?
    var registered:[Int]?
    var hosting:[Int]?
    var past:[Int]?
    
}
