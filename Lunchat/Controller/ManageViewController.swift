//
//  ManageViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class ManageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventProtocol {
        
    @IBOutlet var vwView: UIView!
    
    @IBOutlet weak var scSegment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
        
    // TESTING for the user0
    let userID = 0
    let registered = [0,1,2]
    let hosting = [0]
    let past = [3,4]
    // TEST
    
    var segmentIndex = 0
    
    var eventModel = EventModel()
    var events = [Event]()
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as the delegata and datasource for the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Get events to display
        eventModel.delegate = self
        eventModel.getEvent()
                
    }
    
    @IBAction func scSegmentTapped(_ sender: Any) {
        
        segmentIndex = scSegment.selectedSegmentIndex
        print(segmentIndex)
        
        switch segmentIndex {
        case 0:
            self.vwView.backgroundColor = UIColor.white
            tableView.reloadData()
            
        case 1:
            self.vwView.backgroundColor = UIColor.blue
            tableView.reloadData()
            
        case 2:
            self.vwView.backgroundColor = UIColor.green
            tableView.reloadData()
            
        default:
            print("No segment selected")
        }
        
    }
    
    // MARK:- UITableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of cells
        let count = registered.count
        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        // Customize it
        let titleLabel = cell.viewWithTag(1) as? UILabel
        let themeLabel = cell.viewWithTag(2) as? UILabel
        let locationLabel = cell.viewWithTag(3) as? UILabel
        let timeLabel = cell.viewWithTag(4) as? UILabel
        let participantsLabel = cell.viewWithTag(5) as? UILabel
        
        /*
        if titleLabel != nil {
            
            var i = 0
            let count = registered.count
            var registeredEvents = [String]()
            
            while i < count {
                
                for n in events {
                    
                    if registered[i] == n.eventID && n.title != nil{
                        
                        registeredEvents.append(n.title!)
                        
                    }
                    
                }
                
                i += 1
                
            }
            
            
            if  indexPath.row < count {
                
                titleLabel!.text = registeredEvents[indexPath.row]
                
            }
            
        } */
        
        if titleLabel != nil {
            
            var i = 0
            let count = registered.count
            var registeredEvents = [Event]()
            
            while i < count {
                
                for n in events {
                    
                    if registered[i] == n.eventID && n.title != nil{
                        
                        registeredEvents.append(n)
                        
                    }
                    
                }
                
                i += 1
                
            }
            
            
            if  indexPath.row < count {
                
                titleLabel!.text = registeredEvents[indexPath.row].title
                themeLabel!.text = registeredEvents[indexPath.row].theme
                locationLabel!.text = registeredEvents[indexPath.row].location
                timeLabel!.text = registeredEvents[indexPath.row].time
                
                let num = registeredEvents[indexPath.row].participants?.count
                var content:String = ""
                
                if num != nil {
                    
                    content = "\(num!) / \(String(describing: (registeredEvents[indexPath.row].maxParticipants)))"
                    
                }
                
                participantsLabel!.text = content
                
            }
            
        }
        
        // Return the cell
        return cell
        
    }
    
    // Events protocol methods
    func eventsRetrieved(_ events: [Event]) {
        
        // Get a reference to the event
        self.events = events
        
        // Reload the tableview
        tableView.reloadData()
        
    }
    
}
