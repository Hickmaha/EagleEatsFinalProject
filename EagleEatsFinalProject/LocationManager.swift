//
//  LocationManager.swift
//  PlaceLookupDemo
//
//  Created by Halen Hickman-Goveia on 12/1/24.
//

import Foundation
import MapKit
import SwiftUI

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    //Always change info.plist- privacy - location when in usage description
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    private let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var errorMessage: String?
    var locationUpdated: ((CLLocation)->Void)?
    
   
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // Remember to update Info.plist!
        locationManager.delegate = self
    }
    func getRegionAroundCurrentLocation(radiusInMeters: CLLocationDistance = 10000)->MKCoordinateRegion? {
        guard let location = location else {return nil}
        
        return MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radiusInMeters,
            longitudinalMeters: radiusInMeters
        )
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {return}
        location = newLocation
//        Callback function
        locationUpdated?(newLocation)
        //uncomment this when you want location only once
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Manager: Authorization Granted")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location Manager: Authorization Denied")
            errorMessage = "Location Manager Access Denied"
            manager.stopUpdatingLocation()
        case .notDetermined:
            print("Location Manager: Authorization Not Determined")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
        print("Error Location Manager \(errorMessage ?? "n/a")")
    }
}
