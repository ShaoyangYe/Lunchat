//
//  HelperService.swift
//  Lunchat
//
//  Created by 李怡 on 21/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
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
        

        
        let userID:String! = Auth.auth().currentUser!.uid
        var currentUsername :String!
        let ref0 = Database.database().reference().child("users").child(userID).child("username")
        ref0.observeSingleEvent(of: .value) { (snapshot) in
            // Get user value
            currentUsername = (snapshot.value as? String)!
            var participantsDic = [userID: currentUsername]
            let timestamp = Int(Date().timeIntervalSince1970)
            
            var dict = ["eventID": MyVariables.yourVariable, "host": userID ,"theme": topic, "title": title, "date": date, "time": time, "location": address, "timestamp": timestamp,"latitude": latitude,"longitude": longtitude,"maxParticipants":numberpeople,"past": 0] as [String : Any]
            
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
            print(dict)
        }
        
        
    }
}
