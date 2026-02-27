//
//  MapView.swift
//  TripMate
//
//  Created by iMac on 10/02/26.
//

//import SwiftUI
//import MapKit
//
//struct MapView: View {
//    @State private var position = MapCameraPosition.region(
//            MKCoordinateRegion(
//                center: CLLocationCoordinate2D(
//                    latitude: 0,
//                    longitude: 0
//                ),
//                span: MKCoordinateSpan(
//                    latitudeDelta: 180,//140
//                    longitudeDelta: 360//0.05//360
//                )
//            )
//        )
//    var body: some View {
//        //Text("this is the map")
//        Map(position: $position)
//            .ignoresSafeArea()
//          //.mapStyle(.standard)
//         //.mapStyle(.imagery)
//         .mapStyle(.hybrid)
//    }
//}
//#Preview {
//    MapView()
//}

import SwiftUI
import MapKit
import CoreLocation
import Combine

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
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
        userLocation = locations.last?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}

// MARK: - Map View
struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        )
    )
    @State private var selectedMapStyle = 0          // 0=Standard 1=Hybrid 2=Satellite
    @State private var searchText = ""
    @State private var showSearch = false
    @State private var showCompass = false
    @State private var mapRotation = 0.0
    
    var mapStyle: MapStyle {
        switch selectedMapStyle {
        case 1: return .hybrid
        case 2: return .imagery
        default: return .standard
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Map
            Map(position: $position) {
                // Show user location
                UserAnnotation()
            }
            .mapStyle(mapStyle)
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            
            // MARK: - Top Search Bar
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search places...", text: $searchText)
                        .submitLabel(.search)
                        .onSubmit {
                            searchPlace()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 8)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                Spacer()
            }
            
            // MARK: - Right Side Controls
            VStack(spacing: 12) {
                Spacer()
                
                // My Location Button
                MapControlButton(icon: "location.fill") {
                    goToUserLocation()
                }
                
                // Zoom In
                MapControlButton(icon: "plus") {
                    zoomIn()
                }
                
                // Zoom Out
                MapControlButton(icon: "minus") {
                    zoomOut()
                }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            // MARK: - Bottom Map Style Picker
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    MapStyleButton(title: "Standard", icon: "map", isSelected: selectedMapStyle == 0) {
                        selectedMapStyle = 0
                    }
                    MapStyleButton(title: "Hybrid", icon: "map.fill", isSelected: selectedMapStyle == 1) {
                        selectedMapStyle = 1
                    }
                    MapStyleButton(title: "Satellite", icon: "globe", isSelected: selectedMapStyle == 2) {
                        selectedMapStyle = 2
                    }
                }
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.15), radius: 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Functions
    
    func goToUserLocation() {
        if let location = locationManager.userLocation {
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }
        }
    }
    
    func zoomIn() {
        withAnimation {
            if case .region(let region) = position {
                position = .region(MKCoordinateRegion(
                    center: region.center,
                    span: MKCoordinateSpan(
                        latitudeDelta: region.span.latitudeDelta / 2,
                        longitudeDelta: region.span.longitudeDelta / 2
                    )
                ))
            }
        }
    }
    
    func zoomOut() {
        withAnimation {
            if case .region(let region) = position {
                position = .region(MKCoordinateRegion(
                    center: region.center,
                    span: MKCoordinateSpan(
                        latitudeDelta: min(region.span.latitudeDelta * 2, 180),
                        longitudeDelta: min(region.span.longitudeDelta * 2, 360)
                    )
                ))
            }
        }
    }
    
    func searchPlace() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let item = response?.mapItems.first {
                withAnimation {
                    position = .region(MKCoordinateRegion(
                        center: item.placemark.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
        }
    }
}

// MARK: - Reusable Control Button
struct MapControlButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
        }
    }
}

// MARK: - Map Style Button
struct MapStyleButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .brown : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color.brown.opacity(0.15) : Color.clear)
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        MapView()
    }
}
