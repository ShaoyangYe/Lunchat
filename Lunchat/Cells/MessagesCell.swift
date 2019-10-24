//
//  MessagesCell.swift
//  Lunchat
//
//  Created by Kangyun Dou on 9/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var recievedMessageLbl: UILabel!

    @IBOutlet weak var recievedMessageView: UIView!

    @IBOutlet weak var sentMessageLbl: UILabel!

    @IBOutlet weak var sentMessageView: UIView!
    
    
    var message: Message!
    //uid of the currentUser
//    var currentUser = Api.User.CURRENT_USER
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message: Message) {
        let userID = Auth.auth().currentUser!.uid

        self.message = message

        if message.sender == userID {

            sentMessageView.isHidden = false

            sentMessageLbl.text = message.message

            recievedMessageLbl.text = ""

            recievedMessageView.isHidden = true

        } else {

            sentMessageView.isHidden = true
            
            sentMessageLbl.text = ""

            recievedMessageLbl.text = message.message

            recievedMessageView.isHidden = false
            
        }
    }

}
