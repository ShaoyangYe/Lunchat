//
//  LCViewController.swift
//  Lunchat
//
//  Created by 杨昱程 on 22/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import MapKit

class LCTableViewCell: UITableViewCell,CLLocationManagerDelegate,MKMapViewDelegate{
    let width:CGFloat = UIScreen.main.bounds.width
    var titleLabel:UILabel!      // 名字
    var themeLabel:UILabel!  // 主题
    var locationLabel:UILabel!       // 地点
    var participant:UILabel!    // 参加人数
    var timeLabel:UILabel!    //约定时间
    var eventID: String! // 事件ID
    var people : UIImageView!
    var peopleWithImage: UILabel!
    var locationImage : UIImageView!
    var locationWithImage : UILabel!
    var timeImage : UIImageView!
    var timeWithImage : UILabel!
    var collecteButton: UIButton!
    var participants : [Dictionary<String,String>]!
    var longtitude: String!
    var latitude: String!
    var uid: String!
    var expand: Bool = false
    
    var mapView: MKMapView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 名字
        titleLabel = UILabel(frame: CGRect(x: 5, y: 12, width: 300, height: 20))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        
        themeLabel = UILabel(frame: CGRect(x: 5, y: 40, width: 75, height: 15))
        themeLabel.textColor = UIColor.white
        themeLabel.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        themeLabel.textAlignment = .center
        themeLabel.layer.cornerRadius = 4
//        themeLabel.layer.borderColor = UIColor.orange.cgColor
//        themeLabel.layer.borderWidth = 1
        themeLabel.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
//        themeLabel.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        locationLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 130, height: 15))
//        locationLabel.setImage(UIImage(named: "video_ico_location"), for: .normal)
        locationLabel.font = UIFont.boldSystemFont(ofSize: 10)
        locationLabel.textAlignment = .left
        locationLabel.textColor = UIColor.black
        locationImage = UIImageView(frame: CGRect(x: 2.5, y: 1, width: 10, height: 13))
        locationImage.image = UIImage(named: "video_ico_location")
        locationWithImage = UILabel(frame: CGRect(x: 2, y: 60, width: 100, height: 15))
        locationWithImage.addSubview(locationImage)
        locationWithImage.addSubview(locationLabel)
        
        participant = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 15))
        people = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        people.image =  UIImage(named: "home_live_player_normal")
//        participant.addSubview(UILabel.init(frame: <#T##CGRect#>))
        participant.textColor = UIColor.black
        participant.font = UIFont.systemFont(ofSize: 10)
        peopleWithImage = UILabel(frame: CGRect(x: 2, y: 80, width: 100, height: 15))
        peopleWithImage.addSubview(people)
        peopleWithImage.addSubview(participant)
        
        timeLabel = UILabel(frame: CGRect(x:30, y: 0, width: 100, height: 25))
        timeLabel.textColor = UIColor.black
        timeLabel.font = UIFont.boldSystemFont(ofSize: 25)
        timeLabel.textAlignment = .left
        timeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        timeImage.image = UIImage(named: "cmic_time_icon")
//        timeImage.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        timeWithImage = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width-102, y: 35, width: 100, height: 30))
        timeWithImage.addSubview(timeImage)
        timeWithImage.addSubview(timeLabel)
        
        collecteButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-35, y: 70, width: 25, height: 25))
        
        if expand{
            mapView=MKMapView.init(frame:CGRect.init(x: 150, y: 150, width:100 , height:100 ))
            mapView.tag = 99
            addSubview(mapView)
            print("expand")
        }else{
            viewWithTag(99)?.removeFromSuperview()
        }

        contentView.addSubview(titleLabel)
        contentView.addSubview(themeLabel)
        contentView.addSubview(locationWithImage)
        contentView.addSubview(peopleWithImage)
        contentView.addSubview(timeWithImage)
        addSubview(collecteButton)
        // 出生日期
//        departmentLabel = UILabel(frame: CGRect(x: 110, y: 49, width: width-94, height: 13))
//        departmentLabel.textColor = UIColor.black
//        departmentLabel.font = UIFont.systemFont(ofSize: 13)
//        departmentLabel.textAlignment = .left
//
//        contentView.addSubview(iconImv)
//        contentView.addSubview(titleLabel)
//        //        contentView.addSubview(locationLabel)
//        contentView.addSubview(departmentLabel)
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
