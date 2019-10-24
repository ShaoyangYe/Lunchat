//
//  Post.swift
//  Lunchat
//
//  Created by 李怡 on 21/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation
import FirebaseAuth
class Post {
    var topic: String?
    var title: String?
    var uid: String?
    var id: String?
    var time: String?
    //    var likes: Dictionary<String, Any>?
    //    var isLiked: Bool?
    var address: String?
    var NumPeople: Int?
    var timestamp: Int?
}

extension Post {
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.id = key
        post.topic = dict["topic"] as? String
        post.title = dict["title"] as? String
        post.address = dict["address"] as? String
        post.uid = dict["uid"] as? String
        post.time = dict["time"] as? String
        //        post.likes = dict["likes"] as? Dictionary<String, Any>
        post.NumPeople = dict["NumPeople"] as? Int
        post.timestamp = dict["timestamp"] as? Int
        return post
    }

    static func transformPostVideo() {

    }
}
//
//import Foundation
//import FirebaseAuth
//class Post {
//    var caption: String?
//    var photoUrl: String?
//    var uid: String?
//    var id: String?
//    var likeCount: Int?
//    var likes: Dictionary<String, Any>?
//    var isLiked: Bool?
//    var ratio: CGFloat?
//    var videoUrl: String?
//    var timestamp: Int?
//}
//
//extension Post {
//    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
//        let post = Post()
//        post.id = key
//        post.caption = dict["caption"] as? String
//        post.photoUrl = dict["photoUrl"] as? String
//        post.videoUrl = dict["videoUrl"] as? String
//        post.uid = dict["uid"] as? String
//        post.likeCount = dict["likeCount"] as? Int
//        post.likes = dict["likes"] as? Dictionary<String, Any>
//        post.ratio = dict["ratio"] as? CGFloat
//        post.timestamp = dict["timestamp"] as? Int
//        if post.likeCount == nil {
//            post.likeCount = 0
//        }
//        if let currentUserId = Auth.auth().currentUser?.uid {
//            if post.likes != nil {
//                post.isLiked = post.likes![currentUserId] != nil
//            }
//        }
//
//        return post
//    }
//
//    static func transformPostVideo() {
//
//    }
//}


