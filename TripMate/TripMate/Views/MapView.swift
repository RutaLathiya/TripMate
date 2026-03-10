////
////  MapView.swift
////  TripMate
////
////  Created by iMac on 10/02/26.
////
//
//import SwiftUI
//import MapKit
//import CoreLocation
//import Combine
//
//// MARK: - Location Manager
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    
//    @Published var userLocation: CLLocationCoordinate2D?
//    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//    
//    
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        userLocation = locations.last?.coordinate
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//        if manager.authorizationStatus == .authorizedWhenInUse {
//            manager.startUpdatingLocation()
//        }
//    }
//}
//
//// MARK: - Map View
//struct MapView: View {
//    
//    @StateObject private var locationManager = LocationManager()
//    @State private var position = MapCameraPosition.region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
//            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
//        )
//    )
//    @State private var selectedMapStyle = 0  // 0=Standard 1=Hybrid 2=Satellite
//    @State private var searchText = ""
//    @State private var showSearch = false
//    @State private var showCompass = false
//    @State private var mapRotation = 0.0
//    @State private var showSteps = false
//    
//    
//    // stores current span for zoom calculations
//    @State private var currentSpan = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
//    @State private var currentCenter = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)

//
//    // Navigation states
//    @State private var showDirections = false
//    @State private var destinationText = ""
//    @State private var route: MKRoute?
//    @State private var showRouteInfo = false
//    @State private var travelTime = ""
//    @State private var travelDistance = ""
//    @State private var selectedTravelMode = 0  // 0=Drive 1=Walk 2=Transit
//    
//    var mapStyle: MapStyle {
//        switch selectedMapStyle {
//        case 1: return .hybrid
//        case 2: return .imagery
//        default: return .standard
//        }
//    }
//    func styleIcon() -> String {
//        switch selectedMapStyle {
//        case 1: return "square.3.layers.3d"
//        case 2: return "globe"
//        default: return "map"
//        }
//    }
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            
//            // MARK: - Map
//            Map(position: $position) {
//                // Show user location
//                UserAnnotation()
//                
//                // ✅ Show route on map
//                    if let route = route {
//                        MapPolyline(route.polyline)
//                            .stroke(.blue, lineWidth: 5)
//                    }
//            }
//            .mapStyle(mapStyle)
//            .mapControls {
//                MapCompass()
//                MapScaleView()
//            }
//            .ignoresSafeArea()
//            .onReceive(locationManager.$userLocation) { location in  // ✅ attached to Map
//                guard let location = location else { return }
//                if currentCenter.latitude == 20.5937 {
//                    currentCenter = location
//                    currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                    withAnimation {
//                        position = .region(MKCoordinateRegion(
//                            center: location,
//                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                        ))
//                    }
//                }
//            }
//            // MARK: - Top Search Bar
//            VStack(spacing: 0) {
//                HStack(spacing: 12) {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.black)
//                    
//                    TextField("Search places...", text: $searchText)
//                        .submitLabel(.search)
//                        .onSubmit {
//                            searchPlace()
//                        }
//                    
//                    if !searchText.isEmpty {
//                        Button(action: { searchText = "" }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundColor(.black)
//                        }
//                    }
//                }
//                .padding(12)
//                .background(.ultraThinMaterial)
//                .cornerRadius(15)
//                .shadow(color: .black.opacity(0.1), radius: 8)
//                .padding(.horizontal, 16)
//                .padding(.top, 8)
//                
//                Spacer()
//            }
//            
//            
//            // MARK: - Directions Button
//            VStack {
//                // below search bar
//                HStack {
//                    Button {
//                        showDirections = true
//                    } label: {
//                        HStack(spacing: 8) {
//                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
//                                .font(.system(size: 18))
//                            Text("Directions")
//                                .font(.headline)
//                        }
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color.brown)
//                        .cornerRadius(25)
//                        .shadow(color: .brown.opacity(0.4), radius: 8)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal, 16)
//                .padding(.top, 70)  // below search bar
//                
//                Spacer()
//            }
//            
//            // MARK: - Route Info Card
//            if showRouteInfo, let _ = route {
//                VStack {
//                    Spacer()
//                    
//                    VStack(spacing: 12) {
//                        // Handle bar
//                        RoundedRectangle(cornerRadius: 3)
//                            .fill(Color.gray.opacity(0.4))
//                            .frame(width: 40, height: 4)
//                        
//                        // Travel mode picker
//                        Picker("Travel Mode", selection: $selectedTravelMode) {
//                            Label("Drive", systemImage: "car.fill").tag(0)
//                            Label("Walk", systemImage: "figure.walk").tag(1)
//                            Label("Transit", systemImage: "bus.fill").tag(2)
//                        }
//                        .pickerStyle(.segmented)
//                        .onChange(of: selectedTravelMode) {
//                            getDirections(to: destinationText)
//                        }
//                        
//                        
//                        
//                        
//                        HStack {
//                            // Time
//                            VStack(alignment: .leading) {
//                                Text(travelTime)
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                Text("Travel Time")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            
//                            Spacer()
//                            
//                            // Distance
//                            VStack(alignment: .trailing) {
//                                Text(travelDistance)
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                Text("Distance")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            
//                            Spacer()
//                            
//                            // Start Navigation Button
//                            // Start Navigation Button — TWO OPTIONS
//                            HStack(spacing: 10) {
//                                
//                                // Option 1 — Open Apple Maps
//                                Button {
//                                    openInMaps()
//                                } label: {
//                                    HStack {
//                                        Image(systemName: "map.fill")
//                                        Text("Apple Maps")
//                                    }
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 15)
//                                    .padding(.vertical, 10)
//                                    .background(Color.blue)
//                                    .cornerRadius(20)
//                                }
//                                
//                                // Option 2 — Show steps inside app
//                                Button {
//                                    showSteps = true
//                                } label: {
//                                    HStack {
//                                        Image(systemName: "list.bullet")
//                                        Text("Steps")
//                                    }
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 15)
//                                    .padding(.vertical, 10)
//                                    .background(Color.green)
//                                    .cornerRadius(20)
//                                }
//                            }                        }
//                        
//                        // Clear route button
//                        Button {
//                            route = nil
//                            showRouteInfo = false
//                            destinationText = ""
//                        } label: {
//                            Text("Clear Route")
//                                .foregroundColor(.red)
//                                .font(.subheadline)
//                        }
//                    }
//                    .padding()
//                    .background(.ultraThinMaterial)
//                    .cornerRadius(20)
//                    .shadow(color: .black.opacity(0.15), radius: 10)
//                    .padding(.horizontal, 16)
//                    .padding(.bottom, 20)
//                }
//            }
//            
//            
//            
//            
//            
//            
//            
//            
//            
//            // MARK: - Right Side Controls
//            VStack(spacing: 12) {
//                Spacer()
//                
//                // My Location Button
//                MapControlButton(icon: "location.fill") {
//                    goToUserLocation()
//                }
//                
//                // Zoom In
//                MapControlButton(icon: "plus") {
//                    zoomIn()
//                }
//                
//                // Zoom Out
//                MapControlButton(icon: "minus") {
//                    zoomOut()
//                }
//            }
//            .padding(.trailing, 16)
//            .padding(.bottom, 100)
//            .frame(maxWidth: .infinity, alignment: .trailing)
//            
//            // MARK: - Bottom Map Style Picker
//            // MARK: - Floating Map Style Button
//            VStack {
//                Spacer()
//                
//                HStack {
//                    Spacer()
//                    
//                    Button {
//                        selectedMapStyle = (selectedMapStyle + 1) % 3
//                    } label: {
//                        Image(systemName: styleIcon())
//                            .font(.system(size: 20, weight: .medium))
//                            .foregroundColor(.primary)
//                            .frame(width: 44, height: 44)
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(12)
//                            .shadow(color: .black.opacity(0.15), radius: 5)
//                    }
//                    .padding(.trailing, 16)
//                    .padding(.bottom, 40)
//                }
//            }
//        }
//        //        .navigationTitle("Map")
//        //        .navigationBarTitleDisplayMode(.inline)
//        
//        .sheet(isPresented: $showDirections){
//            NavigationStack {
//                VStack(spacing: 20) {
//                    
//                    Text("Get Directions")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .padding(.top)
//                    
//                    // Destination input
//                    HStack {
//                        Image(systemName: "mappin.circle.fill")
//                            .foregroundColor(.red)
//                            .font(.title3)
//                        
//                        TextField("Enter destination...", text: $destinationText)
//                            .submitLabel(.search)
//                            .onSubmit {
//                                showDirections = false
//                                getDirections(to: destinationText)
//                            }
//                        
//                        if !destinationText.isEmpty {
//                            Button { destinationText = "" } label: {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(15)
//                    .padding(.horizontal)
//                    
//                    // Quick suggestions
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Quick Places")
//                            .font(.headline)
//                            .padding(.horizontal)
//                        
//                        ForEach(["Hospital", "Gas Station", "Restaurant", "Hotel", "ATM"], id: \.self) { place in
//                            Button {
//                                destinationText = place
//                                showDirections = false
//                                getDirections(to: place)
//                            } label: {
//                                HStack {
//                                    Image(systemName: iconFor(place))
//                                        .foregroundColor(.brown)
//                                        .frame(width: 30)
//                                    Text(place)
//                                        .foregroundColor(.primary)
//                                    Spacer()
//                                    Image(systemName: "chevron.right")
//                                        .foregroundColor(.gray)
//                                        .font(.caption)
//                                }
//                                .padding(.horizontal)
//                                .padding(.vertical, 8)
//                            }
//                            Divider().padding(.leading, 50)
//                        }
//                    }
//                    
//                    Spacer()
//                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Cancel") { showDirections = false }
//                    }
//                }
//            }
//            .presentationDetents([.medium])
//        }
//        
//        
//        .sheet(isPresented: $showSteps) {
//            NavigationStack {
//                List {
//                    if let route = route {
//                        // Route summary at top
//                        Section {
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text(travelTime)
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                    Text("Travel Time")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                Spacer()
//                                VStack(alignment: .trailing) {
//                                    Text(travelDistance)
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                    Text("Distance")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                            .padding(.vertical, 5)
//                        }
//                        
//                        // Step by step directions
//                        Section("Step by Step") {
//                            ForEach(Array(route.steps.enumerated()), id: \.offset) { index, step in
//                                if !step.instructions.isEmpty {
//                                    HStack(alignment: .top, spacing: 15) {
//                                        
//                                        // Step number circle
//                                        ZStack {
//                                            Circle()
//                                                .fill(Color.brown)
//                                                .frame(width: 28, height: 28)
//                                            Text("\(index + 1)")
//                                                .font(.caption)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(.white)
//                                        }
//                                        
//                                        VStack(alignment: .leading, spacing: 4) {
//                                            // instruction text
//                                            Text(step.instructions)
//                                                .font(.subheadline)
//                                                .foregroundColor(.primary)
//                                            
//                                            // distance for this step
//                                            if step.distance > 0 {
//                                                Text(step.distance >= 1000
//                                                     ? String(format: "%.1f km", step.distance / 1000)
//                                                     : String(format: "%.0f m", step.distance))
//                                                    .font(.caption)
//                                                    .foregroundColor(.gray)
//                                            }
//                                        }
//                                        
//                                        Spacer()
//                                    }
//                                    .padding(.vertical, 4)
//                                }
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Directions")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Done") { showSteps = false }
//                    }
//                    
//                    // Open in Apple Maps from steps too
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            showSteps = false
//                            openInMaps()
//                        } label: {
//                            HStack {
//                                Image(systemName: "map.fill")
//                                Text("Apple Maps")
//                            }
//                            .foregroundColor(.blue)
//                        }
//                    }
//                }
//            }
//            .presentationDetents([.medium, .large])
//        }
//    }
//    
//    
//    
//    
//    // Get directions from current location to destination
//    func getDirections(to destination: String) {
//        guard let userLocation = locationManager.userLocation else {
//            print("❌ No user location")
//            return
//        }
//        
//        // search for destination
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = destination
//        
//        MKLocalSearch(request: request).start { response, _ in
//            guard let destinationItem = response?.mapItems.first else { return }
//            
//            // create directions request
//            let dirRequest = MKDirections.Request()
//            dirRequest.source = MKMapItem(
//                placemark: MKPlacemark(coordinate: userLocation)
//            )
//            dirRequest.destination = destinationItem
//            
//            // set travel mode
//            switch selectedTravelMode {
//            case 1: dirRequest.transportType = .walking
//            case 2: dirRequest.transportType = .transit
//            default: dirRequest.transportType = .automobile
//            }
//            
//            // calculate route
//            MKDirections(request: dirRequest).calculate { response, _ in
//                guard let routeResult = response?.routes.first else {
//                    print("❌ No route found")
//                    return
//                }
//                
//                // ✅ update UI on main thread
//                    DispatchQueue.main.async {
//                        route = routeResult
//                        showRouteInfo = true
//                        
//                        let minutes = Int(routeResult.expectedTravelTime / 60)
//                        if minutes >= 60 {
//                            travelTime = "\(minutes / 60)h \(minutes % 60)m"
//                        } else {
//                            travelTime = "\(minutes) min"
//                        }
//                        
//                        let km = routeResult.distance / 1000
//                        if km >= 1 {
//                            travelDistance = String(format: "%.1f km", km)
//                        } else {
//                            travelDistance = String(format: "%.0f m", routeResult.distance)
//                        }
//                        
//                        withAnimation {
//                            position = .rect(routeResult.polyline.boundingMapRect)
//                        }
//                    }
//                
//                route = routeResult
//                showRouteInfo = true
//                
//                // format travel time
//                let minutes = Int(routeResult.expectedTravelTime / 60)
//                if minutes >= 60 {
//                    travelTime = "\(minutes / 60)h \(minutes % 60)m"
//                } else {
//                    travelTime = "\(minutes) min"
//                }
//                
//                // format distance
//                let km = routeResult.distance / 1000
//                if km >= 1 {
//                    travelDistance = String(format: "%.1f km", km)
//                } else {
//                    travelDistance = String(format: "%.0f m", routeResult.distance)
//                }
//                
//                // zoom map to show full route
//                withAnimation {
//                    position = .rect(routeResult.polyline.boundingMapRect)
//                }
//            }
//        }
//    }
//
//    // opens Apple Maps for real turn-by-turn navigation
//    func openInMaps() {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = destinationText
//        
//        MKLocalSearch(request: request).start { response, _ in
//            guard let item = response?.mapItems.first else { return }
//            item.openInMaps(launchOptions: [
//                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
//            ])
//        }
//    }
//
//    // icon for quick place suggestions
//    func iconFor(_ place: String) -> String {
//        switch place {
//        case "Hospital": return "cross.fill"
//        case "Gas Station": return "fuelpump.fill"
//        case "Restaurant": return "fork.knife"
//        case "Hotel": return "bed.double.fill"
//        case "ATM": return "banknote.fill"
//        default: return "mappin.fill"
//        }
//    }
//
//    // MARK: - Functions
//    
//    func goToUserLocation() {
//        if let location = locationManager.userLocation {
//            currentCenter = location
//            currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            withAnimation {
//                position = .region(MKCoordinateRegion(
//                    center: currentCenter,
//                    span: currentSpan
//                ))
//            }
//        }
//    }
//    func zoomIn() {
//        currentSpan = MKCoordinateSpan(
//            latitudeDelta: currentSpan.latitudeDelta / 2,
//            longitudeDelta: currentSpan.longitudeDelta / 2
//        )
//        withAnimation {
//            position = .region(MKCoordinateRegion(
//                center: currentCenter,
//                span: currentSpan
//            ))
//        }
//    }
//    
//    func zoomOut() {
//        currentSpan = MKCoordinateSpan(
//            latitudeDelta: min(currentSpan.latitudeDelta * 2, 180),
//            longitudeDelta: min(currentSpan.longitudeDelta * 2, 360)
//        )
//        withAnimation {
//            position = .region(MKCoordinateRegion(
//                center: currentCenter,
//                span: currentSpan
//            ))
//        }
//    }
//    
//    func searchPlace() {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//        
//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            guard let item = response?.mapItems.first else { return }
//            
//            // ✅ iOS 26 fix — use item.location directly
//            let location = item.location 
//            
//            withAnimation {
//                position = .region(MKCoordinateRegion(
//                    center: location.coordinate,   // ✅ use directly, no separate variable
//                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                ))
//            }
//            currentCenter = location.coordinate
//            currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        }
//    }
//}
//
//
//struct MapControlButton: View {
//    let icon: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: icon)
//                .font(.system(size: 18, weight: .medium))
//                .foregroundColor(.primary)
//                .frame(width: 44, height: 44)
//                .background(.ultraThinMaterial)
//                .cornerRadius(12)
//                .shadow(color: .black.opacity(0.1), radius: 5)
//        }
//    }
//}
//
//
//struct MapStyleButton: View {
//    let title: String
//    let icon: String
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 4) {
//                Image(systemName: icon)
//                    .font(.system(size: 20))
//                Text(title)
//                    .font(.caption2)
//                    .fontWeight(.medium)
//            }
//            .foregroundColor(isSelected ? .black : .white)
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 10)
//            .background(isSelected ? Color.white.opacity(0.15) : Color.clear)
//            .cornerRadius(20)
//        }
//    }
//}
//
//
//#Preview {
//    NavigationStack {
//        MapView()
//    }
//}


