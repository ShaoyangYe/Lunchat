//
//  HostViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class HostViewController: UIViewController , UITextFieldDelegate{
    //控件定义
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var btnLunchat: UIButton!
    @IBOutlet weak var btnMovie: UIButton!
    @IBOutlet weak var btnPhotography: UIButton!
    @IBOutlet weak var btnMusic: UIButton!
    @IBOutlet weak var btnTravel: UIButton!
    @IBOutlet weak var btnGame: UIButton!
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnAssignment: UIButton!
    @IBOutlet weak var btnJustChat: UIButton!
    @IBOutlet weak var btnBuildTopic: UIButton!
    @IBOutlet weak var textTime: UITextField!
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var buttonViewGroup: UIView!
    
    let datePicker = UIDatePicker()
    
    func createDatePicker()
    {
        datePicker.datePickerMode = .date
        textTime.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolBar.setItems([doneButton], animated: true)
        
        textTime.inputAccessoryView = toolBar
    }
    @objc func doneClicked()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        textTime.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
//    let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        self.buttonViewGroup.layer.borderWidth = 1
        self.buttonViewGroup.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        
        //话题选择
        customizeButtonG1(buttonName: btnMovie, colorName: "54335.png",textPosition: 0)
        customizeButtonG1(buttonName: btnPhotography, colorName: "btnPhoto.png",textPosition: 0)
        customizeButtonG1(buttonName: btnMusic, colorName: "btnMusic.png",textPosition: 0)
        customizeButtonG1(buttonName: btnTravel, colorName: "btnTravel.png",textPosition: 0)
        customizeButtonG1(buttonName: btnGame, colorName: "btnGame.png",textPosition: 0)
        customizeButtonG1(buttonName: btnBusiness, colorName: "btnBussiness.png",textPosition: 0)
        customizeButtonG1(buttonName: btnAssignment, colorName: "btnAssignment.png",textPosition: 0)
        customizeButtonG1(buttonName: btnJustChat, colorName: "btnJustChat.png",textPosition: 0)
        customizeButtonG1(buttonName: btnBuildTopic, colorName: "btnBuildTopic.png",textPosition: 0)
        customizeButtonG1(buttonName: btnLunchat, colorName: "",textPosition: 1)
        
        //textfield keyboard
        textTitle.delegate = self
        //        password.delegate = self
        //文本框圆角
        textTitle.borderStyle = UITextField.BorderStyle.roundedRect
        textTitle.layer.cornerRadius = 10.0
        textTime.borderStyle = UITextField.BorderStyle.roundedRect
        textTime.layer.cornerRadius = 10.0
        txtLocation.borderStyle = UITextField.BorderStyle.roundedRect
        txtLocation.layer.cornerRadius = 10.0
        //        btnSelectLocation.layer.borderWidth = 0.8
        //        btnSelectLocation.layer.borderColor = UIColor.gray.cgColor
        
        buttonViewGroup.layer.cornerRadius = 10.0
        buttonViewGroup.layer.borderColor = (UIColor(red: 250.0/255.0, green: 128/255.0, blue: 114/255.0, alpha: 1)).cgColor
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //话题选择
    func customizeButtonG1(buttonName:UIButton, colorName:String, textPosition: CGFloat) {
        // change UIbutton propertie
        let gray = (UIColor(red: 250.0/255.0, green: 128/255.0, blue: 114/255.0, alpha: 0.8))
        buttonName.backgroundColor = UIColor.white
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1
        buttonName.layer.borderColor = gray.cgColor
        buttonName.tintColor = gray
        
        if textPosition == 0
        {
            buttonName.setImage(UIImage(named:colorName), for: .normal)
            buttonName.imageEdgeInsets = UIEdgeInsets(top: 6,left: textPosition,bottom: 10,right: 50)
        }
        
    }
    
    @IBAction func btnMovieTouchDown(_ sender: Any) {
        changeBtnColor(button: btnMovie)
    }
    
    @IBAction func btnPhotoTouchDown(_ sender: Any) {
        changeBtnColor(button: btnPhotography)
    }
    @IBAction func btnMusicTouchDown(_ sender: Any) {
        changeBtnColor(button: btnMusic)
    }
    @IBAction func btnTravelTouchDown(_ sender: Any) {
        changeBtnColor(button: btnTravel)
    }
    @IBAction func btnGameTouchDown(_ sender: Any) {
        changeBtnColor(button: btnGame)
    }
    @IBAction func btnBuisnessTouchDown(_ sender: Any) {
        changeBtnColor(button: btnBusiness)
    }
    @IBAction func btnAssignmentTouchDown(_ sender: Any) {
        changeBtnColor(button: btnAssignment)
    }
    @IBAction func btnJustChatTouchDown(_ sender: Any) {
        changeBtnColor(button: btnJustChat)
    }
    
    func changeBtnColor(button: UIButton)
    {
        let gray = (UIColor(red: 250.0/255.0, green: 128/255.0, blue: 114/255.0, alpha: 0.8))
        if button.backgroundColor == UIColor.white {
            button.backgroundColor = gray
            button.setTitleColor(UIColor.white, for: .normal)
            button.tintColor = UIColor.white
            
        }
        else
        {
            button.backgroundColor = UIColor.white
            button.setTitleColor(gray, for: .normal)
            button.tintColor = gray
        }
    }
    
    @IBAction func btnBuildTopicShowAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title:  "Enter the topic", message: nil, preferredStyle: .alert)
        // 在 alertController 中增加两个文本输入框
        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            // 为文本输入框添加占位符，也即输入提示
            textField.placeholder = "Enter new topic"
        })
        
        //        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
        //            textField.placeholder = "密码"
        //            // 改变文本输入框的属性为安全输入模式
        //            textField.isSecureTextEntry = true
        //        })
        
        let loginAction = UIAlertAction(title: "Done", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let firstTextField = alertController.textFields![0].text
            //            let secondTextField = alertController.textFields![1] as UITextField
            let btnNewTopic: UIButton = UIButton.init(frame: CGRect(x:170, y:290, width: 111, height: 45))
            self.customizeButtonG1(buttonName: btnNewTopic, colorName: "",textPosition: 0)
            btnNewTopic.setTitle(firstTextField, for: .normal)
            btnNewTopic.setTitleColor(UIColor.gray, for: .normal)
            self.view.addSubview(btnNewTopic)
            //            btnNewTopic.tintColor = UIColor.white
            //            print("Name \(String(describing: firstTextField.text)), Password \(String(describing: secondTextField.text))")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    

}
