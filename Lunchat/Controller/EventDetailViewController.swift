//
//  EventDetailViewController.swift
//  Lunchat
//
//  Created by Jiaqing Chen on 23/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol EventDetailViewControllerProtocol {
    
    func dialogDismissed()
    func displayMap()
    
}

class EventDetailViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var participantsTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Create variable for each label
    var titleText = ""
    var themeText = ""
    var timeText = ""
    var locationText = ""
    var participantsText = ""
    var buttonText = "OK"
    
    var delegate:EventDetailViewControllerProtocol?
    
    var dbRef:DatabaseReference?
    
    var currentEventID: Int?
    var allParticipants = [Participants]()
    var participants: [String:String]?
    var participantsID: [String]!
    var registeredParticipants = [Participants]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize the popup box
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = UIColor(red:0.98, green:0.50, blue:0.45, alpha:1.0).cgColor
        cancelButton.viewWithTag(1)?.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        participantsTableView.delegate = self
        participantsTableView.dataSource = self
        getParticipants()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Read data from firebase
        
        participantsTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Now the elements are loaded, set the text
        titleLabel.text = titleText
        themeLabel.text = themeText
        timeLabel.text = timeText
        locationLabel.text = locationText
        participantsLabel.text = participantsText
        cancelButton.setTitle(buttonText, for: .normal)
        
        delegate?.displayMap()
        
    }
    
    func getParticipants() {
    
        dbRef = Database.database().reference().child("users")
        
        dbRef!.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snap in snapshots {
                
                let participantsDict = snap.value as! [String:Any]
                
                let id = snap.key
                let username = participantsDict["username"] as! String
                let profileImageUrl = participantsDict["profileImageUrl"] as! String
                print(profileImageUrl)
                let p = Participants(id: id, username: username, profileImageUrl: profileImageUrl)
                
                self.allParticipants.append(p)
                
            }
            
        })
        
        participantsID = Array(participants!.keys)
        print("hhhhh")
    
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        participantsID.removeAll()
        print(currentEventID!)
        // Dismiss the popup
        self.dismiss(animated: true, completion: nil)
        
        // Notify delegat that popup was dismissed
        delegate?.dialogDismissed()
    }
    
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var i = 0
        let count = self.participantsID!.count
        
        while i < count {
            
            for n in self.allParticipants {
                
                if self.participantsID[i] == n.id {
                    
                    print("add one participant")
                    self.registeredParticipants.append(n)
                    
                }
                
            }
            
            i += 1
            
        }
        
        return self.registeredParticipants.count
        
    }
    //participantsCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "participantsCell", for: indexPath)
        
        let image = cell.viewWithTag(10) as? UIImageView
        let usernameLabel = cell.viewWithTag(11) as? UILabel
        
        if indexPath.row < registeredParticipants.count {
            
            let url = registeredParticipants[indexPath.row].profileImageUrl
            image!.image = UIImage.init(named: url!)
            usernameLabel!.text = registeredParticipants[indexPath.row].username
            
        }
        return cell
    }
    
    
    
}

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}
