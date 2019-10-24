//
//  User.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/10/5.
//  Copyright © 2019 MobileTeam. All rights reserved.
//


import Foundation

class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
    var eduBackground: String?
    var school: String?
    var major: String?
    var company: String?
    var position: String?
    var currentResidence: String?
    var originalResidence: String?
}

extension UserModel {
    static func transformUser(dict: [String: Any], key: String) -> UserModel {
        let user = UserModel()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        
        user.eduBackground = dict["eduBackground"] as? String
        user.school = dict["school"] as? String
        user.major = dict["major"] as? String
        user.company = dict["company"] as? String
        user.position = dict["position"] as? String
        user.currentResidence = dict["currentResidence"] as? String
        user.originalResidence = dict["originalResidence"] as? String
        
        return user
    }
}
