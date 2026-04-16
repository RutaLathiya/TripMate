//
//  AddExpenseViewModel.swift
//  TripMate
//
//  Created by iMac on 23/03/26.
//

//
//  AddExpenseViewModel.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//

import SwiftUI
import Combine

final class AddExpenseViewModel: ObservableObject {

    // MARK: - Form Fields (UI binds to these)
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: ExpenseCategory = .food
    @Published var date: Date = Date()
    @Published var payerName: String = ""
    @Published var selectedMembers: Set<String> = []
    @Published var splitType: SplitType = .equal
    @Published var customAmounts: [String: String] = [:]
    @Published var notes: String = ""

    // MARK: - Dependencies
    private let store: ExpenseStore
    let tripMembers: [String]

    // MARK: - Init
    init(store: ExpenseStore, tripMembers: [String]) {
        self.store = store
        self.tripMembers = tripMembers
        // Pre-select all members and first payer by default
        self.selectedMembers = Set(tripMembers)
        self.payerName = tripMembers.first ?? ""
    }

    // MARK: - Computed Properties

    var amountDouble: Double {
        Double(amount) ?? 0
    }

    var equalShare: Double {
        guard selectedMembers.count > 0 else { return 0 }
        return amountDouble / Double(selectedMembers.count)
    }

    var customTotal: Double {
        customAmounts.values.compactMap { Double($0) }.reduce(0, +)
    }

    var customDifference: Double {
        abs(customTotal - amountDouble)
    }

    var isCustomBalanced: Bool {
        customDifference < 0.01
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        amountDouble > 0 &&
        !payerName.isEmpty &&
        !selectedMembers.isEmpty
    }

    var allMembersSelected: Bool {
        selectedMembers.count == tripMembers.count
    }

    // MARK: - Intents

    func toggleSelectAll() {
        if allMembersSelected {
            selectedMembers = []
        } else {
            selectedMembers = Set(tripMembers)
        }
    }

    func toggleMember(_ member: String) {
         
        if selectedMembers.contains(member) {
            selectedMembers.remove(member)
        } else {
            selectedMembers.insert(member)
        }
    }

    func selectPayer(_ member: String) {
        payerName = member
    }

    func saveExpense(onSuccess: () -> Void) {
        let members: [ExpenseMember] = selectedMembers.sorted().map { name in
            let share: Double
            if splitType == .equal {
                share = equalShare
            } else {
                share = Double(customAmounts[name] ?? "0") ?? 0
            }
            return ExpenseMember(name: name, shareAmount: share, isPaid: name == payerName)
        }

        let expense = Expense(
            title: title.trimmingCharacters(in: .whitespaces),
            amount: amountDouble,
            category: category,
            date: date,
            payerName: payerName,
            members: members,
            splitType: splitType,
            notes: notes
        )

        store.addExpense(expense)
        onSuccess()
    }
}
