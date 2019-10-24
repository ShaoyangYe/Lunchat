//
//  Api.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/10/5.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation
struct Api {
    static var User = UserApi()
    static var Follow = FollowApi()
    static var Post = PostApi()
    static var HashTag = HashTagApi()
    static var Feed = FeedApi()
}
