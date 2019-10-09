//
//  Place.swift
//  Lunchat
//
//  Created by 杨昱程 on 22/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//
import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
