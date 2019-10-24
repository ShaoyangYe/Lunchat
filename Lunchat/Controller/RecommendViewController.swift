//
//  RecommendViewController.swift
//  Lunchat
//
//  Created by 杨昱程 on 21/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseAuth
import MapKit

class RecommendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    private var dateCellExpanded: Bool = false
    var uid : String!
    var username: String!
    var dataSource = [[String:String]()]
    var collectedFlag = Bool()
    var result = [[String:String]()]
    var tableView = UITableView()
    var ref: DatabaseReference!
    var refreshAction = UIRefreshControl()
    var eventDetail:EventDetailViewController?
    var expandCell: Int?
    var eventID: String!
    override func viewDidAppear(_ animated: Bool) {
        // Read data from firebase
        getData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: UIScreen.main.bounds.height-256), style: .plain)
        tableView.backgroundColor = UIColor.white;
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.bounces = false
         //创建刷新控件
        getData()
//        self.result = self.dataSource
//        self.tableView.reloadData()
//        self.view.addSubview(self.tableView)
    }

    //MARK: UITableViewDataSource
    // cell的个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.count
    }
    // UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "testCellID"
        var cell:LCTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? LCTableViewCell
        if cell==nil {
            cell = LCTableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
//        print(self.result)
        let dict:Dictionary = self.result[indexPath.row]
        cell?.titleLabel.text = dict["title"]
        cell?.themeLabel.text = dict["theme"]
        cell?.themeLabel.adjustsFontSizeToFitWidth = true
//        cell?.locationLabel.text = location
        let maxNumber = dict["MaxParticipant"]
        cell?.participant.text = dict["participant"]!+"/"+maxNumber!
        cell?.timeLabel.text = dict["time"]
        cell?.locationLabel.text = dict["location"]!
        cell?.eventID = dict["eventID"]
        cell?.latitude = dict["latitude"]
        cell?.longtitude = dict["longtitude"]
        collectedFlag =  (dict["collected"]! as NSString).boolValue
        cell?.collecteButton.setImage(UIImage(named: "video_btn_collect40HL"), for: .normal)
        cell?.uid = self.uid
        cell?.collecteButton.setImage(UIImage(named: "video_btn_collected40"), for: .selected)
        cell?.selectionStyle = .none
        if collectedFlag{
            cell?.collecteButton.isSelected = true
        }
        else{
            cell?.collecteButton.isSelected = false
        }
//        cell?.collecteButton.addTarget(self, action: #selector(buttonAction(button:)),for:.touchUpInside)
        return cell!
    }
    
    //MARK: UITableViewDelegate
    // 设置cell高度
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    // 选中cell后执行此方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != self.expandCell  {
            // remove last view
            self.tableView.viewWithTag(97)?.removeFromSuperview()
            self.tableView.viewWithTag(98)?.removeFromSuperview()
            self.tableView.viewWithTag(99)?.removeFromSuperview()
            self.expandCell = indexPath.row
            if let ratableCell = tableView.cellForRow(at: indexPath) as? LCTableViewCell {
                // set participant
                let part_num:Int = Int(self.result[indexPath.row]["participant"]!)!
//                let participantLabel = UITextView(frame: CGRect(x: 10, y: 110, width: view.bounds.width-240, height: 200))
                let participantLabel = UILabel(frame: CGRect(x: 10, y: 110, width: view.bounds.width-240, height: 200))
 
                let markattch = NSTextAttachment()
                markattch.image = UIImage(named: "no-user-image-square")//初始化图片
                markattch.bounds = CGRect(x: 0, y: -2, width: 17, height: 17) //初始化图片的 bounds
                let markattchStr = NSAttributedString(attachment: markattch)

                let paraph = NSMutableParagraphStyle()
                //将行间距设置为5
                paraph.lineSpacing = 15
                let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.paragraphStyle: paraph]
                let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.paragraphStyle: paraph]
                var names = ""
                let attributedString1 = NSMutableAttributedString(string:names, attributes:attrs1)
                for i in 0..<part_num{
                    names = self.result[indexPath.row]["participant"+String(i)]!
                    names = " "+names + "\n"
                    let attributedString2 = NSMutableAttributedString(string:names, attributes:attrs2)
                    attributedString2.insert(markattchStr, at: 0)
                    attributedString1.append(attributedString2)
                }
                participantLabel.attributedText = attributedString1
                participantLabel.tag = 98
                participantLabel.numberOfLines = 0
                participantLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                ratableCell.addSubview(participantLabel)
                // set map
                let mapView=MKMapView.init(frame:CGRect.init(x: view.bounds.width-210, y:110 , width:200 , height:200 ))
                    mapView.tag = 99
                let objectAnnotation = MKPointAnnotation()
                let latitude = (self.result[indexPath.row]["latitude"]! as NSString).doubleValue
                let longitude = (self.result[indexPath.row]["longitude"]! as NSString).doubleValue
                objectAnnotation.coordinate = CLLocation(latitude: latitude,
                longitude: longitude).coordinate
                objectAnnotation.title = self.result[indexPath.row]["location"]
                //设置点击大头针之后显示的描述
                objectAnnotation.subtitle = self.result[indexPath.row]["title"]
                mapView.addAnnotation(objectAnnotation)
                let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let center:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
                let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                span: currentLocationSpan)
                mapView.setRegion(currentRegion, animated: true)
                mapView.layer.cornerRadius = 15
                ratableCell.addSubview(mapView)
                // add button
                let button = UIButton(frame: CGRect.init(x: 20, y:320 , width:view.bounds.width-40 , height:40 ))
                if self.result[indexPath.row].values.contains(self.uid){
                    button.backgroundColor = UIColor.blue
                    button.setTitle("Cancel", for: .normal)
                    self.eventID = self.result[indexPath.row]["eventID"]
                    button.addTarget(self, action: #selector(self.cancel(tapGes:)), for: .touchDown)
                }
                else{
                    button.backgroundColor = UIColor.red
                    button.setTitle("Join", for: .normal)
                    self.eventID = self.result[indexPath.row]["eventID"]
                    button.addTarget(self, action: #selector(self.join(tapGes:)), for: .touchDown)
                }
                button.tag = 97
                button.layer.cornerRadius = 10
                ratableCell.addSubview(button)
            }
        } else {
            self.expandCell = -1
            if let ratableCell = tableView.cellForRow(at: indexPath) as? LCTableViewCell {
                // instead of telling tableView to reload this cell, just configure here
                // the changed data, e.g.:
                ratableCell.viewWithTag(97)?.removeFromSuperview()
                ratableCell.viewWithTag(98)?.removeFromSuperview()
                ratableCell.viewWithTag(99)?.removeFromSuperview()
            }
        }

            tableView.beginUpdates()
            tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == self.expandCell {
                return 370
            } else {
                return 100
            }
    }
    // 点击按钮
    @objc private func buttonAction(button : UIButton) {
        button.isSelected = !button.isSelected
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func currentTime() -> String {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
        
        // GMT时间 转字符串，直接是系统当前时间
        
        return dateformatter.string(from: Date())
        
    }
}


