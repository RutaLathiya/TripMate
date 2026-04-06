//
//  Settlement.swift
//  TripMate
//
//  Created by iMac on 06/04/26.
//

import Foundation

struct Settlement: Identifiable {
    var id: UUID = UUID()
    var fromName: String
    var toName: String
    var amount: Double
    var isPaid: Bool = false
}
