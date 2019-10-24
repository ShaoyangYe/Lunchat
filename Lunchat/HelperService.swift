//
//  HelperService.swift
//  Lunchat
//
//  Created by 李怡 on 21/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import CoreLocation

struct MyVariables {
    static var yourVariable = 0
}
class HelperService {
//    static func uploadDataToServer(data: Data, videoUrl: URL? = nil, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void) {
//
//        sendDataToDatabase(topic: String, title: String, ratio: ratio, caption: caption, onSuccess: onSuccess)
//    }
//    var eventId = 0
    static func sendDataToDatabase(topic: String, title: String,date: String, time: String, address: String, numberpeople: Int,latitude: String, longtitude: String, onSuccess: @escaping () -> Void) {
//        eventId += 1
        MyVariables.yourVariable += 1
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        
        var currentUserId = currentUser.uid
        var currentUsername = currentUser.displayName
        
//        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//
//        for var word in words {
//            if word.hasPrefix("#") {
//                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
//                let newHashTagRef = Api.HashTag.REF_HASHTAG.child(word.lowercased())
//                newHashTagRef.updateChildValues([newPostId: true])
//            }
//        }
        
        
        
        if currentUsername == nil
        {
            currentUsername = "nothing"
        }
        
        var participantsDic = [currentUserId: currentUsername]
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var dict = ["eventID": MyVariables.yourVariable, "host": currentUserId ,"theme": topic, "title": title, "date": date, "time": time, "location": address, "timestamp": timestamp,"latitude": latitude,"longitude": longtitude,"maxParticipants":numberpeople,"past": 0] as [String : Any]
        
        dict["participants"] = participantsDic
        
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
}
