//
//  MessageViewController.swift
//  Lunchat
//
//  Created by Kangyun Dou on 6/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//


import UIKit


class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [
        ["name":"Tom Marshall","sex":"male","icon":"no-user-image-square","department":"Master of Bussiness"],
        ["name":"Pena Valdez","sex":"female","icon":"no-user-image-square","department":"Master of Computer Science"],["name":"Jessica","sex":"female","icon":"no-user-image-square","department":"Master of teaching"],    ["name":"JIM","sex":"male","icon":"no-user-image-square","department":"Master of Information system"]]
    var mate = [[String:String]()]
    var tableView = UITableView()
    //var dataSource = [[String:String]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
            self.mate = self.dataSource
        
        tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    // cell的个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mate.count
    }
    // UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellid = "testCellID"
//        var cell: MateTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? MateTableViewCell
//        if cell==nil {
//            cell = MateTableViewCell(style: .subtitle, reuseIdentifier: cellid)
//        }
        let cellid = "mateCellID"
        var cell: MassageMateTableViewCell? = tableView.dequeueReusableCell(withIdentifier:cellid) as? MassageMateTableViewCell
        if cell == nil {
            cell = MassageMateTableViewCell(style: .subtitle, reuseIdentifier:cellid)
        }
        let dict:Dictionary = self.mate[indexPath.row]
        cell?.iconImv.image = UIImage(named: dict["icon"]!)
        cell?.userLabel.text = dict["name"]
        //cell?.sexLabel.text = dict["sex"]
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
        performSegue(withIdentifier: "toMessages", sender: nil)
    }


                   
    func currentTime() -> String {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
        
        // GMT时间 转字符串，直接是系统当前时间
        
        return dateformatter.string(from: Date())
        
    }
}

//extension MessageViewController : searchDelegate{
//    func transmitString(context: String){
//         if context == "" {
//                self.mate = self.dataSource
//           }
//         else {
//
//           // 匹配用户输入的前缀，不区分大小写
//            self.mate = []
//            print(context)
//            print(self.dataSource)
//            print(self.mate)
//            for arr in self.dataSource {
//
//                if ((arr["name"]?.lowercased().contains(context.lowercased()))!) {
//                       self.mate.append(arr)
//                   }
//           }
//            for arr in self.dataSource {
//
//                if ((arr["department"]?.lowercased().contains(context.lowercased()))!) {
//                    if !self.mate.contains(arr){
//                        self.mate.append(arr)
//                    }
//                }
//            }
//           }
//        self.tableView.reloadData()
////        print(context)
//    }
//}
