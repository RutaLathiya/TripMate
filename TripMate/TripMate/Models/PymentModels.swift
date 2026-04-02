//
//  PymentModels.swift
//  TripMate
//
//  Created by iMac on 02/04/26.
//

//// Payment Module Data Models
//
//import Foundation
//
//// MARK: - Enums
//
//enum PaymentStatus: String, CaseIterable {
//    case success = "success"
//    case pending = "pending"
//    case failed = "failed"
//    case initiated = "initiated"
//    case processing = "processing"
//
//    var displayName: String {
//        rawValue.capitalized
//    }
//
//    var emoji: String {
//        switch self {
//        case .success:   return "✅"
//        case .pending:   return "🕐"
//        case .failed:    return "❌"
//        case .initiated: return "🔄"
//        case .processing: return "⏳"
//        }
//    }
//}
//
//enum PaymentMethod: String, CaseIterable, Identifiable {
//    case upi    = "UPI"
//    case card   = "Card"
//    case cash   = "Cash"
//    case bank   = "Bank Transfer"
//
//    var id: String { rawValue }
//
//    var icon: String {
//        switch self {
//        case .upi:  return "indianrupeesign.circle.fill"
//        case .card: return "creditcard.fill"
//        case .cash: return "banknote.fill"
//        case .bank: return "building.columns.fill"
//        }
//    }
//
//    var requiresDetails: Bool {
//        switch self {
//        case .upi, .card, .bank: return true
//        case .cash: return false
//        }
//    }
//}
//
//// MARK: - Models
//
//struct TripMember: Identifiable, Hashable {
//    let id: Int
//    let name: String
//    let phone: String
//    var avatarColor: String // hex
//}
//
//struct Payment: Identifiable {
//    let id: Int
//    let tripId: Int
//    let payerMember: TripMember
//    let receiverMember: TripMember
//    var amount: Double
//    var method: PaymentMethod
//    var date: Date
//    var status: PaymentStatus
//    var razorpayOrderId: String?
//}
//
//struct TransactionHistory: Identifiable {
//    let id: Int
//    let paymentId: Int
//    var status: PaymentStatus
//    var timestamp: Date
//    var remarks: String?
//}
//
//struct Settlement: Identifiable {
//    let id = UUID()
//    let fromMember: TripMember
//    let toMember: TripMember
//    let amount: Double
//    var isPaid: Bool = false
//}
//
//// MARK: - Mock Data
//
//struct MockData {
//    static let members: [TripMember] = [
//        TripMember(id: 1, name: "Aryan",  phone: "9876543210", avatarColor: "#FF6B6B"),
//        TripMember(id: 2, name: "Priya",  phone: "9123456789", avatarColor: "#4ECDC4"),
//        TripMember(id: 3, name: "Raj",    phone: "9988776655", avatarColor: "#45B7D1"),
//        TripMember(id: 4, name: "Sneha",  phone: "9871234560", avatarColor: "#96CEB4"),
//        TripMember(id: 5, name: "You",    phone: "9000000001", avatarColor: "#6C63FF"),
//    ]
//
//    static let settlements: [Settlement] = [
//        Settlement(fromMember: members[4], toMember: members[0], amount: 850),
//        Settlement(fromMember: members[4], toMember: members[2], amount: 1200),
//        Settlement(fromMember: members[1], toMember: members[4], amount: 450),
//        Settlement(fromMember: members[3], toMember: members[2], amount: 600),
//    ]
//
//    static let payments: [Payment] = [
//        Payment(id: 1, tripId: 1, payerMember: members[4], receiverMember: members[0],
//                amount: 850, method: .upi, date: Date().addingTimeInterval(-86400 * 2),
//                status: .success, razorpayOrderId: "order_ABC123"),
//        Payment(id: 2, tripId: 1, payerMember: members[1], receiverMember: members[4],
//                amount: 450, method: .card, date: Date().addingTimeInterval(-86400),
//                status: .pending, razorpayOrderId: nil),
//        Payment(id: 3, tripId: 1, payerMember: members[3], receiverMember: members[2],
//                amount: 600, method: .cash, date: Date().addingTimeInterval(-3600),
//                status: .success, razorpayOrderId: nil),
//        Payment(id: 4, tripId: 1, payerMember: members[4], receiverMember: members[2],
//                amount: 1200, method: .upi, date: Date(),
//                status: .processing, razorpayOrderId: "order_XYZ789"),
//    ]
//
//    static let transactions: [TransactionHistory] = [
//        TransactionHistory(id: 1, paymentId: 1, status: .initiated,   timestamp: Date().addingTimeInterval(-86400 * 2 - 120), remarks: nil),
//        TransactionHistory(id: 2, paymentId: 1, status: .processing,  timestamp: Date().addingTimeInterval(-86400 * 2 - 60),  remarks: nil),
//        TransactionHistory(id: 3, paymentId: 1, status: .success,     timestamp: Date().addingTimeInterval(-86400 * 2),       remarks: "UPI transfer successful"),
//        TransactionHistory(id: 4, paymentId: 2, status: .initiated,   timestamp: Date().addingTimeInterval(-86400),            remarks: nil),
//        TransactionHistory(id: 5, paymentId: 2, status: .pending,     timestamp: Date().addingTimeInterval(-82800),            remarks: "Awaiting bank confirmation"),
//        TransactionHistory(id: 6, paymentId: 4, status: .initiated,   timestamp: Date().addingTimeInterval(-600),              remarks: nil),
//        TransactionHistory(id: 7, paymentId: 4, status: .processing,  timestamp: Date().addingTimeInterval(-300),              remarks: "UPI timeout, retrying"),
//    ]
//}



