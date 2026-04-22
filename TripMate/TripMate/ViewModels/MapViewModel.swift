////
////  MapViewModel.swift
////  TripMate
////
////  Created by iMac on 06/03/26.
////
//
//import SwiftUI
//import MapKit
//import CoreLocation
//import Combine
//
//class MapViewModel: ObservableObject {
//
//    // MARK: - Map State
//    @Published var position = MapCameraPosition.region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
//            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
//        )
//    )
//    @Published var selectedMapStyle = 0
//    @Published var currentSpan = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
//    @Published var currentCenter = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
//
//    // MARK: - Search State
//    @Published var searchText = ""
//
//    // MARK: - Navigation State
//    @Published var showDirections = false
//    @Published var showSteps = false
//    @Published var showRouteInfo = false
//    @Published var destinationText = ""
//    @Published var route: MKRoute?
//    @Published var travelTime = ""
//    @Published var travelDistance = ""
//    @Published var selectedTravelMode = 0
//
//    // MARK: - Map Style
//    var mapStyle: MapStyle {
//        switch selectedMapStyle {
//        case 1: return .hybrid
//        case 2: return .imagery
//        default: return .standard
//        }
//    }
//
//    var styleIcon: String {
//        switch selectedMapStyle {
//        case 1: return "square.3.layers.3d"
//        case 2: return "globe"
//        default: return "map"
//        }
//    }
//
//    // MARK: - Location Functions
//    func goToUserLocation(_ location: CLLocationCoordinate2D) {
//        currentCenter = location
//        currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        withAnimation {
//            position = .region(MKCoordinateRegion(
//                center: currentCenter,
//                span: currentSpan
//            ))
//        }
//    }
//
//    func handleFirstLocation(_ location: CLLocationCoordinate2D) {
//        if currentCenter.latitude == 20.5937 {
//            currentCenter = location
//            currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            withAnimation {
//                position = .region(MKCoordinateRegion(
//                    center: location,
//                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                ))
//            }
//        }
//    }
//
//    // MARK: - Zoom Functions
//    func zoomIn() {
//        currentSpan = MKCoordinateSpan(
//            latitudeDelta: currentSpan.latitudeDelta / 2,
//            longitudeDelta: currentSpan.longitudeDelta / 2
//        )
//        withAnimation {
//            position = .region(MKCoordinateRegion(center: currentCenter, span: currentSpan))
//        }
//    }
//
//    func zoomOut() {
//        currentSpan = MKCoordinateSpan(
//            latitudeDelta: min(currentSpan.latitudeDelta * 2, 180),
//            longitudeDelta: min(currentSpan.longitudeDelta * 2, 360)
//        )
//        withAnimation {
//            position = .region(MKCoordinateRegion(center: currentCenter, span: currentSpan))
//        }
//    }
//
//    // MARK: - Search Function
//    func searchPlace() {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//
//        MKLocalSearch(request: request).start { response, _ in
//            guard let item = response?.mapItems.first else { return }
//            let location = item.location
//
//            DispatchQueue.main.async {
//                withAnimation {
//                    self.position = .region(MKCoordinateRegion(
//                        center: location.coordinate,
//                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                    ))
//                }
//                self.currentCenter = location.coordinate
//                self.currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            }
//        }
//    }
//
//    // MARK: - Directions Function
//    func getDirections(userLocation: CLLocationCoordinate2D) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = destinationText
//
//        MKLocalSearch(request: request).start { response, _ in
//            guard let destinationItem = response?.mapItems.first else { return }
//
//            let dirRequest = MKDirections.Request()
//            dirRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
//            dirRequest.destination = destinationItem
//
//            switch self.selectedTravelMode {
//            case 1: dirRequest.transportType = .walking
//            case 2: dirRequest.transportType = .transit
//            default: dirRequest.transportType = .automobile
//            }
//
//            MKDirections(request: dirRequest).calculate { response, _ in
//                guard let routeResult = response?.routes.first else {
//                    print("❌ No route found")
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self.route = routeResult
//                    self.showRouteInfo = true
//
//                    let minutes = Int(routeResult.expectedTravelTime / 60)
//                    self.travelTime = minutes >= 60
//                        ? "\(minutes / 60)h \(minutes % 60)m"
//                        : "\(minutes) min"
//
//                    let km = routeResult.distance / 1000
//                    self.travelDistance = km >= 1
//                        ? String(format: "%.1f km", km)
//                        : String(format: "%.0f m", routeResult.distance)
//
//                    withAnimation {
//                        self.position = .rect(routeResult.polyline.boundingMapRect)
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - Open Apple Maps
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
//    // MARK: - Clear Route
//    func clearRoute() {
//        route = nil
//        showRouteInfo = false
//        destinationText = ""
//    }
//
//    // MARK: - Icon Helper
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
//}


