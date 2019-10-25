//
//  ProfileViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    func updateFollowButton(forUser user: UserModel)
}
//protocol ProfileViewControllerDelegateSwitchSettingVC {
//    func goToSettingVC()
//}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var lunchatView: UIView!
    @IBOutlet weak var followingCountView: UIView!
    @IBOutlet weak var followersCountView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
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
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var user: UserModel!
    var delegate: ProfileViewControllerDelegate?
    //    var delegate2: ProfileViewControllerDelegateSwitchSettingVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        lunchatView.layer.cornerRadius = 5
        followingCountView.layer.cornerRadius = 5
        followersCountView.layer.cornerRadius = 5
        
        editButton.layer.cornerRadius = 5
        
        profileImage.layer.cornerRadius = 60
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    }
    
    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    
    func updateView() {
        Api.User.observeCurrentUser{ (user) in
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
                self.editButton.setTitle("Edit Profile", for: UIControl.State.normal)
                self.editButton.addTarget(self, action: #selector(self.goToSettingVC), for: UIControl.Event.touchUpInside)
            } else {
                self.updateStateFollowButton()
            }
            
            // Edu Background Label
            if user.eduBackground != nil && user.eduBackground != "" {
                self.eduBackgroundLabel.text =  user.eduBackground!
            } else {
                self.eduBackgroundLabel.text = "Add Education Background Now!"
            }
            
            // School Label
            if user.school != nil && user.school != "" {
                self.schoolLabel.text = "Study at: " + user.school!
                self.schoolLabel.textColor = UIColor.black
            } else {
                self.schoolLabel.text = "Add School Information Now!"
                self.schoolLabel.textColor = UIColor.gray
            }
            
            // Major Label
            if user.major != nil && user.major != "" {
                self.majorLabel.text = "Major: " + user.major!
                self.majorLabel.textColor = UIColor.black
            } else {
                self.majorLabel.text = "Add Major Information Now!"
                self.majorLabel.textColor = UIColor.gray
            }
            
            // Company Label
            if user.company != nil && user.company != "" {
                self.companyLabel.text = "Work at: " + user.company!
                self.companyLabel.textColor = UIColor.black
            } else {
                self.companyLabel.text = "Add Company Information Now!"
                self.companyLabel.textColor = UIColor.gray
            }
            
            // Position Label
            if user.position != nil && user.position != "" {
                self.positionLabel.text = "Position: " + user.position!
                self.positionLabel.textColor = UIColor.black
            } else {
                self.positionLabel.text = "Add Position Information Now!"
                self.positionLabel.textColor = UIColor.gray
            }
            
            // Current Residence Label
            if user.currentResidence != nil && user.currentResidence != "" {
                self.currentResidenceLabel.text = "Lives in: " + user.currentResidence!
                self.currentResidenceLabel.textColor = UIColor.black
            } else {
                self.currentResidenceLabel.text = "Add Current Residence Information Now!"
                self.currentResidenceLabel.textColor = UIColor.gray
            }
            
            // OriginalResidence Label
            if user.originalResidence != nil && user.originalResidence != "" {
                self.originalResidenceLabel.text = "OriginalResidence: " + user.originalResidence!
                self.originalResidenceLabel.textColor = UIColor.black
            } else {
                self.originalResidenceLabel.text = "Add Original Residence Information Now!"
                self.originalResidenceLabel.textColor = UIColor.gray
            }
        }
    }
    
    func updateStateFollowButton() {
        if user!.isFollowing! {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func configureFollowButton() {
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        editButton.layer.cornerRadius = 5
        editButton.clipsToBounds = true
        
        editButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        editButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        editButton.setTitle("Follow", for: UIControl.State.normal)
        editButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
    }
    
    func configureUnFollowButton() {
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        editButton.layer.cornerRadius = 5
        editButton.clipsToBounds = true
        
        editButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        editButton.backgroundColor = UIColor.clear
        editButton.setTitle("Following", for: UIControl.State.normal)
        editButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControl.Event.touchUpInside)
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
    
    //    @objc func goToSettingVC() {
    //        delegate2?.goToSettingVC()
    //    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile_SettingSegue" {
            let settingVC = segue.destination as! SettingTableViewController
            settingVC.delegate = self
        }
        
    }
    
    
    @objc func goToSettingVC() {
        performSegue(withIdentifier: "Profile_SettingSegue", sender: nil)
    }
}

extension ProfileViewController: SettingTableViewControllerDelegate {
    func updateUserInfor() {
        self.updateView()
    }
}
