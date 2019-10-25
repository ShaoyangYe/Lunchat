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
import Firebase

class HostViewController: UIViewController , UITextFieldDelegate,MapViewSelectionControllerDelegate {
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
    @IBOutlet weak var lbNumPeople: UILabel!
    
    
    
    //主色调
    let gray = (UIColor(red: 255/255.0, green: 140/255.0, blue: 105/255.0, alpha: 0.9))
    let datePicker = UIDatePicker()
    var np = 0
    func createDatePicker()
    {
        datePicker.datePickerMode = .dateAndTime
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
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        //        dateFormatter.dateStyle = .medium
        //        dateFormatter.timeStyle = .none
        
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
        self.tabBarController?.tabBar.isHidden = false
        textTitle.textColor = gray
        textTime.textColor = gray
        txtLocation.textColor = gray
        
    }
    
    func setDeleges()
    {
        textTitle.delegate = self
    }
    
    @IBAction func btnUpClicked(_ sender: Any) {
        np += 1
        lbNumPeople.text = String(np)
    }
    
    @IBAction func btnDownCliked(_ sender: Any) {
        if np <= 0
        {
            let alertController = UIAlertController(title: "System notice",
                                                    message: "Minimum number of people is 0", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                print("点击了确定")
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            np -= 1
            lbNumPeople.text = String(np)
        }
        
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
        textField.placeholderColor(UIColor.gray)
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
        if button.backgroundColor == UIColor.white && numtopics <= 1 {
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
                                                    message: "Maximum one topics", preferredStyle: .alert)
            //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            //            alertController.addAction(cancelAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func initBtnTopic(button: UIButton)
    {
        numtopics = 0
        button.backgroundColor = UIColor.white
        button.setTitleColor(gray, for: .normal)
        button.tintColor = gray
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "hostToMapSelection"){
            let displayVC = segue.destination as! MapViewSelectionController
            displayVC.delegate = self
        }
    }
    
    var latitudeall: CLLocationDegrees = 0.0
    var longtitudeall: CLLocationDegrees = 0.0
    
    func doSomethingWith(data: String, latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        self.txtLocation.text = data
        self.latitudeall = latitude
        self.longtitudeall = longtitude
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func BtnPostUp_Inside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        var topicText = ""
        if btnPhotography.backgroundColor != UIColor.white{
            topicText = btnPhotography.currentTitle!
        }
        else if btnAssignment.backgroundColor != UIColor.white{
            topicText = btnAssignment.currentTitle!
        }
        else if btnJustChat.backgroundColor != UIColor.white{
            topicText = btnJustChat.currentTitle!
        }
        else if btnBusiness.backgroundColor != UIColor.white{
            topicText = btnBusiness.currentTitle!
        }
        else if btnTravel.backgroundColor != UIColor.white{
            topicText = btnTravel.currentTitle!
        }
        else if btnMusic.backgroundColor != UIColor.white{
            topicText = btnMusic.currentTitle!
        }
        else if btnMovie.backgroundColor != UIColor.white{
            topicText = btnMovie.currentTitle!
        }
        else if btnGame.backgroundColor != UIColor.white{
            topicText = btnGame.currentTitle!
        }
        
        if self.textTitle.text?.count == 0{
            ProgressHUD.showError("Title can't be empty")
        }
        else if self.textTime.text?.count == 0{
            ProgressHUD.showError("Time can't be empty")
        }
        else if self.txtLocation.text?.count == 0{
            ProgressHUD.showError("Address can't be empty")
        }
        else if self.lbNumPeople.text == "0"{
            ProgressHUD.showError("The number of participants can't be empty")
        }
        else{
            let userID:String! = Auth.auth().currentUser!.uid
            var datetime = NSString(string: textTime.text!)
            var arrayDatetime = datetime.components(separatedBy: " ")
            HelperService.sendDataToDatabase(topic: topicText, title: textTitle.text!, date: arrayDatetime[0], time: arrayDatetime[1], address: txtLocation.text!, numberpeople: Int(lbNumPeople.text!)!, latitude: String(self.latitudeall), longtitude: String(self.longtitudeall), onSuccess: {
                self.clean()
                self.tabBarController?.selectedIndex = 0
            })
        }
        //        self.dataDelegate?.getData()
    }
    
    func clean() {
        self.textTitle.text = ""
        self.textTime.text = ""
        self.txtLocation.text = ""
        self.lbNumPeople.text = "0"
        initBtnTopic(button: btnGame)
        initBtnTopic(button: btnMovie)
        initBtnTopic(button: btnMusic)
        initBtnTopic(button: btnTravel)
        initBtnTopic(button: btnBusiness)
        initBtnTopic(button: btnJustChat)
        initBtnTopic(button: btnAssignment)
        initBtnTopic(button: btnPhotography)
    }
    
}

extension UITextField{
    
    //MARK:-设置暂位文字的颜色
    //    var placeholderColor:UIColor {
    //
    //        get{
    //            let color =   self.value(forKeyPath: "_placeholderLabel.textColor")
    //            if(color == nil){
    //                return UIColor.white;
    //            }
    //            return color as! UIColor;
    //
    //        }
    //
    //        set{
    //
    //            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
    //        }
    //
    //
    //    }
    //
    func placeholderColor(_ color: UIColor) {
        // Color
        var attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        var range = NSRange(location: 0, length: 1)
        
        // Font
        if let text = attributedText, text.length > 0, let attrs = attributedText?.attributes(at: 0, effectiveRange: &range), let font = attrs[.font] {
            attributes[.font] = font
        }
        else if let font = font {
            attributes[.font] = font
        }
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)
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