extension RecommendViewController : searchDelegate{
    func transmitString(context: String){
         if context == "" {
                self.result = self.dataSource
           } else {
               
               // 匹配用户输入的前缀，不区分大小写
               self.result = []
               
                for arr in self.dataSource {
                   
                    if ((arr["title"]?.lowercased().contains(context.lowercased()))!) {
                           self.result.append(arr)
                       }
               }
                for arr in self.dataSource {
                          
                    if ((arr["theme"]?.lowercased().contains(context.lowercased()))!) {
                        if !self.result.contains(arr){
                            self.result.append(arr)
                        }
                    }
                }
           }
        self.tableView.reloadData()
    }
}



extension RecommendViewController{
    
    func getData()  {
        self.uid = Auth.auth().currentUser?.uid
        self.tableView.viewWithTag(97)?.removeFromSuperview()
        self.tableView.viewWithTag(98)?.removeFromSuperview()
        self.tableView.viewWithTag(99)?.removeFromSuperview()
        self.expandCell = -1
        view.viewWithTag(100)?.removeFromSuperview()
        ProgressHUD.show("Waiting...", interaction: false)
        var appointmentData = [[String:String]]()
        var dict = [Dictionary<String,Any>]()
        
        let ref0 =  Database.database().reference().child("users").child(self.uid).child("username")
        ref0.observeSingleEvent(of: .value) { (snapshot) in
          // Get user value
              self.username = snapshot.value as? String
          }
        
        let ref = Database.database().reference().child("events")
        ref.observeSingleEvent(of: .value) { (snapshot) in
              // Get user value
              let events = snapshot.value as? Dictionary<String,Any>
//                print(value)
                for (key, value) in events!{
                    var transformed_events = [String:String]()
                    let dicValue = value as! Dictionary<String,Any>
                    transformed_events["title"] = dicValue["title"] as! String
                    transformed_events["theme"] = dicValue["theme"] as! String
                    transformed_events["location"] = dicValue["location"] as! String
                    var participants = [String:String]()
                    var num:Int = 0
                    participants = dicValue["participants"] as! [String:String]
                    for i in participants{
                        transformed_events[String(num)] = i.key
                        let user:String = "participant"+String(num)
                        transformed_events[user] = i.value
                        num = num + 1
                    }
                    transformed_events["participant"] = String(participants.count)
                    transformed_events["MaxParticipant"] = String(dicValue["maxParticipants"] as! Int)
                    transformed_events["time"] = dicValue["time"] as! String
                    transformed_events["latitude"] = dicValue["latitude"] as! String
                    transformed_events["longitude"] = dicValue["longitude"] as! String
                    if participants.keys.contains(self.uid){
                        transformed_events["collected"] = "true"
                    }
                    else{
                        transformed_events["collected"] = "false"
                    }
                    transformed_events["eventID"] = key
                    appointmentData.append(transformed_events)
                }
            appointmentData = appointmentData.sorted(by: { (Obj1, Obj2) -> Bool in
               let Obj1_time = Obj1["time"] ?? ""
               let Obj2_time = Obj2["time"] ?? ""
               return (Obj1_time.localizedCaseInsensitiveCompare(Obj2_time) == .orderedAscending)
            })
            self.result = appointmentData
            self.dataSource = appointmentData
            print("reload")
            self.tableView.reloadData()
            self.tableView.tag = 100
            self.view.addSubview(self.tableView)
            
            ProgressHUD.dismiss()
            }
    }
    @objc private func join(tapGes : UITapGestureRecognizer){
         Database.database().reference().child("events").child(self.eventID).observeSingleEvent(of: .value) { (snapshot) in
        // Get user value
            let dicValue = snapshot.value as! Dictionary<String,Any>
            var participants = [String:String]()
            var num:Int = 0
            participants = dicValue["participants"] as! [String:String]
            let currentNum = participants.count
            let MaxNum = dicValue["maxParticipants"] as! Int
            if currentNum < MaxNum{
                Database.database().reference().child("events").child(self.eventID).child("participants/\(self.uid!)").setValue(self.username)
                let alert = UIAlertController(title: "Success", message: "You have been added to this chat", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {
                    ACTION in
                    print("你点击了OK")
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                self.getData()
            }
            else{
                let alert = UIAlertController(title: "Full Members", message: "Sorry there's no enogh space", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {
                    ACTION in
                    print("你点击了OK")
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                self.getData()
            }
        }
    }
    @objc private func cancel(tapGes : UITapGestureRecognizer){
        Database.database().reference().child("events").child(self.eventID).observeSingleEvent(of: .value) { (snapshot) in
              // Get user value
            let dicValue = snapshot.value as! Dictionary<String,Any>
            var participants = [String:String]()
            var num:Int = 0
            participants = dicValue["participants"] as! [String:String]
            let currentNum = participants.count
            if (currentNum == 1){
                let ref = Database.database().reference().child("events").child(self.eventID)
                ref.removeValue { error, _ in
                    print(error)
                }
                self.getData()
            }
            else{
                let ref = Database.database().reference().child("events").child(self.eventID).child("participants").child(self.uid)
                ref.removeValue { error, _ in
                    print(error)
                }
                self.getData()
            }
                
        }

    }
}


// 对外暴露的方法
