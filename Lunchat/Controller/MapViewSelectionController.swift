//
//  ManageViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol MapViewSelectionControllerDelegate : NSObjectProtocol{
    func doSomethingWith(data: String, latitude: CLLocationDegrees, longtitude: CLLocationDegrees)
}

class MapViewSelectionController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    var latitudeall: CLLocationDegrees = 0.0
    var longtitudeall: CLLocationDegrees = 0.0
    
    weak var delegate : MapViewSelectionControllerDelegate?
    
    
    override func viewDidLoad() {
        
        //隐藏toolbar
        self.tabBarController?.tabBar.isHidden = true
        //隐藏toolbar
        myMap.delegate = self
        super.viewDidLoad()
        checkLocationServices()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(onClickingReturn))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        //        if let location = locationManager.location?.coordinate {
        //            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //            myMap.setRegion(region, animated: true)
        //        }
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let center:CLLocation = CLLocation(latitude: -37.796915927734375, longitude: 144.96056159442693)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                  span: currentLocationSpan)
        
        
        myMap.setRegion(currentRegion, animated: true)
        myMap.userTrackingMode = .follow
        myMap.userLocation.title  = "My position"
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func startTackingUserLocation() {
        myMap.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: myMap)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = myMap.centerCoordinate.latitude
        let longitude = myMap.centerCoordinate.longitude
        
        latitudeall = latitude
        longtitudeall = longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    @objc func onClickingReturn() {
        if let delegate = delegate{
            delegate.doSomethingWith(data: addressLabel.text ?? "nil", latitude: latitudeall, longtitude: longtitudeall)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MapViewSelectionController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewSelectionController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
}