// MARK: - PaymentModels.swift
// TripMate — Lightweight payment models
// These sit alongside your existing Expense/ExpenseMember models

import Foundation

// MARK: - Payment Method
enum PaymentMethod: String, CaseIterable, Identifiable {
    case upi  = "UPI"
    case card = "Card"
    case cash = "Cash"
    case bank = "Bank Transfer"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .upi:  return "indianrupeesign.circle.fill"
        case .card: return "creditcard.fill"
        case .cash: return "banknote.fill"
        case .bank: return "building.columns.fill"
        }
    }
}

// MARK: - Payment Status
enum PaymentStatus: String {
    case success    = "Success"
    case pending    = "Pending"
    case failed     = "Failed"
    case processing = "Processing"

    var icon: String {
        switch self {
        case .success:    return "checkmark.circle.fill"
        case .pending:    return "clock.fill"
        case .failed:     return "xmark.circle.fill"
        case .processing: return "arrow.triangle.2.circlepath"
        }
    }

    var color: String {
        switch self {
        case .success:    return "green"
        case .pending:    return "orange"
        case .failed:     return "red"
        case .processing: return "accent"
        }
    }
}

// MARK: - Payment Record
// Saved locally after a successful Razorpay payment
struct PaymentRecord: Identifiable {
    let id: UUID = UUID()
    let fromName: String       // who paid
    let toName: String         // who received
    let amount: Double
    let method: PaymentMethod
    let status: PaymentStatus
    let date: Date
    let razorpayPaymentId: String?
    let note: String
}

// MARK: - Payment Store (simple in-memory store, replace with CoreData/API later)
final class PaymentStore: ObservableObject {
    @Published private(set) var records: [PaymentRecord] = []

    func add(_ record: PaymentRecord) {
        records.insert(record, at: 0) // newest first
    }

    // Helper: get all payments for a specific trip member
    func records(involving name: String) -> [PaymentRecord] {
        records.filter { $0.fromName == name || $0.toName == name }
    }

    // Helper: total paid out by a member
    func totalPaid(by name: String) -> Double {
        records.filter { $0.fromName == name && $0.status == .success }.reduce(0) { $0 + $1.amount }
    }
}
