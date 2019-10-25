//
//  MessageDetailViewController.swift
//  Lunchat
//
//  Created by Kangyun Dou on 7/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MessageDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //列表控件
   
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    //列表数据源
//    var messages:[String] = []
    var messageId: String!
    
    var messages = [Message]()
    
    var message: Message!
    
//    var currentUser: String!

    var recipient: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //设置列表数据源和代理
        tableView.dataSource = self
        tableView.delegate = self
        configureTableView()
                        
        tableView.separatorStyle = .none
        
        
        print("假装")
        
        //增加模拟数据
        
//        for index in 0...19 {
//            messages.append("\(index)")
//        }
        
    
        
        if messageId != "" && messageId != nil {
            print("righthere!!???????why nothing happened ")
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //让列表重新加载数据
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            
            self.moveToBottom()
        }
    }
    
    @objc func keyboardWillShow(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesCell {
            cell.configCell(message: message)
            return cell
            
        } else {
            
            return MessagesCell()
        }
    }
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300.0
        

    }
    
    func loadData() {
        print("loading Data")
        Database.database().reference().child("messages").child(messageId).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.messages.removeAll()
                
                for data in snapshot {
                    print(data)
                    if let postDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let post = Message(messageKey: key, postData: postDict)
                        
                        self.messages.append(post)
                    }
                }
            }
            self.configureTableView()
            self.tableView.reloadData()
        })
    }
    
    func moveToBottom() {
        
        if messages.count > 0  {
            
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        print("sent")
        let userID = Auth.auth().currentUser!.uid

        dismissKeyboard()
        
        if (messageField.text != nil && messageField.text != "") {
            if messageId == nil {
                let post: Dictionary<String, AnyObject> = [
                        "message": messageField.text as AnyObject,
                        "sender": userID as AnyObject
                    ]
                        
                let message: Dictionary<String, AnyObject> = [
                        "lastmessage": messageField.text as AnyObject,
                        "recipient": recipient as AnyObject
                    ]
                        
                let recipientMessage: Dictionary<String, AnyObject> = [
                        "lastmessage": messageField.text as AnyObject,
                        "recipient":userID as AnyObject
                    ]
                        
                messageId = Database.database().reference().child("messages").childByAutoId().key
                        
                let firebaseMessage = Database.database().reference().child("messages").child(messageId).childByAutoId()
                        
                firebaseMessage.setValue(post)
                
            Api.User.REF_CURRENT_USER?.child("messages").child(messageId).setValue(message)
                          
                    
//            Database.database().reference().child("users").child(recipient).child("messages").child(messageId).setValue(recipientMessage)
                
                Database.database().reference().child("users").child(recipient).child("messages").child(messageId).setValue(recipientMessage)
                
//                .observeSingleEvent(of: .value, with:{
//                                   (snapshot) in snapshot.setValue(recipientMessage)
//                })
                
                 print("???")
                    
                                            
                loadData()
                        
                    } else if messageId != "" {
                        loadData()
                        let post: Dictionary<String, AnyObject> = [
                            "message": messageField.text as AnyObject,
                            "sender": userID as AnyObject
                        ]
                        
                        let message: Dictionary<String, AnyObject> = [
                            "lastmessage": messageField.text as AnyObject,
                            "recipient": recipient as AnyObject
                        ]
                        
                        let recipientMessage: Dictionary<String, AnyObject> = [
                            "lastmessage": messageField.text as AnyObject,
                            "recipient": userID as AnyObject
                        ]
                        
                //Firebase:post
                let firebaseMessage = Database.database().reference().child("messages").child(messageId).childByAutoId()
                        
                        firebaseMessage.setValue(post)
                        
                //Firebase:message
            Api.User.REF_CURRENT_USER?.child("messages").child(messageId).setValue(message)

               //Firebase:recipientMessage
//            Database.database().reference().child("users").child(recipient).child("messages").observeSingleEvent(of: .value, with:{
//                    (snapshot) in snapshot.setValue(recipientMessage, forKey: self.messageId)
//                })
                Database.database().reference().child("users").child(recipient).child("messages").child(messageId).setValue(recipientMessage)
                        
    
                
                        loadData()
                    }
                    
                    messageField.text = ""
                }
                
                moveToBottom()
    }
//    @IBAction func backPressed (_ sender: AnyObject) {
//
//        dismiss(animated: true, completion: nil)
//    }

}


//列表数据源和代理
//
//extension MessageDetailViewController:UITableViewDataSource,UITableViewDelegate {
//
//    //列表的行数
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    //返回当前位置Cell
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //获取cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MessageCell
//
//        //返回Cell
//        return cell
//    }
//
//
//
//}
