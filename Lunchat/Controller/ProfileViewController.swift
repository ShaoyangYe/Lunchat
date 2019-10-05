//
//  ProfileViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
