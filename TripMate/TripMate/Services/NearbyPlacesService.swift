//
//  NearbyPlacesService.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import MapKit
import Combine
import SwiftUI

struct NearbyPlace: Identifiable {
    let id = UUID()
    let name: String
    let category: SOSCategory
    let coordinate: CLLocationCoordinate2D
    let mapItem: MKMapItem
}

enum SOSCategory: String, CaseIterable {
    case hospital  = "Hospitals"
    case garage    = "Garages"
    case hotel     = "Hotels"
    case police    = "Police"

    var icon: String {
        switch self {
        case .hospital: return "cross.circle.fill"
        case .garage:   return "wrench.and.screwdriver.fill"
        case .hotel:    return "bed.double.fill"
        case .police:   return "shield.fill"
        }
    }

    var color: Color {
        switch self {
        case .hospital: return Color(red: 1.0, green: 0.2, blue: 0.2)
        case .garage:   return Color(red: 0.9, green: 0.6, blue: 0.1)
        case .hotel:    return Color(red: 0.3, green: 0.6, blue: 0.9)
        case .police:   return Color(red: 0.3, green: 0.4, blue: 0.9)
        }
    }

    var searchQuery: String {
        switch self {
        case .hospital: return "hospital"
        case .garage:   return "car repair garage"
        case .hotel:    return "hotel"
        case .police:   return "police station"
        }
    }
}

class NearbyPlacesService: ObservableObject {
    @Published var places: [NearbyPlace] = []
    @Published var isLoading = false

    func search(near location: CLLocation, category: SOSCategory) {
        isLoading = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = category.searchQuery
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        MKLocalSearch(request: request).start { [weak self] response, _ in
            DispatchQueue.main.async {
                self?.isLoading = false
                let results = response?.mapItems.prefix(5).map { item in
                    NearbyPlace(
                        name: item.name ?? "Unknown",
                        category: category,
                        coordinate: item.placemark.coordinate,
                        mapItem: item
                    )
                } ?? []
                self?.places.append(contentsOf: results)
            }
        }
    }

    func searchAll(near location: CLLocation) {
        places = []
        for category in SOSCategory.allCases {
            search(near: location, category: category)
        }
    }
}
