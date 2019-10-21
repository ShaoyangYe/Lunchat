//
//  ProfileViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var lunchatView: UIView!
    @IBOutlet weak var lunchatMate: UIView!
    @IBOutlet weak var likes: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var lunchatCount: UILabel!
    @IBOutlet weak var lunchMateCount: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        lunchatView.layer.cornerRadius = 5
        lunchatMate.layer.cornerRadius = 5
        likes.layer.cornerRadius = 5
        
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
            
            // Edu Background Label
            if user.eduBackground != nil {
                self.eduBackgroundLabel.text =  user.eduBackground!
            } else {
                self.eduBackgroundLabel.text = "Add Education Background Now!"
            }
            
            // School Label
            if user.school != nil {
                self.schoolLabel.text = "Study at: " + user.school!
            } else {
                self.schoolLabel.text = "Add School Information Now!"
                self.schoolLabel.textColor = UIColor.gray
            }
            
            // Major Label
            if user.major != nil {
                self.majorLabel.text = "Major: " + user.major!
            } else {
                self.majorLabel.text = "Add Major Information Now!"
                self.majorLabel.textColor = UIColor.gray
            }
            
            // Company Label
            if user.company != nil {
                self.companyLabel.text = "Work at: " + user.company!
            } else {
                self.companyLabel.text = "Add Company Information Now!"
                self.companyLabel.textColor = UIColor.gray
            }
            
            // Position Label
            if user.position != nil {
                self.positionLabel.text = "Position: " + user.position!
            } else {
                self.positionLabel.text = "Add Position Information Now!"
                self.positionLabel.textColor = UIColor.gray
            }
            
            // Current Residence Label
            if user.currentResidence != nil {
                self.currentResidenceLabel.text = "Lives in: " + user.currentResidence!
            } else {
                self.currentResidenceLabel.text = "Add Current Residence Information Now!"
                self.currentResidenceLabel.textColor = UIColor.gray
            }
            
            // OriginalResidence Label
            if user.originalResidence != nil {
                self.originalResidenceLabel.text = "OriginalResidence: " + user.originalResidence!
            } else {
                self.originalResidenceLabel.text = "Add Original Residence Information Now!"
                self.originalResidenceLabel.textColor = UIColor.gray
            }
            
        }
    }
    
}
