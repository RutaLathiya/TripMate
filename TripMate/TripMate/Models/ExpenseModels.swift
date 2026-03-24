//
//  ExpenseModels.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//

import SwiftUI
import Combine

// MARK: - Expense Category
enum ExpenseCategory: String, CaseIterable, Codable {
    case food       = "Food"
    case fuel       = "Fuel"
    case hotel      = "Hotel"
    case transport  = "Transport"
    case activity   = "Activity"
    case shopping   = "Shopping"
    case medical    = "Medical"
    case other      = "Other"
    
    var icon: String {
        switch self {
        case .food:      return "fork.knife"
        case .fuel:      return "fuelpump.fill"
        case .hotel:     return "bed.double.fill"
        case .transport: return "car.fill"
        case .activity:  return "figure.hiking"
        case .shopping:  return "bag.fill"
        case .medical:   return "cross.fill"
        case .other:     return "ellipsis.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .food:      return "orange"
        case .fuel:      return "red"
        case .hotel:     return "purple"
        case .transport: return "blue"
        case .activity:  return "green"
        case .shopping:  return "pink"
        case .medical:   return "red"
        case .other:     return "gray"
        }
    }
}

// MARK: - Split Type
enum SplitType: String, CaseIterable, Codable {
    case equal  = "Equal"
    case custom = "Custom"
}

// MARK: - Expense Member
struct ExpenseMember: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var shareAmount: Double = 0
    var isPaid: Bool = false
}

// MARK: - Expense
struct Expense: Identifiable, Codable {
    var id = UUID()
    var title: String
    var amount: Double
    var category: ExpenseCategory
    var date: Date
    var payerName: String
    var members: [ExpenseMember]
    var splitType: SplitType
    var notes: String = ""
    
    // computed — how much each member owes
    var equalShare: Double {
        guard members.count > 0 else { return 0 }
        return amount / Double(members.count)
    }
    
    // total paid back
    var totalSettled: Double {
        members.filter { $0.isPaid }.reduce(0) { $0 + $1.shareAmount }
    }
    
    var isFullySettled: Bool {
        members.allSatisfy { $0.isPaid }
    }
}

// MARK: - Expense Store (holds all expenses for a trip)
class ExpenseStore: ObservableObject {
    @Published var expenses: [Expense] = []
    
    // total spent
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    // what each person owes across all expenses
    func balances(for members: [String]) -> [String: Double] {
        var balances: [String: Double] = [:]
        for member in members {
            balances[member] = 0
        }
        for expense in expenses {
            for member in expense.members {
                let share = expense.splitType == .equal
                    ? expense.equalShare
                    : member.shareAmount
                // if member is payer, they are owed
                if member.name == expense.payerName {
                    balances[member.name, default: 0] += (expense.amount - share)
                } else {
                    balances[member.name, default: 0] -= share
                }
            }
        }
        return balances
    }
    
    // simplified debts — who pays whom
    func settlements() -> [(from: String, to: String, amount: Double)] {
        var result: [(from: String, to: String, amount: Double)] = []
        let bal = balances(for: Array(Set(expenses.flatMap { $0.members.map { $0.name } })))
        
        var debtors  = bal.filter { $0.value < 0 }.sorted { $0.value < $1.value }
        var creditors = bal.filter { $0.value > 0 }.sorted { $0.value > $1.value }
        
        var i = 0, j = 0
        while i < debtors.count && j < creditors.count {
            let debt   = abs(debtors[i].value)
            let credit = creditors[j].value
            let amount = min(debt, credit)
            
            if amount > 0.01 {
                result.append((
                    from: debtors[i].key,
                    to: creditors[j].key,
                    amount: amount
                ))
            }
            
            debtors[i]   = (key: debtors[i].key,   value: debtors[i].value   + amount)
            creditors[j] = (key: creditors[j].key, value: creditors[j].value - amount)
            
            if abs(debtors[i].value)   < 0.01 { i += 1 }
            if abs(creditors[j].value) < 0.01 { j += 1 }
        }
        return result
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
    
    func deleteExpense(id: UUID) {
        expenses.removeAll { $0.id == id }
    }
    
    func markSettled(expenseId: UUID, memberName: String) {
        if let eIdx = expenses.firstIndex(where: { $0.id == expenseId }),
           let mIdx = expenses[eIdx].members.firstIndex(where: { $0.name == memberName }) {
            expenses[eIdx].members[mIdx].isPaid = true
        }
    }
}
