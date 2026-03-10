//
//  TripModelsView.swift
//  TripMate
//
//  Created by iMac on 10/03/26.
//

// TripModels.swift
// TripMate
// Shared models, enums, and shapes used across Create Trip views

import SwiftUI
import MapKit

// MARK: - Models

struct TripModelsView: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D

    static func == (lhs: TripModelsView, rhs: TripModelsView) -> Bool {
        lhs.id == rhs.id
    }
}

struct TripStop: Identifiable {
    let id = UUID()
    var location: TripModelsView
    var index: Int
}

struct PackItem: Identifiable {
    let id = UUID()
    var text: String
    var isChecked: Bool = false
}

struct TripFriend: Identifiable {
    let id = UUID()
    var name: String
    var phone: String
    var isLinked: Bool       // true = linked to a user account
    var avatarInitials: String {
        let parts = name.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last  = parts.count > 1 ? parts.last?.prefix(1) ?? "" : ""
        return "\(first)\(last)".uppercased()
    }
}

// MARK: - Section Enum

enum TripSection: String, CaseIterable {
    case route   = "ROUTE"
    case stops   = "STOPS"
    case pack    = "PACK LIST"
    case friends = "FRIENDS"

    var icon: String {
        switch self {
        case .route:   return "map"
        case .stops:   return "mappin"
        case .pack:    return "bag"
        case .friends: return "person.2"
        }
    }
}

// MARK: - Route Preview Shape

struct RoutePreviewShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.05, y: h * 0.7))
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.3),
            control1: CGPoint(x: w * 0.2,  y: h * 0.1),
            control2: CGPoint(x: w * 0.35, y: h * 0.55)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.95, y: h * 0.2),
            control1: CGPoint(x: w * 0.65, y: h * 0.05),
            control2: CGPoint(x: w * 0.8,  y: h * 0.4)
        )
        return path
    }
}
