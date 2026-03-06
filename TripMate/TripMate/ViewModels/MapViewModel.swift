//
//  MapViewModel.swift
//  TripMate
//
//  Created by iMac on 06/03/26.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

class MapViewModel: ObservableObject {
    
    // MARK: - Map State
    @Published var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        )
    )
    @Published var selectedMapStyle = 0
    @Published var currentSpan = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
    @Published var currentCenter = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
    
    // MARK: - Search State
    @Published var searchText = ""
    
    // MARK: - Navigation State
    @Published var showDirections = false
    @Published var showSteps = false
    @Published var showRouteInfo = false
    @Published var destinationText = ""
    @Published var route: MKRoute?
    @Published var travelTime = ""
    @Published var travelDistance = ""
    @Published var selectedTravelMode = 0
    
    // MARK: - Map Style
    var mapStyle: MapStyle {
        switch selectedMapStyle {
        case 1: return .hybrid
        case 2: return .imagery
        default: return .standard
        }
    }
    
    var styleIcon: String {
        switch selectedMapStyle {
        case 1: return "square.3.layers.3d"
        case 2: return "globe"
        default: return "map"
        }
    }
    
    // MARK: - Location Functions
    func goToUserLocation(_ location: CLLocationCoordinate2D) {
        currentCenter = location
        currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        withAnimation {
            position = .region(MKCoordinateRegion(
                center: currentCenter,
                span: currentSpan
            ))
        }
    }
    
    func handleFirstLocation(_ location: CLLocationCoordinate2D) {
        if currentCenter.latitude == 20.5937 {
            currentCenter = location
            currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }
        }
    }
    
    // MARK: - Zoom Functions
    func zoomIn() {
        currentSpan = MKCoordinateSpan(
            latitudeDelta: currentSpan.latitudeDelta / 2,
            longitudeDelta: currentSpan.longitudeDelta / 2
        )
        withAnimation {
            position = .region(MKCoordinateRegion(center: currentCenter, span: currentSpan))
        }
    }
    
    func zoomOut() {
        currentSpan = MKCoordinateSpan(
            latitudeDelta: min(currentSpan.latitudeDelta * 2, 180),
            longitudeDelta: min(currentSpan.longitudeDelta * 2, 360)
        )
        withAnimation {
            position = .region(MKCoordinateRegion(center: currentCenter, span: currentSpan))
        }
    }
    
    // MARK: - Search Function
    func searchPlace() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        MKLocalSearch(request: request).start { response, _ in
            guard let item = response?.mapItems.first else { return }
            let location = item.location
            
            DispatchQueue.main.async {
                withAnimation {
                    self.position = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
                self.currentCenter = location.coordinate
                self.currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            }
        }
    }
    
    // MARK: - Directions Function
    func getDirections(userLocation: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destinationText
        
        MKLocalSearch(request: request).start { response, _ in
            guard let destinationItem = response?.mapItems.first else { return }
            
            let dirRequest = MKDirections.Request()
            dirRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
            dirRequest.destination = destinationItem
            
            switch self.selectedTravelMode {
            case 1: dirRequest.transportType = .walking
            case 2: dirRequest.transportType = .transit
            default: dirRequest.transportType = .automobile
            }
            
            MKDirections(request: dirRequest).calculate { response, _ in
                guard let routeResult = response?.routes.first else {
                    print("❌ No route found")
                    return
                }
                
                DispatchQueue.main.async {
                    self.route = routeResult
                    self.showRouteInfo = true
                    
                    let minutes = Int(routeResult.expectedTravelTime / 60)
                    self.travelTime = minutes >= 60
                        ? "\(minutes / 60)h \(minutes % 60)m"
                        : "\(minutes) min"
                    
                    let km = routeResult.distance / 1000
                    self.travelDistance = km >= 1
                        ? String(format: "%.1f km", km)
                        : String(format: "%.0f m", routeResult.distance)
                    
                    withAnimation {
                        self.position = .rect(routeResult.polyline.boundingMapRect)
                    }
                }
            }
        }
    }
    
    // MARK: - Open Apple Maps
    func openInMaps() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destinationText
        
        MKLocalSearch(request: request).start { response, _ in
            guard let item = response?.mapItems.first else { return }
            item.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        }
    }
    
    // MARK: - Clear Route
    func clearRoute() {
        route = nil
        showRouteInfo = false
        destinationText = ""
    }
    
    // MARK: - Icon Helper
    func iconFor(_ place: String) -> String {
        switch place {
        case "Hospital": return "cross.fill"
        case "Gas Station": return "fuelpump.fill"
        case "Restaurant": return "fork.knife"
        case "Hotel": return "bed.double.fill"
        case "ATM": return "banknote.fill"
        default: return "mappin.fill"
        }
    }
}
