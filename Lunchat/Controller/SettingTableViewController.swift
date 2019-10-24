//
//  SettingTableViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/10/24.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

protocol SettingTableViewControllerDelegate {
    func updateUserInfor()
}

class SettingTableViewController: UITableViewController {

    var delegate: SettingTableViewControllerDelegate?
    
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
        
        nameText.delegate = self
        emailText.delegate = self
        eduBackgroundText.delegate = self
        
        schoolText.delegate = self
        majorText.delegate = self
        
        companyText.delegate = self
        positionText.delegate = self
        
        currentResidenceText.delegate = self
        originalResidenceText.delegate = self
        
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
            
            if user.eduBackground != nil {
                self.eduBackgroundText.text = user.eduBackground!
            } else {
                self.eduBackgroundText.text = ""
            }
            
            if user.school != nil {
                self.schoolText.text = user.school!
            } else {
                self.schoolText.text = ""
            }
            
            if user.major != nil {
                self.majorText.text = user.major!
            } else {
                self.majorText.text = ""
            }
            
            if user.company != nil {
                self.companyText.text = user.company!
            } else {
                self.companyText.text = ""
            }
            
            if user.position != nil {
                self.positionText.text = user.position!
            } else {
                self.positionText.text = ""
            }
            
            if user.currentResidence != nil {
                self.currentResidenceText.text = user.currentResidence!
            } else {
                self.currentResidenceText.text = ""
            }
        
            if user.originalResidence != nil {
                self.originalResidenceText.text = user.originalResidence!
            } else {
                self.originalResidenceText.text = ""
            }
        }
    }
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        if let profileImg = self.profileImage.image, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            ProgressHUD.show("Waiting...")
            AuthService.updateUserInfor(username: nameText.text!, email: emailText.text!, imageData: imageData, eduBackground: eduBackgroundText.text!, school: schoolText.text!, major: majorText.text!, company: companyText.text!, position: positionText.text!, currentResidence: currentResidenceText.text!, originalResidence: originalResidenceText.text!, onSuccess: {
                ProgressHUD.showSuccess("Success")
                self.delegate?.updateUserInfor()
            }, onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            })
        }
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
    
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
}

extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}
