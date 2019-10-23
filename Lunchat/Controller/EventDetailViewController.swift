//
//  EventDetailViewController.swift
//  Lunchat
//
//  Created by Jiaqing Chen on 23/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

protocol EventDetailViewControllerProtocol {
    func dialogDismissed()
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
    var buttonText = ""
    
    var delegate:EventDetailViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize the popup box
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.borderWidth = 5
        backgroundView.layer.borderColor = UIColor(red:0.98, green:0.50, blue:0.45, alpha:1.0).cgColor
       // backgroundView.layer.borderColor = UIColor.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Now the elements are loaded, set the text
        titleLabel.text = titleText
        themeLabel.text = themeText
        timeLabel.text = timeText
        locationLabel.text = locationText
        participantsLabel.text = participantsText
        
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        // Dismiss the popup
        self.dismiss(animated: true, completion: nil)
        
        // Notify delegat that popup was dismissed
        delegate?.dialogDismissed()
        
    }
    
}
