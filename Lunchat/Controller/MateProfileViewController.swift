//
//  MateProfileViewController.swift
//  Lunchat
//
//  Created by 杨昱程 on 25/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

//protocol ProfileUserViewControllerDelegateSwitchSettingVC {
//    func goToSettingVC()
//}
class MateProfileViewController: UIViewController {
    
    var user: UserModel!
    var userId = ""
//    var delegate2: ProfileUserViewControllerDelegateSwitchSettingVC?
    @IBOutlet weak var lunchatView: UIView!
    @IBOutlet weak var followingCountView: UIView!
    @IBOutlet weak var followersCountView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
        
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

        profileImage.layer.cornerRadius = 60
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    }
    
    func updateView() {
        Api.User.observeUser (withId: userId){ (user) in
            
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
                
            
            // Edu Background Label
            if user.eduBackground != nil {
                self.eduBackgroundLabel.text =  user.eduBackground!
            } else {
                self.eduBackgroundLabel.text = "No Education Background Added (｡•́︿•̀｡)"
            }
            
            // School Label
            if user.school != nil {
                self.schoolLabel.text = "Study at: " + user.school!
            } else {
                self.schoolLabel.text = "No School Information Added (｡•́︿•̀｡)"
                self.schoolLabel.textColor = UIColor.gray
            }
            
            // Major Label
            if user.major != nil {
                self.majorLabel.text = "Major: " + user.major!
            } else {
                self.majorLabel.text = "No Major Information Added (｡•́︿•̀｡)"
                self.majorLabel.textColor = UIColor.gray
            }
            
            // Company Label
            if user.company != nil {
                self.companyLabel.text = "Work at: " + user.company!
            } else {
                self.companyLabel.text = "No Company Information Added (｡•́︿•̀｡)"
                self.companyLabel.textColor = UIColor.gray
            }
            
            // Position Label
            if user.position != nil {
                self.positionLabel.text = "Position: " + user.position!
            } else {
                self.positionLabel.text = "No Position Information Added (｡•́︿•̀｡)"
                self.positionLabel.textColor = UIColor.gray
            }
            
            // Current Residence Label
            if user.currentResidence != nil {
                self.currentResidenceLabel.text = "Lives in: " + user.currentResidence!
            } else {
                self.currentResidenceLabel.text = "No Current Residence Information Added (｡•́︿•̀｡)"
                self.currentResidenceLabel.textColor = UIColor.gray
            }
            
            // OriginalResidence Label
            if user.originalResidence != nil {
                self.originalResidenceLabel.text = "OriginalResidence: " + user.originalResidence!
            } else {
                self.originalResidenceLabel.text = "No Original Residence Information Added (｡•́︿•̀｡)"
                self.originalResidenceLabel.textColor = UIColor.gray
            }
            
        
        }
    }
   
//    @objc func goToSettingVC() {
//        delegate2?.goToSettingVC()
//    }
//    @objc func goToSettingVC() {
//        performSegue(withIdentifier: "ProfileUser_SettingSegue", sender: nil)
//    }
//
//
 
}
