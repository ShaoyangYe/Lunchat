//
//  MateTableViewCell.swift
//  Lunchat
//
//  Created by 杨昱程 on 24/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class MateTableViewCell: UITableViewCell {
    var iconImv:UIImageView!  // 图片
    var userLabel:UILabel!       // 名称
    var departmentLabel:UILabel!    // 部门

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconImv = UIImageView(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
        iconImv.layer.cornerRadius = 5.0
        iconImv.layer.masksToBounds = true
        
        userLabel = UILabel(frame: CGRect(x: 110, y: 20, width: 200, height: 20))
        userLabel.textColor = UIColor.black
        userLabel.font = UIFont.boldSystemFont(ofSize: 17)
        userLabel.textAlignment = .left
        
        departmentLabel = UILabel(frame: CGRect(x: 111, y: 50, width: 200, height: 15))
        departmentLabel.textColor = UIColor.black
        departmentLabel.font = UIFont.systemFont(ofSize: 12)
        departmentLabel.textAlignment = .left
        
        contentView.addSubview(iconImv)
        contentView.addSubview(userLabel)
        contentView.addSubview(departmentLabel)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
