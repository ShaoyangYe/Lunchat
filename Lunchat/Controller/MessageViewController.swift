//
//  MessageViewController.swift
//  Lunchat
//
//  Created by Kangyun Dou on 6/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var searchBar = UISearchBar()
    var mate = [[String:String]()]
    var tableView = UITableView()
    var dataSource = [[String:String]()]
    
    var recipient: String!
    
    var messageId: String!
    
    var havefriend = false
    
    override func viewDidAppear(_ animated: Bool) {
        getData(){ (mateResult:[[String:String]]) in
            // this will only be called when findUniqueId trigger completion(sID)...
            //            print(mateResult)
            self.dataSource = mateResult
            self.mate = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        self.tableView = UITableView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        //            self.mate = self.dataSource
        
        //        tableView.reloadData()
        getData(){ (mateResult:[[String:String]]) in
            // this will only be called when findUniqueId trigger completion(sID)...
            //            print(mateResult)
            self.dataSource = mateResult
            self.mate = self.dataSource
            self.tableView.reloadData()
        }
        //        print("1")
        
    }
    
    //MARK: UITableViewDataSource
    // cell的个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mate.count
    }
    
    
    // UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "mateCellID"
        var cell: MassageMateTableViewCell? = tableView.dequeueReusableCell(withIdentifier:cellid) as? MassageMateTableViewCell
        if cell == nil {
            cell = MassageMateTableViewCell(style: .subtitle, reuseIdentifier:cellid)
        }
        let dict:Dictionary = self.mate[indexPath.row]
        if dict["icon"] != nil{
            let url : URL = URL.init(string: dict["icon"]!)!
            let data : NSData! = NSData(contentsOf: url)
            if data != nil {
                cell?.iconImv.image = UIImage.init(data: data as Data, scale: 1) //赋值图片
            }
            else{
                cell?.iconImv.image = UIImage(named:"no-user-image-square")
            }
        }else{
            cell?.iconImv.image = UIImage(named:"no-user-image-square")
        }
        cell?.uid = dict["uid"]
        //        cell?.iconImv.image = UIImage(named: dict["icon"]!)
        cell?.userLabel.text = dict["name"]
        //        cell?.sexLabel.text = dict["sex"]
        cell?.departmentLabel.text = dict["department"]
        
        return cell!
    }
    
    //MARK: UITableViewDelegate
    // 设置cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    // 选中cell后执行此方法
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("getindexpath.rowinginging")
        print(indexPath.row)
        let dict:Dictionary = self.mate[indexPath.row]
        recipient = dict["uid"]
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with:{
            (snapshot) in
            if snapshot.hasChild("messages"){
                self.getMessageId()
            }else{
                self.performSegue(withIdentifier: "toMessages", sender: nil)}
        })
        
        
    }
    
    
    func getMessageId(){
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).child("messages").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let msgs = snapshot.value as? Dictionary<String, AnyObject>
            //                print(value)
            for (key, value) in msgs!{
                let dictionary = value as! Dictionary<String,String>
                let reci = dictionary["recipient"]!
                if reci == self.recipient{
                    print(key)
                    self.messageId = key
                }
            }
            self.performSegue(withIdentifier: "toMessages", sender: nil)
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MessageDetailViewController {
            
            destinationViewController.recipient = self.recipient
            
            destinationViewController.messageId = self.messageId
        }
    }
    
    
    func currentTime() -> String {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
        
        // GMT时间 转字符串，直接是系统当前时间
        
        return dateformatter.string(from: Date())
        
    }
    //    func dohavefriend(){
    //        let userID = Auth.auth().currentUser?.uid
    //        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with:{
    //        (snapshot) in
    //        if snapshot.hasChild("friends")
    //        {
    //            havefrind = true
    //        }
    //    })
    //    }
    
    
}


extension MessageViewController{
    func getData(completion:@escaping(_ mateResult:[[String:String]])->()){
        var result = [[String:String]]()
        if Api.User.CURRENT_USER != nil {
            Api.User.REF_CURRENT_USER?.child("friends").observeSingleEvent(of: .value, with: {(snapshot) in
                // Get user value
                let users = snapshot.value as? Dictionary<String,Any>
                //                print(value)
                if users != nil {
                    for (key, value) in users!{
                        let dict = value as! Dictionary<String,String>
                        var mate = [String:String]()
                        mate["name"] = dict["username"]
                        mate["icon"] = dict["profileImageUrl"]
                        mate["department"] = dict["email"]
                        mate["uid"] = key
                        result.append(mate)
                    }
                }
                completion(result)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}
//
extension MessageViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.lowercased() == "" {
            self.mate = self.dataSource
        }
        else {
            
            // 匹配用户输入的前缀，不区分大小写
            self.mate = []
            print(searchText.lowercased())
            print(self.dataSource)
            print(self.mate)
            for arr in self.dataSource {
                
                if ((arr["name"]?.lowercased().contains(searchText.lowercased()))!) {
                    self.mate.append(arr)
                }
            }
            for arr in self.dataSource {
                
                if ((arr["department"]?.lowercased().contains(searchText.lowercased()))!) {
                    if !self.mate.contains(arr){
                        self.mate.append(arr)
                    }
                }
            }
        }
        self.tableView.reloadData()
        //        print(context)
    }
}