//
//  MapViewModel.swift
//  TripMate
//
//  Created by iMac on 06/03/26.
//

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

class MapViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {

    // MARK: - Map State
    @Published var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        )
    )
    @Published var selectedMapStyle = 0
    var currentSpan = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
    var currentCenter = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)

    // MARK: - Search State
    @Published var searchText = "" {
        didSet {
            completer.queryFragment = searchText
            if searchText.isEmpty { searchSuggestions = [] }
        }
    }
    @Published var searchSuggestions: [MKLocalSearchCompletion] = []
    private let completer = MKLocalSearchCompleter()

    // MARK: - Route State
    @Published var showSteps = false
    @Published var showRouteInfo = false
    @Published var route: MKRoute?
    @Published var travelTime = ""
    @Published var travelDistance = ""
    @Published var selectedTravelMode = 0

    // MARK: - Active Navigation State
    @Published var isNavigating = false
    @Published var currentStepIndex = 0
    @Published var currentStepInstruction = ""
    @Published var currentStepDistance = ""
    @Published var remainingTime = ""
    @Published var remainingDistance = ""

    private var destinationText = ""

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

    // MARK: - Init
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }

    // MARK: - MKLocalSearchCompleterDelegate
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchSuggestions = Array(completer.results.prefix(6))
        }
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {}

    // MARK: - Select Suggestion
    func selectSuggestion(_ result: MKLocalSearchCompletion, userLocation: CLLocationCoordinate2D?) {
        let request = MKLocalSearch.Request(completion: result)
        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let self, let item = response?.mapItems.first else { return }
            let coord = item.placemark.coordinate
            let name = [result.title, result.subtitle].filter { !$0.isEmpty }.joined(separator: ", ")
            DispatchQueue.main.async {
                self.searchText = result.title
                self.searchSuggestions = []
                self.destinationText = name
                self.currentCenter = coord
                self.currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                withAnimation {
                    self.position = .region(MKCoordinateRegion(center: coord, span: self.currentSpan))
                }
                if let loc = userLocation {
                    self.getDirections(userLocation: loc)
                }
            }
        }
    }

    // MARK: - Reverse Geocode (tap on map)
    func reverseGeocode(_ coord: CLLocationCoordinate2D, userLocation: CLLocationCoordinate2D?) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coord.latitude, longitude: coord.longitude)) { [weak self] placemarks, _ in
            guard let self else { return }
            let name: String
            if let place = placemarks?.first {
                name = [place.name, place.locality, place.administrativeArea]
                    .compactMap { $0 }.joined(separator: ", ")
            } else {
                name = "\(String(format: "%.4f", coord.latitude)), \(String(format: "%.4f", coord.longitude))"
            }
            DispatchQueue.main.async {
                self.searchText = name.isEmpty ? "Selected Location" : name
                self.searchSuggestions = []
                self.destinationText = self.searchText
                self.currentCenter = coord
                self.currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                withAnimation {
                    self.position = .region(MKCoordinateRegion(center: coord, span: self.currentSpan))
                }
                if let loc = userLocation {
                    self.getDirections(userLocation: loc)
                }
            }
        }
    }

    // MARK: - Get Directions
    func getDirections(userLocation: CLLocationCoordinate2D) {
        guard !destinationText.isEmpty else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destinationText
        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let self, let destinationItem = response?.mapItems.first else { return }
            let dirRequest = MKDirections.Request()
            dirRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
            dirRequest.destination = destinationItem
            switch self.selectedTravelMode {
            case 1: dirRequest.transportType = .walking
            case 2: dirRequest.transportType = .transit
            default: dirRequest.transportType = .automobile
            }
            MKDirections(request: dirRequest).calculate { [weak self] response, _ in
                guard let self, let routeResult = response?.routes.first else { return }
                DispatchQueue.main.async {
                    self.route = routeResult
                    self.showRouteInfo = true
                    let minutes = Int(routeResult.expectedTravelTime / 60)
                    self.travelTime = minutes >= 60
                        ? "\(minutes / 60)h \(minutes % 60)m" : "\(minutes) min"
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

    // MARK: - Start Navigation
    func startNavigation() {
        guard let route = route, !route.steps.isEmpty else { return }
        isNavigating = true
        showRouteInfo = false
        currentStepIndex = 0
        updateCurrentStep()
        remainingTime = travelTime
        remainingDistance = travelDistance
    }

    // MARK: - Update Step from user location
    func updateNavigationStep(userLocation: CLLocationCoordinate2D) {
        guard isNavigating, let route = route else { return }
        let steps = route.steps.filter { !$0.instructions.isEmpty }
        guard currentStepIndex < steps.count else { return }

        let step = steps[currentStepIndex]
        let stepCoord = step.polyline.coordinate
        let userCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let stepCL = CLLocation(latitude: stepCoord.latitude, longitude: stepCoord.longitude)
        let distToStep = userCL.distance(from: stepCL)

        // Auto-advance if within 30 m of step endpoint
        if distToStep < 30 && currentStepIndex + 1 < steps.count {
            currentStepIndex += 1
            updateCurrentStep()
        }

        // Keep map centered on user during navigation
        withAnimation(.easeInOut(duration: 0.5)) {
            position = .region(MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ))
        }
    }

    func updateCurrentStep() {
        guard let route = route else { return }
        let steps = route.steps.filter { !$0.instructions.isEmpty }
        guard currentStepIndex < steps.count else {
            currentStepInstruction = "You have arrived"
            currentStepDistance = ""
            return
        }
        let step = steps[currentStepIndex]
        currentStepInstruction = step.instructions
        currentStepDistance = step.distance >= 1000
            ? String(format: "%.1f km", step.distance / 1000)
            : String(format: "%.0f m", step.distance)
    }

    func nextStep() {
        guard let route = route else { return }
        let steps = route.steps.filter { !$0.instructions.isEmpty }
        if currentStepIndex + 1 < steps.count {
            currentStepIndex += 1
            updateCurrentStep()
        }
    }

    func previousStep() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
            updateCurrentStep()
        }
    }

    func stopNavigation() {
        isNavigating = false
        currentStepIndex = 0
        currentStepInstruction = ""
        currentStepDistance = ""
        // Zoom back out to show full route
        if let route = route {
            withAnimation {
                position = .rect(route.polyline.boundingMapRect)
            }
            showRouteInfo = true
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
        isNavigating = false
        searchText = ""
        destinationText = ""
        searchSuggestions = []
        currentStepIndex = 0
        currentStepInstruction = ""
    }

    // MARK: - Location Helpers
    func handleFirstLocation(_ location: CLLocationCoordinate2D) {
        guard currentCenter.latitude == 20.5937 else { return }
        currentCenter = location
        currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        withAnimation {
            position = .region(MKCoordinateRegion(center: location, span: currentSpan))
        }
    }

    func goToUserLocation(_ location: CLLocationCoordinate2D) {
        currentCenter = location
        currentSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        withAnimation {
            position = .region(MKCoordinateRegion(center: currentCenter, span: currentSpan))
        }
    }

    func zoomIn() {
        currentSpan = MKCoordinateSpan(
            latitudeDelta: currentSpan.latitudeDelta / 2,
            longitudeDelta: currentSpan.longitudeDelta / 2)
        withAnimation { position = .region(MKCoordinateRegion(center: currentCenter, span: currentSpan)) }
    }

    func zoomOut() {
        currentSpan = MKCoordinateSpan(
            latitudeDelta: min(currentSpan.latitudeDelta * 2, 180),
            longitudeDelta: min(currentSpan.longitudeDelta * 2, 360))
        withAnimation { position = .region(MKCoordinateRegion(center: currentCenter, span: currentSpan)) }
    }

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
