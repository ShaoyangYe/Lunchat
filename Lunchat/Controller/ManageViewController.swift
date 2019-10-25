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
    let registered:[Int] = [0,1,2,3,4]
    let hosting = [0,1]
    let past = [3,4]
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
        tableView.reloadData()
        
    }
    
    // build different segment for registered, hosting and attended events
    @IBAction func scSegmentTapped(_ sender: Any) {
        
        segmentIndex = scSegment.selectedSegmentIndex
        
        switch segmentIndex {
            
        // Registered events segment
        case 0:
            self.vwView.backgroundColor = UIColor.white
            getData()
            tableView.reloadData()
            
        // Hosting events segment
        case 1:
            self.vwView.backgroundColor = UIColor.white
            getData()
            tableView.reloadData()
            
        // Attended events segment
        case 2:
            self.vwView.backgroundColor = UIColor.white
            getData()
            tableView.reloadData()
            
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
                
                let eventID = eventDict["eventID"] as! Int
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
            
            for n in self.events {
                
                for i in n.participants! {
                    
                    if i.key == userID {
                        
                        print("add registered events")
                        self.registeredEvents.append(n)
                        
                    }
                    
                }
                
            }
            
            /*
            // Count the number of cells
            var i = 0
            let count = self.registered.count
            
            // Build an array of events that are required to display
            while i < count {
                
                for n in self.events {
                    
                    if self.registered[i] == n.eventID && n.past == 0 {
                        
                        print("add registered events")
                        self.registeredEvents.append(n)
                        
                    }
                    
                }
                
                i += 1
                
            } */
            
            // Return the number of cells
            return self.registeredEvents.count
            
        }
        // get host events
        else if self.segmentIndex == 1 {
            
            // Count the number of cells
            var i = 0
            let count = self.hosting.count
            
            // Build an array of events that are required to display
            while i < count {
                
                for n in self.events {
                    
                    if self.hosting[i] == n.eventID && n.past == 0 {
                        
                        print("add hosting events")
                        self.hostEvents.append(n)
                        
                    }
                    
                }
                
                i += 1
                
            }
            
            // Return the number of cells
            return self.hostEvents.count

            
        }
        else if self.segmentIndex == 2 {
            
            // Count the number of cells
            var i = 0
            let count = self.past.count
            
            // Build an array of events that are required to display
            while i < count {
                
                for n in self.events {
                    
                    if self.past[i] == n.eventID && n.past == 1 {
                        
                        print("add attended events")
                        self.attendedEvents.append(n)
                        
                    }
                    
                }
                
                i += 1
                
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
        currentEventsIndex = registered[indexPath.row]
        
        // Show the pop up for segment 0
        if eventDetail != nil && currentEventsIndex != nil && segmentIndex == 0 {
            
            // Customize the popup text
            eventDetail!.titleText = registeredEvents[currentEventsIndex!].title!
            eventDetail!.themeText = registeredEvents[currentEventsIndex!].theme!
            eventDetail!.timeText = registeredEvents[currentEventsIndex!].time!
            eventDetail!.locationText = registeredEvents[currentEventsIndex!].location!
            
            let num = registeredEvents[currentEventsIndex!].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(registeredEvents[currentEventsIndex!].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = registeredEvents[currentEventsIndex!].eventID
            eventDetail!.participants = registeredEvents[currentEventsIndex!].participants

        }
        
        // for segment 1
        else if eventDetail != nil && currentEventsIndex != nil && segmentIndex == 1 {
            
            // Customize the popup text
            eventDetail!.titleText = hostEvents[currentEventsIndex!].title!
            eventDetail!.themeText = hostEvents[currentEventsIndex!].theme!
            eventDetail!.timeText = hostEvents[currentEventsIndex!].time!
            eventDetail!.locationText = hostEvents[currentEventsIndex!].location!
            
            let num = hostEvents[currentEventsIndex!].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(hostEvents[currentEventsIndex!].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = hostEvents[currentEventsIndex!].eventID
            eventDetail!.participants = hostEvents[currentEventsIndex!].participants
            
        }

        // for segment 2
        else if eventDetail != nil && currentEventsIndex != nil && segmentIndex == 2 {
            
            // Customize the popup text
            eventDetail!.titleText = attendedEvents[currentEventsIndex!].title!
            eventDetail!.themeText = attendedEvents[currentEventsIndex!].theme!
            eventDetail!.timeText = attendedEvents[currentEventsIndex!].time!
            eventDetail!.locationText = attendedEvents[currentEventsIndex!].location!
            
            let num = attendedEvents[currentEventsIndex!].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(attendedEvents[currentEventsIndex!].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = attendedEvents[currentEventsIndex!].eventID
            eventDetail!.participants = attendedEvents[currentEventsIndex!].participants
            
        }
        else if eventDetail != nil && currentEventsIndex != nil {
            
            // Customize the popup text
            eventDetail!.titleText = registeredEvents[currentEventsIndex!].title!
            eventDetail!.themeText = registeredEvents[currentEventsIndex!].theme!
            eventDetail!.timeText = registeredEvents[currentEventsIndex!].time!
            eventDetail!.locationText = registeredEvents[currentEventsIndex!].location!
            
            let num = registeredEvents[currentEventsIndex!].participants?.count
            var content:String = ""
            
            if num != nil {
                content = "\(num!) / \(registeredEvents[currentEventsIndex!].maxParticipants ?? 10)"
            }
            
            eventDetail!.participantsText = content
            
            eventDetail!.currentEventID = registeredEvents[currentEventsIndex!].eventID
            eventDetail!.participants = registeredEvents[currentEventsIndex!].participants

            
        }

        // Trigger view will appear
        present(eventDetail!, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110.0
    
    }
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.catNames.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    } */
    
}
