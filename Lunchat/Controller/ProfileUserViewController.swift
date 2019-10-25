//
//  ProfileUserViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/10/22.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

protocol ProfileUserViewControllerDelegate {
    func updateFollowButton(forUser user: UserModel)
}

//protocol ProfileUserViewControllerDelegateSwitchSettingVC {
//    func goToSettingVC()
//}
class ProfileUserViewController: UIViewController {
    
    var user: UserModel!
    var userId = ""
    var delegate: ProfileViewControllerDelegate?
    //    var delegate2: ProfileUserViewControllerDelegateSwitchSettingVC?
    @IBOutlet weak var lunchatView: UIView!
    @IBOutlet weak var followingCountView: UIView!
    @IBOutlet weak var followersCountView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var lunchatCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eduBackgroundLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var currentResidenceLabel: UILabel!
    @IBOutlet weak var originalResidenceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        lunchatView.layer.cornerRadius = 5
        followingCountView.layer.cornerRadius = 5
        followersCountView.layer.cornerRadius = 5
        
        followButton.layer.cornerRadius = 5
        
        profileImage.layer.cornerRadius = 60
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    }
    
    func updateView() {
        Api.User.observeUser (withId: userId){ (user) in
            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value
                self.user = user
                self.nameLabel.text = user.username
                
                if let photoUrlString = user.profileImageUrl {
                    let photoUrl = URL(string: photoUrlString)
                    let data = try? Data(contentsOf: photoUrl!)
                    self.profileImage.image = UIImage(data: data!)
                    
                }
                
                Api.Follow.fetchCountFollowing(userId: user.id!) { (count) in
                    self.followingCount.text = "\(count)"
                }
                
                Api.Follow.fetchCountFollowers(userId: user.id!) { (count) in
                    self.followersCount.text = "\(count)"
                }
                
                if user.id == Api.User.CURRENT_USER?.uid {
                    self.followButton.setTitle("Edit Profile", for: UIControl.State.normal)
                    self.followButton.addTarget(self, action: #selector(self.goToSettingVC), for: UIControl.Event.touchUpInside)
                    
                } else {
                    self.updateStateFollowButton()
                }
                
                // Edu Background Label
                if user.eduBackground != nil && user.eduBackground != "" {
                    self.eduBackgroundLabel.text =  user.eduBackground!
                } else {
                    self.eduBackgroundLabel.text = "No Education Background Added (｡•́︿•̀｡)"
                }
                
                // School Label
                if user.school != nil && user.school != "" {
                    self.schoolLabel.text = "Study at: " + user.school!
                    self.schoolLabel.textColor = UIColor.black
                } else {
                    self.schoolLabel.text = "No School Information Added (｡•́︿•̀｡)"
                    self.schoolLabel.textColor = UIColor.gray
                }
                
                // Major Label
                if user.major != nil && user.major != "" {
                    self.majorLabel.text = "Major: " + user.major!
                    self.majorLabel.textColor = UIColor.black
                } else {
                    self.majorLabel.text = "No Major Information Added (｡•́︿•̀｡)"
                    self.majorLabel.textColor = UIColor.gray
                }
                
                // Company Label
                if user.company != nil && user.company != "" {
                    self.companyLabel.text = "Work at: " + user.company!
                    self.companyLabel.textColor = UIColor.black
                } else {
                    self.companyLabel.text = "No Company Information Added (｡•́︿•̀｡)"
                    self.companyLabel.textColor = UIColor.gray
                }
                
                // Position Label
                if user.position != nil && user.position != "" {
                    self.positionLabel.text = "Position: " + user.position!
                    self.positionLabel.textColor = UIColor.black
                } else {
                    self.positionLabel.text = "No Position Information Added (｡•́︿•̀｡)"
                    self.positionLabel.textColor = UIColor.gray
                }
                
                // Current Residence Label
                if user.currentResidence != nil && user.currentResidence != "" {
                    self.currentResidenceLabel.text = "Lives in: " + user.currentResidence!
                    self.currentResidenceLabel.textColor = UIColor.black
                } else {
                    self.currentResidenceLabel.text = "No Current Residence Information Added (｡•́︿•̀｡)"
                    self.currentResidenceLabel.textColor = UIColor.gray
                }
                
                // OriginalResidence Label
                if user.originalResidence != nil && user.originalResidence != "" {
                    self.originalResidenceLabel.text = "OriginalResidence: " + user.originalResidence!
                    self.originalResidenceLabel.textColor = UIColor.black
                } else {
                    self.originalResidenceLabel.text = "No Original Residence Information Added (｡•́︿•̀｡)"
                    self.originalResidenceLabel.textColor = UIColor.gray
                }
                
            })
        }
    }
    
    //    @objc func goToSettingVC() {
    //        delegate2?.goToSettingVC()
    //    }
    @objc func goToSettingVC() {
        performSegue(withIdentifier: "ProfileUser_SettingSegue", sender: nil)
    }
    
    func updateStateFollowButton() {
        if user.isFollowing! {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitle("Follow", for: UIControl.State.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Following", for: UIControl.State.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func followAction() {
        if user!.isFollowing! == false {
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing! = true
            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    @objc func unFollowAction() {
        if user!.isFollowing! == true {
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
            delegate?.updateFollowButton(forUser: user!)
        }
    }
}
