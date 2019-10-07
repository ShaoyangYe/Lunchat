//
//  EventModel.swift
//  Lunchat
//
//  Created by Jiaqing Chen on 7/10/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation

protocol EventProtocol {
    func eventsRetrieved (_ events:[Event])
}

class EventModel {
    
    var delegate:EventProtocol?
    
    func getEvent() {
        
        // Fetch the event
        getLocalJsonFile()
    }
    
    func getLocalJsonFile() {
        
        // Get bundle path to json file
        let path = Bundle.main.path(forResource: "TEST_eventsData", ofType: "json")
        print("Find the path")
        
        // Double check that the path isn't nil
        guard path != nil else {
            print("can't find the json datafile.")
            return
        }
        
        // Create URL onject from the path
        let url = URL(fileURLWithPath: path!)
        
        // Get the data from the URL
        do {
            // Get the data from the URL
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            let array = try decoder.decode([Event].self, from: data)
            
            // Notify the delegate of the retrieved events
            delegate?.eventsRetrieved(array)

        }
        catch {
            print("Failed to get the data")
        }
        
        print("Success to get the data")
    }
    
    func getRemoteJSONFile() {
        
    }
}
