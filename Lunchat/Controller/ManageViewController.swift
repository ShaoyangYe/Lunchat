//
//  ManageViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import Firebase
import MapKit

@IBDesignable

class ManageViewController: UIViewController, EventDetailViewControllerProtocol {
    
    @IBOutlet var vwView: UIView!
    
    @IBOutlet weak var scSegment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let userID:String! = Auth.auth().currentUser!.uid
    // let registered:[Int] = [0,1,2,3,4]
    // let hosting = [0,1]
    // let past = [3,4]
    // TEST
    
    var dbRef:DatabaseReference?
    var eventDetail:EventDetailViewController?
    
    var segmentIndex:Int? = nil
    var currentEventsIndex:Int?
    
    var events = [Event]()
    var registeredEvents = [Event]()
    var hostEvents = [Event]()
    var attendedEvents = [Event]()
    
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check the uid
        print(userID!)
        
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
        
    }
    
    // build different segment for registered, hosting and attended events
    @IBAction func scSegmentTapped(_ sender: Any) {
        
        segmentIndex = scSegment.selectedSegmentIndex
        
        switch segmentIndex {
            
        // Registered events segment
        case 0:
            self.vwView.backgroundColor = UIColor.white
            getData()
            
        // Hosting events segment
        case 1:
            self.vwView.backgroundColor = UIColor.white
            getData()
            
        // Attended events segment
        case 2:
            self.vwView.backgroundColor = UIColor.white
            getData()
            
        default:
            print("No segment selected")
            
        }
        
    }
    
    func getData() {
        
        // remove all the old data
        events.removeAll()
        registeredEvents.removeAll()
        hostEvents.removeAll()
        attendedEvents.removeAll()
        
        print("Start to get events")
        
        // Get all the events
        dbRef = Database.database().reference().child("events")
        
        dbRef!.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snap in snapshots {
                
                let eventDict = snap.value as! [String:Any]
                
                let eventID = snap.key
                let host = eventDict["host"] as! String
                let location = eventDict["location"] as! String
                let maxParticipants = eventDict["maxParticipants"] as! Int
                let participants = eventDict["participants"] as! [String:String]
                let past = eventDict["past"] as! Int
                let theme = eventDict["theme"] as! String
                let time = eventDict["time"] as! String
                let title = eventDict["title"] as! String
                let latitude = eventDict["latitude"] as! String
                let longitude = eventDict["longitude"] as! String
                
                let e = Event(eventID: eventID, host: host, location: location, maxParticipants: maxParticipants, participants: participants, past: past, theme: theme, time: time, title: title, latitude: latitude, longitude: longitude)
                
                self.events.append(e)
                
                print("reload ?????")
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    func dialogDismissed() {
        //self.tableView.reloadData()
    }
    
    func displayMap() {
        
        // add map
        let mapView = MKMapView.init(frame:CGRect.init(x: view.bounds.width-230, y:50 , width:170, height:170 ))
        mapView.tag = 99
        let objectAnnotation = MKPointAnnotation()
        let latitude = (self.events[currentEventsIndex!].latitude! as NSString).doubleValue
        let longitude = (self.events[currentEventsIndex!].longitude! as NSString).doubleValue
        
        objectAnnotation.coordinate = CLLocation(latitude: latitude, longitude: longitude).coordinate
        objectAnnotation.title = self.events[currentEventsIndex!].location
        objectAnnotation.subtitle = self.events[currentEventsIndex!].title
        mapView.addAnnotation(objectAnnotation)
        
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let center:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        
        mapView.setRegion(currentRegion, animated: true)
        mapView.layer.cornerRadius = 15
        eventDetail!.backgroundView.addSubview(mapView)
        //eventDetail.addSubview(mapView)
        
    }
    
}


extension ManageViewController: UITableViewDelegate, UITableViewDataSource {
    
    // UITableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // get registered events
        if self.segmentIndex == nil || self.segmentIndex == 0 {
            
            registeredEvents.removeAll()
            for n in self.events {
                
                for i in n.participants! {
                    
                    if i.key == userID && n.past == 0 {
                        
                        print("add registered events")
                        self.registeredEvents.append(n)
                        
                    }
                    
                }
                
            }
            
            print("check", registeredEvents.count)
            print("check", events.count)
            return self.registeredEvents.count
            
        }
            // get host events
        else if self.segmentIndex == 1 {
            
            // Build an array of events that are required to display
            for n in self.events {
                
                if n.host == userID && n.past == 0 {
                    
                    print("add hosting events")
                    self.hostEvents.append(n)
                    
                }
                
            }
            
            // Return the number of cells
            return self.hostEvents.count
            
            
        }
        else if self.segmentIndex == 2 {
            
            // Build an array of events that are required to display
            
            for n in self.events {
                
                for i in n.participants! {
                    
                    if i.key == userID && n.past == 1 {
                        
                        print("add attended events")
                        self.attendedEvents.append(n)
                        
                    }
                    
                }
                
            }
            
            // Return the number of cells
            return self.attendedEvents.count
            
        }
        
        return 0
        
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
        
        // show registered events
        if self.segmentIndex == nil || self.segmentIndex == 0 {
            
            if  indexPath.row < registeredEvents.count {
                
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
            
            return cell
            
        }
            // show host events
        else if self.segmentIndex == 1 {
            
            if  indexPath.row < hostEvents.count {
                
                titleLabel!.text = hostEvents[indexPath.row].title
                let themeText:String? = " " + hostEvents[indexPath.row].theme! + " "
                themeLabel!.text = themeText
                locationLabel!.text = hostEvents[indexPath.row].location
                timeLabel!.text = hostEvents[indexPath.row].time
                
                let num = hostEvents[indexPath.row].participants?.count
                var content:String = ""
                
                if num != nil {
                    
                    content = "\(num!) / \(hostEvents[indexPath.row].maxParticipants ?? 10)"
                    
                }
                
                participantsLabel!.text = content
                
            }
            
            return cell
            
        }
        else if self.segmentIndex == 2 {
            
            if  indexPath.row < attendedEvents.count {
                
                titleLabel!.text = attendedEvents[indexPath.row].title
                let themeText:String? = " " + attendedEvents[indexPath.row].theme! + " "
                themeLabel!.text = themeText
                locationLabel!.text = attendedEvents[indexPath.row].location
                timeLabel!.text = attendedEvents[indexPath.row].time
                
                let num = attendedEvents[indexPath.row].participants?.count
                var content:String = ""
                
                if num != nil {
                    
                    content = "\(num!) / \(attendedEvents[indexPath.row].maxParticipants ?? 10)"
                    
                }
                
                participantsLabel!.text = content
                
            }
            
            return cell
            
        }
        
        // Return the cell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // identify the event that is tapped
        currentEventsIndex = indexPath.row
        
        // Show the pop up for segment 0
        if eventDetail != nil && segmentIndex == 0 {
            
            // Customize the popup text
            eventDetail!.titleText = registeredEvents[indexPath.row].title!
            eventDetail!.themeText = registeredEvents[indexPath.row].theme!
            eventDetail!.timeText = registeredEvents[indexPath.row].time!
            eventDetail!.locationText = registeredEvents[indexPath.row].location!
            
            let num = registeredEvents[indexPath.row].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(registeredEvents[indexPath.row].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = registeredEvents[indexPath.row].eventID
            eventDetail!.participants = registeredEvents[indexPath.row].participants
            
        }
            
            // for segment 1
        else if eventDetail != nil && segmentIndex == 1 {
            
            // Customize the popup text
            eventDetail!.titleText = hostEvents[indexPath.row].title!
            eventDetail!.themeText = hostEvents[indexPath.row].theme!
            eventDetail!.timeText = hostEvents[indexPath.row].time!
            eventDetail!.locationText = hostEvents[indexPath.row].location!
            
            let num = hostEvents[indexPath.row].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(hostEvents[indexPath.row].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = hostEvents[indexPath.row].eventID
            eventDetail!.participants = hostEvents[indexPath.row].participants
            
        }
            
            // for segment 2
        else if eventDetail != nil && segmentIndex == 2 {
            
            // Customize the popup text
            eventDetail!.titleText = attendedEvents[indexPath.row].title!
            eventDetail!.themeText = attendedEvents[indexPath.row].theme!
            eventDetail!.timeText = attendedEvents[indexPath.row].time!
            eventDetail!.locationText = attendedEvents[indexPath.row].location!
            
            let num = attendedEvents[indexPath.row].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(attendedEvents[indexPath.row].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = attendedEvents[indexPath.row].eventID
            eventDetail!.participants = attendedEvents[indexPath.row].participants
            
        }
        else {
            
            // Customize the popup text
            eventDetail!.titleText = registeredEvents[indexPath.row].title!
            eventDetail!.themeText = registeredEvents[indexPath.row].theme!
            eventDetail!.timeText = registeredEvents[indexPath.row].time!
            eventDetail!.locationText = registeredEvents[indexPath.row].location!
            
            let num = registeredEvents[indexPath.row].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(registeredEvents[indexPath.row].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = registeredEvents[indexPath.row].eventID
            eventDetail!.participants = registeredEvents[indexPath.row].participants
            
        }
        
        // Trigger view will appear
        present(eventDetail!, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110.0
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            print("Deleted")
            
            if segmentIndex == nil || segmentIndex == 0 {
                
                let deleteID = registeredEvents[indexPath.row].eventID
                
                registeredEvents.remove(at: indexPath.row)
                var i = 0
                for n in events {
                    
                    if n.eventID == deleteID {
                        events.remove(at: i)
                    }
                    i += 1
                }
                
                Database.database().reference().child("events").child(deleteID!).child("participants").child(userID).removeValue()
                
            }
            else if segmentIndex == 1 {
                
                let deleteID = hostEvents[indexPath.row].eventID
                
                hostEvents.remove(at: indexPath.row)
                var i = 0
                for n in events {
                    
                    if n.eventID == deleteID {
                        events.remove(at: i)
                    }
                    i += 1
                }
                
                Database.database().reference().child("events").child(deleteID!).removeValue()
                
            }
            
            print("check")
            print(registeredEvents.count)
            print(events.count)
            print(indexPath.count)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
}
