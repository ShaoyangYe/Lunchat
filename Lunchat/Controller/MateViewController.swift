//
//  ViewController.swift
//  Lunchat
//
//  Created by 杨昱程 on 22/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//    var dataSource = [
//    ["name":"Tom Marshall","sex":"male","icon":"no-user-image-square","department":"Master of Bussiness"],
//    ["name":"Pena Valdez","sex":"female","icon":"no-user-image-square","department":"Master of Computer Science"],
//    ["name":"Jessica","sex":"female","icon":"no-user-image-square","department":"Master of teaching"],
//    ["name":"JIM","sex":"male","icon":"no-user-image-square","department":"Master of Information system"]]
    var mate = [[String:String]()]
    var tableView = UITableView()
    var dataSource = [[String:String]()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
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
        let cellid = "testCellID"
        var cell:MateTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? MateTableViewCell
        if cell==nil {
            cell = MateTableViewCell(style: .subtitle, reuseIdentifier: cellid)
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
        cell?.iconImv.contentMode = .scaleAspectFill
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
        print(indexPath.row)
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

extension MateViewController : searchDelegate{
    func transmitString(context: String){
        if context == "" {
            self.mate = self.dataSource
        }
        else {
            
            // 匹配用户输入的前缀，不区分大小写
            self.mate = []
            for arr in self.dataSource {
                
                if ((arr["name"]?.lowercased().contains(context.lowercased()))!) {
                    self.mate.append(arr)
                }
            }
            for arr in self.dataSource {
                
                if ((arr["department"]?.lowercased().contains(context.lowercased()))!) {
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
extension MateViewController{
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
                    }}
                completion(result)
              }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
}
