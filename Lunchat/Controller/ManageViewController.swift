//
//  ManageViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable

class ManageViewController: UIViewController, EventDetailViewControllerProtocol {

    @IBOutlet var vwView: UIView!
    
    @IBOutlet weak var scSegment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    // TESTING for the user0
    let userID:String? = "NEFgkCWoMVQKzHiYb3Qrg4lEsu83"
    let registered = [0,1,2,3,4]
    let hosting = [0,1]
    let past = [3,4]
    // TEST
    
    var dbRef:DatabaseReference?
    var eventDetail:EventDetailViewController?
    
    var segmentIndex = 0
    var currentEventsIndex:Int?
    
    var events = [Event]()
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDetail = storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailViewController
        
        eventDetail?.modalPresentationStyle = .overCurrentContext
        eventDetail?.delegate = self
        
        // Set self as the delegata and datasource for the tableview
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Read data from firebase
        getData()
        tableView.reloadData()
        
    }
    
    // build different segment for registered, hosting and attended events
    @IBAction func scSegmentTapped(_ sender: Any) {
        
        segmentIndex = scSegment.selectedSegmentIndex
        print(segmentIndex)
        
        switch segmentIndex {
            
        // Registered events segment
        case 0:
            self.vwView.backgroundColor = UIColor.white
            tableView.reloadData()
            
        // Hosting events segment
        case 1:
            self.vwView.backgroundColor = UIColor.blue
            tableView.reloadData()
            
        // Attended events segment
        case 2:
            self.vwView.backgroundColor = UIColor.green
            tableView.reloadData()
            
        default:
            print("No segment selected")
            
        }
        
    }
    
    func getData() {
        
        events.removeAll()
        
        print("Start to get events")
        
        dbRef = Database.database().reference().child("events")
        
        dbRef!.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snap in snapshots {
                
                let eventDict = snap.value as! [String:Any]
                
                let eventID = eventDict["eventID"] as! Int
                let host = eventDict["host"] as! String
                let location = eventDict["location"] as! String
                let maxParticipants = eventDict["maxParticipants"] as! Int
                let participants = eventDict["participants"] as! [String]
                let past = eventDict["past"] as! Int
                let theme = eventDict["theme"] as! String
                let time = eventDict["time"] as! String
                let title = eventDict["title"] as! String
                
                let e = Event(eventID: eventID, host: host, location: location, maxParticipants: maxParticipants, participants: participants, past: past, theme: theme, time: time, title: title)
                
                self.events.append(e)
                
                print("reload ?????")
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    func dialogDismissed() {
        //self.tableView.reloadData()
    }
    
}


extension ManageViewController: UITableViewDelegate, UITableViewDataSource {
    
    // UITableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Count the number of cells
        var i = 0
        let count = self.registered.count
        var registeredEvents = [Event]()
        
        // Build an array of events that are required to display
        while i < count {
            
            for n in self.events {
                
                if self.registered[i] == n.eventID && n.past == 0 {
                    
                    print("add")
                    registeredEvents.append(n)
                    
                }
                
            }
            
            i += 1
            
        }

        // Return the number of cells
        return registeredEvents.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("start to show table view")
        
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        // Round the corner of the cell
        cell.viewWithTag(6)?.layer.cornerRadius = 10
        cell.viewWithTag(2)?.layer.cornerRadius = 10
        
        // Customize it
        let titleLabel = cell.viewWithTag(1) as? UILabel
        let themeLabel = cell.viewWithTag(2) as? UILabel
        let locationLabel = cell.viewWithTag(3) as? UILabel
        let timeLabel = cell.viewWithTag(4) as? UILabel
        let participantsLabel = cell.viewWithTag(5) as? UILabel
        
        var i = 0
        let count = self.registered.count
        var registeredEvents = [Event]()
            
        // Build an array of events that are required to display
        while i < count {
                
            for n in self.events {
                    
                if self.registered[i] == n.eventID && n.past == 0 {
                        
                    registeredEvents.append(n)
                        
                }
                    
            }
                
            i += 1
                
        }
            
        // Give the value to the element inside the cells
        if  indexPath.row < count {
                
            titleLabel!.text = registeredEvents[indexPath.row].title
            let themeText:String? = " " + registeredEvents[indexPath.row].theme! + " "
            themeLabel!.text = themeText
            locationLabel!.text = registeredEvents[indexPath.row].location
            timeLabel!.text = registeredEvents[indexPath.row].time
                
            let num = registeredEvents[indexPath.row].participants?.count
            var content:String = ""
                
            if num != nil {
                    
                content = "\(num!) / \(registeredEvents[indexPath.row].maxParticipants ?? 10)"
                    
            }
                
            participantsLabel!.text = content
                
        }
        
        // Return the cell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // identify the event that is tapped
        currentEventsIndex = registered[indexPath.row]
        
        // Show the pop up
        if eventDetail != nil && currentEventsIndex != nil{
            
            // Customize the popup text
            eventDetail!.titleText = events[currentEventsIndex!].title!
            eventDetail!.themeText = events[currentEventsIndex!].theme!
            eventDetail!.timeText = events[currentEventsIndex!].time!
            eventDetail!.locationText = events[currentEventsIndex!].location!
            
            let num = events[currentEventsIndex!].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(events[currentEventsIndex!].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
        
        }
        
        // Trigger view will appear
        present(eventDetail!, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110.0
    
    }
    
}
