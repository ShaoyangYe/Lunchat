//
//  MessageDetailViewController.swift
//  Lunchat
//
//  Created by Kangyun Dou on 7/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    //列表控件
   
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var testingLabel: UILabel!

    @IBOutlet weak var messageBox: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageView: UITableView!
    
    //列表数据源
    var messages:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //设置列表数据源和代理
        messageView.dataSource = self
        messageView.delegate = self
        messageView.rowHeight = UITableView.automaticDimension
        messageView.estimatedRowHeight = 300
        print("假装")
        
        //增加模拟数据
        
        for index in 0...19 {
            messages.append("\(index)")
        }
        //让列表重新加载数据
        messageView.reloadData()
    }
    

}
//列表数据源和代理

extension MessageDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    //列表的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //返回当前位置Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MessageCell
        
        //返回Cell
        return cell
    }
    
    
    
}
