//
//  ExpenseView.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//

import SwiftUI

struct ExpenseView: View {
    
    @ObservedObject var store: ExpenseStore
    let tripName: String
    let tripMembers: [String]
    
    @State private var showAddExpense = false
    @State private var selectedTab = 0  // 0=Expenses 1=Balances 2=Settle
    
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Summary card
                summaryCard
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                // Tab picker
                tabPicker
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        switch selectedTab {
                        case 0: expensesList
                        case 1: balancesView
                        case 2: settlementsView
                        default: expensesList
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
            
            // FAB add button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button { showAddExpense = true } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.AccentColor)
                            .clipShape(Circle())
                            .shadow(color: Color.AccentColor.opacity(0.4), radius: 12, y: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("Expenses")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddExpense) {
            NavigationStack {
                AddExpenseView(store: store, tripMembers: tripMembers)
            }
        }
    }
    
    // MARK: - Summary Card
    private var summaryCard: some View {
        HStack(spacing: 0) {
            summaryItem(label: "TOTAL SPENT", value: "₹\(String(format: "%.0f", store.totalAmount))")
            Divider().frame(height: 40)
            summaryItem(label: "EXPENSES", value: "\(store.expenses.count)")
            Divider().frame(height: 40)
            summaryItem(label: "MEMBERS", value: "\(tripMembers.count)")
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.AccentColor.opacity(0.06), radius: 8, y: 3)
    }
    
    private func summaryItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(1)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Tab Picker
    private var tabPicker: some View {
        HStack(spacing: 6) {
            ForEach(["Expenses", "Balances", "Settle Up"], id: \.self) { tab in
                let idx = ["Expenses", "Balances", "Settle Up"].firstIndex(of: tab) ?? 0
                let isActive = selectedTab == idx
                Button { withAnimation { selectedTab = idx } } label: {
                    Text(tab)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(isActive ? .white : Color.AccentColor.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isActive ? Color.AccentColor : Color.AccentColor.opacity(0.08))
                        .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - Expenses List
    @ViewBuilder
    private var expensesList: some View {
        if store.expenses.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "indianrupeesign.circle")
                    .font(.system(size: 44))
                    .foregroundColor(Color.AccentColor.opacity(0.3))
                Text("NO EXPENSES YET")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.4))
                    .kerning(2)
                Text("Tap + to add your first expense")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.35))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        } else {
            ForEach(store.expenses) { expense in
                expenseRow(expense)
            }
        }
    }
    
    // MARK: - Expense Row
    private func expenseRow(_ expense: Expense) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                // Category icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.AccentColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: expense.category.icon)
                        .font(.system(size: 18))
                        .foregroundColor(Color.AccentColor)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(expense.title)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    HStack(spacing: 6) {
                        Text(expense.category.rawValue)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(Color.AccentColor.opacity(0.5))
                        Text("·")
                            .foregroundColor(Color.AccentColor.opacity(0.3))
                        Text("Paid by \(expense.payerName)")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(Color.AccentColor.opacity(0.5))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    Text("₹\(String(format: "%.0f", expense.amount))")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                }
            }
            
            // Members involved
            HStack(spacing: 6) {
                ForEach(expense.members) { member in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(member.isPaid ? Color.green.opacity(0.7) : Color.AccentColor.opacity(0.3))
                            .frame(width: 6, height: 6)
                        Text(member.name)
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(member.isPaid ? Color.green.opacity(0.7) : Color.AccentColor.opacity(0.5))
                    }
                }
                Spacer()
                if expense.isFullySettled {
                    Label("Settled", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(14)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                withAnimation { store.deleteExpense(id: expense.id) }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    // MARK: - Balances View
    private var balancesView: some View {
        let balances = store.balances(for: tripMembers)
        return VStack(spacing: 10) {
            ForEach(tripMembers, id: \.self) { member in
                let balance = balances[member] ?? 0
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.AccentColor.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Text(String(member.prefix(1)).uppercased())
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.AccentColor)
                    }
                    
                    Text(member)
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(balance >= 0
                             ? "+₹\(String(format: "%.0f", balance))"
                             : "-₹\(String(format: "%.0f", abs(balance)))")
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                            .foregroundColor(balance >= 0 ? .green : .red)
                        Text(balance >= 0 ? "gets back" : "owes")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(Color.AccentColor.opacity(0.4))
                    }
                }
                .padding(14)
                .background(Color.BackgroundColor)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Settlements View
    private var settlementsView: some View {
        let settlements = store.settlements()
        return VStack(spacing: 10) {
            if settlements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.green.opacity(0.5))
                    Text("ALL SETTLED UP!")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                        .kerning(2)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                ForEach(Array(settlements.enumerated()), id: \.offset) { _, settlement in
                    HStack(spacing: 12) {
                        // From
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(Color.red.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                Text(String(settlement.from.prefix(1)).uppercased())
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red.opacity(0.7))
                            }
                            Text(settlement.from)
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.6))
                        }
                        
                        VStack(spacing: 2) {
                            Text("₹\(String(format: "%.0f", settlement.amount))")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color.AccentColor.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        
                        // To
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(Color.green.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                Text(String(settlement.to.prefix(1)).uppercased())
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.green.opacity(0.7))
                            }
                            Text(settlement.to)
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.6))
                        }
                    }
                    .padding(14)
                    .background(Color.BackgroundColor)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
                    )
                }
            }
        }
    }
}
