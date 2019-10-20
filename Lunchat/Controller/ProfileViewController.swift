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
    @IBOutlet weak var profileimage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var characteristicLabel1: UILabel!
    @IBOutlet weak var characteristicLabel2: UILabel!
    @IBOutlet weak var characteristicLabel3: UILabel!
    @IBOutlet weak var characteristicLabel4: UILabel!
    
    @IBOutlet weak var skillLabel1: UILabel!
    @IBOutlet weak var skillLabel2: UILabel!
    @IBOutlet weak var skillLabel3: UILabel!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lunchatView.layer.cornerRadius = 5
        lunchatMate.layer.cornerRadius = 5
        likes.layer.cornerRadius = 5
        
        editButton.layer.cornerRadius = 5
//        characteristicLabel1.layer.borderWidth = 2
//        characteristicLabel1.layer.cornerRadius = 6
//        characteristicLabel1.layer.borderColor = UIColor.darkGray.cgColor
//
//        characteristicLabel2.layer.borderWidth = 2
//        characteristicLabel2.layer.cornerRadius = 6
//        characteristicLabel2.layer.borderColor = UIColor.darkGray.cgColor
//        
//        characteristicLabel3.layer.borderWidth = 2
//        characteristicLabel3.layer.cornerRadius = 6
//        characteristicLabel3.layer.borderColor = UIColor.darkGray.cgColor
//        
//        characteristicLabel4.layer.borderWidth = 2
//        characteristicLabel4.layer.cornerRadius = 6
//        characteristicLabel4.layer.borderColor = UIColor.darkGray.cgColor
//        
        
        profileimage.layer.cornerRadius = 60
        profileimage.layer.borderWidth = 5
        profileimage.layer.borderColor = UIColor.white.cgColor

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

}
