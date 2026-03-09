//
//  LocationManager.swift
//  TripMate
//
//  Created by iMac on 06/03/26.
//

// LocationManager.swift

import SwiftUI
import MapKit
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    private var locationUpdateCount = 0
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationUpdateCount += 1
        userLocation = locations.last?.coordinate
        print("📍 Got location [\(locationUpdateCount)]: \(locations.last?.coordinate.latitude ?? 0), \(locations.last?.coordinate.longitude ?? 0)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        print("🔐 Location permission: \(manager.authorizationStatus.rawValue)")
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}
