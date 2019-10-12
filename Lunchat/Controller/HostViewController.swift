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
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var buttonViewGroup: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbChooseTopic: UILabel!
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var txtNumPeople: UILabel!
    
    
   
    //主色调
    let gray = (UIColor(red: 255/255.0, green: 140/255.0, blue: 105/255.0, alpha: 0.9))
    let datePicker = UIDatePicker()
//    var np = 0
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
        textTime.textColor = gray
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        self.buttonViewGroup.layer.borderWidth = 1
        self.buttonViewGroup.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        
        customizeElements()
        setDeleges()
        
        buttonViewGroup.layer.cornerRadius = 10.0
        buttonViewGroup.layer.borderColor = gray.cgColor
        lbTitle.textColor = gray
        lbTime.textColor = gray
        lbAddress.textColor = gray
        lbChooseTopic.textColor = gray
        
//        np = txtNumPeople.text as! Int
    }
    
    func setDeleges()
    {
        textTitle.delegate = self
    }
    
    @IBAction func btnUpClicked(_ sender: Any) {
//        np += 1
//        txtNumPeople.text = np as! String
    }
    
    @IBAction func btnDownCliked(_ sender: Any) {
//        np -= 1
//        txtNumPeople.text = np as! String
    }
    func customizeElements()
    {
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
        customizeButtonG1(buttonName: btnSelectLocation, colorName: "map.png",textPosition: 0)
         //文本框设置
        customizeText(textField: textTitle)
        customizeText(textField: textTime)
        customizeText(textField: txtLocation)
    }
    
    func customizeText (textField: UITextField)
    {
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1.0
        textField.borderStyle = UITextField.BorderStyle.none;
        textField.layer.borderColor = gray.cgColor;
        textField.placeholderColor = gray
    }
    
    //键盘消失设置
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func customizeButtonG1(buttonName:UIButton, colorName:String, textPosition: CGFloat) {
        // change UIbutton propertie
        
        buttonName.backgroundColor = UIColor.white
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 0.8
        buttonName.layer.borderColor = gray.cgColor
        buttonName.tintColor = gray
        buttonName.setTitleColor(gray, for: .normal)
        if textPosition == 0
        {
            buttonName.setImage(UIImage(named:colorName), for: .normal)
            buttonName.imageEdgeInsets = UIEdgeInsets(top: 6,left: textPosition,bottom: 10,right: 50)
        }
        
    }
    
    var numtopics = 1
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
        if button.backgroundColor == UIColor.white && numtopics <= 3 {
            numtopics += 1
            button.backgroundColor = gray
            button.setTitleColor(UIColor.white, for: .normal)
            button.tintColor = UIColor.white
            
        }
        else if button.backgroundColor != UIColor.white
        {
            numtopics -= 1
            button.backgroundColor = UIColor.white
            button.setTitleColor(gray, for: .normal)
            button.tintColor = gray
        }
        else
        {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Maximum three topics", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                action in
                print("点击了确定")
            })
//            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func btnBuildTopicShowAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title:  "Enter the topic", message: nil, preferredStyle: .alert)
        // 在 alertController 中增加两个文本输入框
        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            // 为文本输入框添加占位符，也即输入提示
            textField.placeholder = "Enter new topic"
        })
        
        let loginAction = UIAlertAction(title: "Done", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let firstTextField = alertController.textFields![0].text
            //            let secondTextField = alertController.textFields![1] as UITextField
            let btnNewTopic: UIButton = UIButton.init(frame: CGRect(x:170, y:290, width: 150, height: 45))
            self.customizeButtonG1(buttonName: btnNewTopic, colorName: "btnNew.png",textPosition: 0)
            btnNewTopic.setTitle(firstTextField, for: .normal)
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

extension UITextField{
    
    //MARK:-设置暂位文字的颜色
    var placeholderColor:UIColor {
        
        get{
            let color =   self.value(forKeyPath: "_placeholderLabel.textColor")
            if(color == nil){
                return UIColor.white;
            }
            return color as! UIColor;
            
        }
        
        set{
            
            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
        
        
    }
    
    //MARK:-设置暂位文字的字体
    var placeholderFont:UIFont{
        get{
            let font =   self.value(forKeyPath: "_placeholderLabel.font")
            if(font == nil){
                return UIFont.systemFont(ofSize: 14);
            }
            return font as! UIFont;
        }
        set{
            self.setValue(newValue, forKeyPath: "_placeholderLabel.font")
        }
        
    }
    
    
}