import SwiftUI
import MapKit
import CoreLocation
import Combine

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = MapViewModel()
    
//    var body: some View {
//        ZStack(alignment: .top) {
//            
//            // MARK: - Map
//            Map(position: $viewModel.position) {
//                UserAnnotation()
//                if let route = viewModel.route {
//                    MapPolyline(route.polyline)
//                        .stroke(.blue, lineWidth: 5)
//                }
//            }
//            .mapStyle(viewModel.mapStyle)
//            .mapControls {
//                MapCompass()
//                MapScaleView()
//            }
//            .ignoresSafeArea()
//            .onReceive(locationManager.$userLocation) { location in
//                guard let location = location else { return }
//                viewModel.handleFirstLocation(location)
//            }
//            
//            // MARK: - Search Bar
//            VStack(spacing: 0) {
//                HStack(spacing: 12) {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.black)
//                    TextField("Search places...", text: $viewModel.searchText)
//                        .submitLabel(.search)
//                        .onSubmit { viewModel.searchPlace() }
//                    if !viewModel.searchText.isEmpty {
//                        Button { viewModel.searchText = "" } label: {
//                            Image(systemName: "xmark.circle.fill").foregroundColor(.black)
//                        }
//                    }
//                }
//                .padding(12)
//                .background(.ultraThinMaterial)
//                .cornerRadius(15)
//                .shadow(color: .black.opacity(0.1), radius: 8)
//                .padding(.horizontal, 16)
//                .padding(.top, 8)
//                
//                // Directions Button
//                HStack {
//                    Button { viewModel.showDirections = true } label: {
//                        HStack(spacing: 8) {
//                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
//                            Text("Directions").font(.headline)
//                        }
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color.brown)
//                        .cornerRadius(25)
//                        .shadow(color: .brown.opacity(0.4), radius: 8)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal, 16)
//                .padding(.top, 10)
//                
//                Spacer()
//            }
//            
//            // MARK: - Route Info Card
//            if viewModel.showRouteInfo, viewModel.route != nil {
//                VStack {
//                    Spacer()
//                    VStack(spacing: 16) {
//                        
//                        // Handle bar
//                        RoundedRectangle(cornerRadius: 3)
//                            .fill(Color.gray.opacity(0.4))
//                            .frame(width: 40, height: 4)
//                        
//                        // Travel mode picker
//                        Picker("Travel Mode", selection: $viewModel.selectedTravelMode) {
//                            Label("Drive", systemImage: "car.fill").tag(0)
//                            Label("Walk", systemImage: "figure.walk").tag(1)
//                            Label("Transit", systemImage: "bus.fill").tag(2)
//                        }
//                        .pickerStyle(.segmented)
//                        .onChange(of: viewModel.selectedTravelMode) {
//                            if let location = locationManager.userLocation {
//                                viewModel.getDirections(userLocation: location)
//                            }
//                        }
//                        
//                        Divider()
//                        
//                        // Time and Distance row
//                        HStack {
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text(viewModel.travelTime)
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                Text("Travel Time")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(width: 1, height: 40)
//                            Spacer()
//                            VStack(alignment: .trailing, spacing: 2) {
//                                Text(viewModel.travelDistance)
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                Text("Distance")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        .padding(.horizontal, 8)
//                        
//                        Divider()
//                        
//                        // Buttons row
//                        HStack(spacing: 12) {
//                            Button { viewModel.openInMaps() } label: {
//                                HStack(spacing: 8) {
//                                    Image(systemName: "map.fill")
//                                        .font(.system(size: 16, weight: .semibold))
//                                    Text("Apple Maps")
//                                        .font(.subheadline)
//                                        .fontWeight(.semibold)
//                                }
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 14)
//                                .background(
//                                    LinearGradient(
//                                        colors: [Color.blue, Color.blue.opacity(0.8)],
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//                                .cornerRadius(14)
//                                .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 3)
//                            }
//                            
//                            Button { viewModel.showSteps = true } label: {
//                                HStack(spacing: 8) {
//                                    Image(systemName: "list.bullet")
//                                        .font(.system(size: 16, weight: .semibold))
//                                    Text("Steps")
//                                        .font(.subheadline)
//                                        .fontWeight(.semibold)
//                                }
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 14)
//                                .background(
//                                    LinearGradient(
//                                        colors: [Color.green, Color.green.opacity(0.8)],
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//                                .cornerRadius(14)
//                                .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
//                            }
//                        }
//                        
//                        // Clear route
//                        Button { viewModel.clearRoute() } label: {
//                            Text("Clear Route")
//                                .foregroundColor(.red.opacity(0.8))
//                                .font(.subheadline)
//                                .fontWeight(.medium)
//                        }
//                    }
//                    .padding(20)
//                    .background(
//                        RoundedRectangle(cornerRadius: 24)
//                            .fill(.ultraThinMaterial)
//                            .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: -5)
//                    )
//                    .padding(.horizontal, 16)
//                    .padding(.bottom, 90)
//                }
//            }
//
//            // MARK: - Right Controls
//            VStack(spacing: 12) {
//                Spacer()
//                MapControlButton(icon: "location.fill") {
//                    if let location = locationManager.userLocation {
//                        viewModel.goToUserLocation(location)
//                    }
//                }
//                MapControlButton(icon: "plus") { viewModel.zoomIn() }
//                MapControlButton(icon: "minus") { viewModel.zoomOut() }
//            }
//            .padding(.trailing, 16)
//            .padding(.bottom, 200)
//            .frame(maxWidth: .infinity, alignment: .trailing)
//            
//            // MARK: - Style Button
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button { viewModel.selectedMapStyle = (viewModel.selectedMapStyle + 1) % 3 } label: {
//                        Image(systemName: viewModel.styleIcon)
//                            .font(.system(size: 20, weight: .medium))
//                            .foregroundColor(.primary)
//                            .frame(width: 44, height: 44)
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(12)
//                            .shadow(color: .black.opacity(0.15), radius: 5)
//                    }
//                    .padding(.trailing, 16)
//                    .padding(.bottom, 40)
//                }
//            }
//        }
//        
//        // MARK: - Directions Sheet
//        .sheet(isPresented: $viewModel.showDirections) {
//            NavigationStack {
//                VStack(spacing: 20) {
//                    Text("Get Directions").font(.title2).fontWeight(.bold).padding(.top)
//                    
//                    HStack {
//                        Image(systemName: "mappin.circle.fill").foregroundColor(.red).font(.title3)
//                        TextField("Enter destination...", text: $viewModel.destinationText)
//                            .submitLabel(.search)
//                            .onSubmit {
//                                viewModel.showDirections = false
//                                if let location = locationManager.userLocation {
//                                    viewModel.getDirections(userLocation: location)
//                                }
//                            }
//                        if !viewModel.destinationText.isEmpty {
//                            Button { viewModel.destinationText = "" } label: {
//                                Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(15)
//                    .padding(.horizontal)
//                    
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Quick Places").font(.headline).padding(.horizontal)
//                        ForEach(["Hospital", "Gas Station", "Restaurant", "Hotel", "ATM"], id: \.self) { place in
//                            Button {
//                                viewModel.destinationText = place
//                                viewModel.showDirections = false
//                                if let location = locationManager.userLocation {
//                                    viewModel.getDirections(userLocation: location)
//                                }
//                            } label: {
//                                HStack {
//                                    Image(systemName: viewModel.iconFor(place))
//                                        .foregroundColor(.brown).frame(width: 30)
//                                    Text(place).foregroundColor(.primary)
//                                    Spacer()
//                                    Image(systemName: "chevron.right").foregroundColor(.gray).font(.caption)
//                                }
//                                .padding(.horizontal).padding(.vertical, 8)
//                            }
//                            Divider().padding(.leading, 50)
//                        }
//                    }
//                    Spacer()
//                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Cancel") { viewModel.showDirections = false }
//                    }
//                }
//            }
//            .presentationDetents([.medium])
//        }
//        
//        // MARK: - Steps Sheet
//        .sheet(isPresented: $viewModel.showSteps) {
//            NavigationStack {
//                List {
//                    if let route = viewModel.route {
//                        Section {
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text(viewModel.travelTime).font(.title2).fontWeight(.bold)
//                                    Text("Travel Time").font(.caption).foregroundColor(.gray)
//                                }
//                                Spacer()
//                                VStack(alignment: .trailing) {
//                                    Text(viewModel.travelDistance).font(.title2).fontWeight(.bold)
//                                    Text("Distance").font(.caption).foregroundColor(.gray)
//                                }
//                            }
//                            .padding(.vertical, 5)
//                        }
//                        Section("Step by Step") {
//                            ForEach(Array(route.steps.enumerated()), id: \.offset) { index, step in
//                                if !step.instructions.isEmpty {
//                                    HStack(alignment: .top, spacing: 15) {
//                                        ZStack {
//                                            Circle().fill(Color.brown).frame(width: 28, height: 28)
//                                            Text("\(index + 1)").font(.caption).fontWeight(.bold).foregroundColor(.white)
//                                        }
//                                        VStack(alignment: .leading, spacing: 4) {
//                                            Text(step.instructions).font(.subheadline)
//                                            if step.distance > 0 {
//                                                Text(step.distance >= 1000
//                                                     ? String(format: "%.1f km", step.distance / 1000)
//                                                     : String(format: "%.0f m", step.distance))
//                                                    .font(.caption).foregroundColor(.gray)
//                                            }
//                                        }
//                                        Spacer()
//                                    }
//                                    .padding(.vertical, 4)
//                                }
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Directions")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Done") { viewModel.showSteps = false }
//                    }
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            viewModel.showSteps = false
//                            viewModel.openInMaps()
//                        } label: {
//                            HStack {
//                                Image(systemName: "map.fill")
//                                Text("Apple Maps")
//                            }.foregroundColor(.blue)
//                        }
//                    }
//                }
//            }
//            .presentationDetents([.medium, .large])
//        }
//    }
    
    var body: some View {
        ZStack(alignment: .top) {
            mapLayer
            searchBarLayer
            routeInfoLayer
            controlsLayer
            styleButtonLayer
        }
        .sheet(isPresented: $viewModel.showDirections) { directionsSheet }
        .sheet(isPresented: $viewModel.showSteps) { stepsSheet }
    }

    // MARK: - Map Layer
    private var mapLayer: some View {
        Map(position: $viewModel.position) {
            UserAnnotation()
            if let route = viewModel.route {
                MapPolyline(route.polyline).stroke(.blue, lineWidth: 5)
            }
        }
        .mapStyle(viewModel.mapStyle)
        .mapControls { MapCompass(); MapScaleView() }
        .ignoresSafeArea()
        .onReceive(locationManager.$userLocation) { location in
            guard let location = location else { return }
            viewModel.handleFirstLocation(location)
        }
    }

    // MARK: - Search Bar Layer
    private var searchBarLayer: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundColor(.black)
                TextField("Search places...", text: $viewModel.searchText)
                    .submitLabel(.search)
                    .onSubmit { viewModel.searchPlace() }
                if !viewModel.searchText.isEmpty {
                    Button { viewModel.searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.black)
                    }
                }
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 8)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            HStack {
                Button { viewModel.showDirections = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                        Text("Directions").font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.brown)
                    .cornerRadius(25)
                    .shadow(color: .brown.opacity(0.4), radius: 8)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            Spacer()
        }
    }

    // MARK: - Route Info Layer
    @ViewBuilder
    private var routeInfoLayer: some View {
        if viewModel.showRouteInfo, viewModel.route != nil {
            VStack {
                Spacer()
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 40, height: 4)
                    travelModePicker
                    Divider()
                    travelInfoRow
                    Divider()
                    navigationButtonsRow
                    Button { viewModel.clearRoute() } label: {
                        Text("Clear Route")
                            .foregroundColor(.red.opacity(0.8))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: -5)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 90)
            }
        }
    }

    // MARK: - Travel Mode Picker
    private var travelModePicker: some View {
        Picker("Travel Mode", selection: $viewModel.selectedTravelMode) {
            Label("Drive", systemImage: "car.fill").tag(0)
            Label("Walk", systemImage: "figure.walk").tag(1)
            Label("Transit", systemImage: "bus.fill").tag(2)
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.selectedTravelMode) {
            if let location = locationManager.userLocation {
                viewModel.getDirections(userLocation: location)
            }
        }
    }

    // MARK: - Travel Info Row
    private var travelInfoRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.travelTime).font(.title2).fontWeight(.bold)
                Text("Travel Time").font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 1, height: 40)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(viewModel.travelDistance).font(.title2).fontWeight(.bold)
                Text("Distance").font(.caption).foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Navigation Buttons Row
    private var navigationButtonsRow: some View {
        HStack(spacing: 12) {
            Button { viewModel.openInMaps() } label: {
                HStack(spacing: 8) {
                    Image(systemName: "map.fill").font(.system(size: 16, weight: .semibold))
                    Text("Apple Maps").font(.subheadline).fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(14)
                .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            Button { viewModel.showSteps = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet").font(.system(size: 16, weight: .semibold))
                    Text("Steps").font(.subheadline).fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(14)
                .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
            }
        }
    }

    // MARK: - Controls Layer
    private var controlsLayer: some View {
        VStack(spacing: 12) {
            Spacer()
            MapControlButton(icon: "location.fill") {
                if let location = locationManager.userLocation {
                    viewModel.goToUserLocation(location)
                }
            }
            MapControlButton(icon: "plus") { viewModel.zoomIn() }
            MapControlButton(icon: "minus") { viewModel.zoomOut() }
        }
        .padding(.trailing, 16)
        .padding(.bottom, 420)      // ✅ well above the route card
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    // MARK: - Style Button Layer
    private var styleButtonLayer: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button { viewModel.selectedMapStyle = (viewModel.selectedMapStyle + 1) % 3 } label: {
                    Image(systemName: viewModel.styleIcon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.15), radius: 5)
                }
                .padding(.trailing, 16)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Directions Sheet
    private var directionsSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Get Directions").font(.title2).fontWeight(.bold).padding(.top)
                HStack {
                    Image(systemName: "mappin.circle.fill").foregroundColor(.red).font(.title3)
                    TextField("Enter destination...", text: $viewModel.destinationText)
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.showDirections = false
                            if let location = locationManager.userLocation {
                                viewModel.getDirections(userLocation: location)
                            }
                        }
                    if !viewModel.destinationText.isEmpty {
                        Button { viewModel.destinationText = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Places").font(.headline).padding(.horizontal)
                    ForEach(["Hospital", "Gas Station", "Restaurant", "Hotel", "ATM"], id: \.self) { place in
                        Button {
                            viewModel.destinationText = place
                            viewModel.showDirections = false
                            if let location = locationManager.userLocation {
                                viewModel.getDirections(userLocation: location)
                            }
                        } label: {
                            HStack {
                                Image(systemName: viewModel.iconFor(place)).foregroundColor(.brown).frame(width: 30)
                                Text(place).foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray).font(.caption)
                            }
                            .padding(.horizontal).padding(.vertical, 8)
                        }
                        Divider().padding(.leading, 50)
                    }
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { viewModel.showDirections = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Steps Sheet
    private var stepsSheet: some View {
        NavigationStack {
            List {
                if let route = viewModel.route {
                    Section {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(viewModel.travelTime).font(.title2).fontWeight(.bold)
                                Text("Travel Time").font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(viewModel.travelDistance).font(.title2).fontWeight(.bold)
                                Text("Distance").font(.caption).foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    Section("Step by Step") {
                        ForEach(Array(route.steps.enumerated()), id: \.offset) { index, step in
                            if !step.instructions.isEmpty {
                                HStack(alignment: .top, spacing: 15) {
                                    ZStack {
                                        Circle().fill(Color.brown).frame(width: 28, height: 28)
                                        Text("\(index + 1)").font(.caption).fontWeight(.bold).foregroundColor(.white)
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(step.instructions).font(.subheadline)
                                        if step.distance > 0 {
                                            Text(step.distance >= 1000
                                                 ? String(format: "%.1f km", step.distance / 1000)
                                                 : String(format: "%.0f m", step.distance))
                                                .font(.caption).foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Directions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { viewModel.showSteps = false }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.showSteps = false
                        viewModel.openInMaps()
                    } label: {
                        HStack {
                            Image(systemName: "map.fill")
                            Text("Apple Maps")
                        }.foregroundColor(.blue)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    NavigationStack{
        MapView()
    }
}
