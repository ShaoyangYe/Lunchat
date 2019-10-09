//
//  RecommendViewController.swift
//  Lunchat
//
//  Created by 杨昱程 on 21/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var dataSource = [[String:String]()]
    var collectedFlag = Bool()
    var result = [[String:String]()]
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: UIScreen.main.bounds.height-256), style: .plain)
        tableView.backgroundColor = UIColor.white;
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.bounces = false
//        dataSource = [
//            ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true"],
//            ["title":"What's your favorite movie?","theme":"Movie","location":"Union House","participant":"3","MaxParticipant":"4","time":"12:00","collected": "false"],
//            ["title":"Do you like art?","theme":"Art","location":"Union House","participant":"3","MaxParticipant":"3","time":"16:40","collected": "false"],
//            ["title":"Go to Gym?","theme":"Sport","location":"Union House","participant":"1","MaxParticipant":"2","time":"10:50","collected": "false"],
//            ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true"],
//            ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true"],
//            ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true"]]
        self.result  = dataSource
        tableView.reloadData()
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
//        print(indexPath.row)
        let dict:Dictionary = self.result[indexPath.row]
        cell?.titleLabel.text = dict["title"]
        cell?.themeLabel.text = dict["theme"]
        cell?.themeLabel.adjustsFontSizeToFitWidth = true
//        cell?.locationLabel.text = location
        let maxNumber = dict["MaxParticipant"]
        cell?.participant.text = dict["participant"]!+"/"+maxNumber!
        cell?.timeLabel.text = dict["time"]
        cell?.locationLabel.text = dict["location"]!
    
        collectedFlag =  (dict["collected"]! as NSString).boolValue
        cell?.collecteButton.setImage(UIImage(named: "video_btn_collect40HL"), for: .normal)

        cell?.collecteButton.setImage(UIImage(named: "video_btn_collected40"), for: .selected)

        if collectedFlag{
            cell?.collecteButton.isSelected = true
        }
        else{
            cell?.collecteButton.isSelected = false
        }
        cell?.collecteButton.addTarget(self, action: #selector(buttonAction(button:)),for:.touchUpInside)      
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
