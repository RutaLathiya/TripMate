//
//  TripEntityExtensions.swift
//  TripMate
//
//  Created by iMac on 16/04/26.
//
import SwiftUI

extension TripEntity {

    // Converts NSSet to sorted array
    var membersArray: [TripMemberEntity] {
        let set = members as? Set<TripMemberEntity> ?? []
        return set.sorted { ($0.memberName ?? "") < ($1.memberName ?? "") }
    }

    // Formats "May 10 – May 13"
    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = startDate.map { formatter.string(from: $0) } ?? ""
        let end = endDate.map { formatter.string(from: $0) } ?? ""
        return "\(start) – \(end)"
    }
}
