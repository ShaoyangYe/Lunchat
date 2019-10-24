//
//  SettingTableViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/10/24.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var eduBackgroundText: UITextField!
    
    @IBOutlet weak var schoolText: UITextField!
    @IBOutlet weak var majorText: UITextField!
    
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var positionText: UITextField!
    
    @IBOutlet weak var currentResidenceText: UITextField!
    @IBOutlet weak var originalResidenceText: UITextField!
   
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 60
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user) in
            self.nameText.text = user.username
            self.emailText.text = user.email
            if let photoUrlString = user.profileImageUrl {
                let photoUrl = URL(string: photoUrlString)
                let data = try? Data(contentsOf: photoUrl!)
                self.profileImage.image = UIImage(data: data!)
            }
            self.eduBackgroundText.text = user.eduBackground!
            
            self.schoolText.text = user.school!
            self.majorText.text = user.major!
            
            self.companyText.text = user.company!
            self.positionText.text = user.position!
            
            self.currentResidenceText.text = user.currentResidence!
            self.originalResidenceText.text = user.originalResidence!
        }
    }
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
//        if let profileImg = self.profileImage.image, let imageData = profileImg.jpegData(compressionQuality: 0.1){
//            ProgressHUD.show("Waiting...")
//            AuthService.updateUserInfor(username: nameText.text!, email: emailText.text!, imageData: imageData, onSuccess: {
//                ProgressHUD.showSuccess("Success")
//                self.delegate?.updateUserInfor()
//            }, onError: { (errorMessage) in
//                ProgressHUD.showError(errorMessage)
//            })
//        }
    }
    
    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
//        AuthService.logout(onSuccess: {
//            let storyboard = UIStoryboard(name: "Start", bundle: nil)
//            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
//            self.present(signInVC, animated: true, completion: nil)
//        }) { (errorMessage) in
//            ProgressHUD.showError(errorMessage)
//        }
    }
}
