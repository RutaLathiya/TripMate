//
//  AddExpenseView.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//

import SwiftUI

struct AddExpenseView: View {
    
    @ObservedObject var store: ExpenseStore
    let tripMembers: [String]
    @Environment(\.dismiss) private var dismiss
    
    // form fields
    @State private var title = ""
    @State private var amount = ""
    @State private var category: ExpenseCategory = .food
    @State private var date = Date()
    @State private var payerName = ""
    @State private var selectedMembers: Set<String> = []
    @State private var splitType: SplitType = .equal
    @State private var customAmounts: [String: String] = [:]
    @State private var notes = ""
    
    private var amountDouble: Double { Double(amount) ?? 0 }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        amountDouble > 0 &&
        !payerName.isEmpty &&
        !selectedMembers.isEmpty
    }
    
    private var equalShare: Double {
        guard selectedMembers.count > 0 else { return 0 }
        return amountDouble / Double(selectedMembers.count)
    }
    
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // Title
                    fieldCard(label: "EXPENSE TITLE") {
                        TextField("e.g. Hotel in Goa", text: $title)
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color.AccentColor)
                    }
                    
                    // Amount
                    fieldCard(label: "AMOUNT (₹)") {
                        HStack {
                            Text("₹")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                            TextField("0.00", text: $amount)
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    // Category
                    fieldCard(label: "CATEGORY") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(ExpenseCategory.allCases, id: \.self) { cat in
                                    categoryChip(cat)
                                }
                            }
                        }
                    }
                    
                    // Date
                    fieldCard(label: "DATE") {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .tint(Color.AccentColor)
                            .labelsHidden()
                    }
                    
                    // Payer
                    fieldCard(label: "WHO PAID?") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(tripMembers, id: \.self) { member in
                                    memberChip(
                                        name: member,
                                        isSelected: payerName == member,
                                        color: Color.AccentColor
                                    ) {
                                        payerName = member
                                    }
                                }
                            }
                        }
                    }
                    
                    // Members involved
                    fieldCard(label: "SPLIT BETWEEN") {
                        VStack(spacing: 10) {
                            // Select all button
                            HStack {
                                Button {
                                    if selectedMembers.count == tripMembers.count {
                                        selectedMembers = []
                                    } else {
                                        selectedMembers = Set(tripMembers)
                                    }
                                } label: {
                                    Text(selectedMembers.count == tripMembers.count ? "DESELECT ALL" : "SELECT ALL")
                                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                                        .foregroundColor(Color.AccentColor)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.AccentColor.opacity(0.1))
                                        .cornerRadius(8)
                                }
                                Spacer()
                            }
                            
                            FlowLayout(spacing: 8) {
                                ForEach(tripMembers, id: \.self) { member in
                                    memberChip(
                                        name: member,
                                        isSelected: selectedMembers.contains(member),
                                        color: Color.AccentColor
                                    ) {
                                        if selectedMembers.contains(member) {
                                            selectedMembers.remove(member)
                                        } else {
                                            selectedMembers.insert(member)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Split type
                    if !selectedMembers.isEmpty {
                        fieldCard(label: "SPLIT TYPE") {
                            VStack(spacing: 12) {
                                Picker("Split Type", selection: $splitType) {
                                    ForEach(SplitType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .tint(Color.AccentColor)
                                
                                if splitType == .equal {
                                    // Equal split preview
                                    HStack {
                                        Image(systemName: "equal.circle.fill")
                                            .foregroundColor(Color.AccentColor.opacity(0.6))
                                        Text("Each person pays ₹\(String(format: "%.2f", equalShare))")
                                            .font(.system(size: 12, design: .monospaced))
                                            .foregroundColor(Color.AccentColor.opacity(0.7))
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.AccentColor.opacity(0.05))
                                    .cornerRadius(8)
                                    
                                } else {
                                    // Custom split inputs
                                    VStack(spacing: 8) {
                                        ForEach(Array(selectedMembers).sorted(), id: \.self) { member in
                                            HStack {
                                                Text(member)
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundColor(Color.AccentColor)
                                                Spacer()
                                                Text("₹")
                                                    .font(.system(size: 13, design: .monospaced))
                                                    .foregroundColor(Color.AccentColor.opacity(0.6))
                                                TextField("0.00", text: Binding(
                                                    get: { customAmounts[member] ?? "" },
                                                    set: { customAmounts[member] = $0 }
                                                ))
                                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                                .foregroundColor(Color.AccentColor)
                                                .keyboardType(.decimalPad)
                                                .frame(width: 80)
                                                .multilineTextAlignment(.trailing)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.AccentColor.opacity(0.05))
                                            .cornerRadius(8)
                                        }
                                        
                                        // Custom total validation
                                        let customTotal = customAmounts.values.compactMap { Double($0) }.reduce(0, +)
                                        let diff = abs(customTotal - amountDouble)
                                        HStack {
                                            Text("Total: ₹\(String(format: "%.2f", customTotal))")
                                                .font(.system(size: 11, design: .monospaced))
                                            Spacer()
                                            if diff < 0.01 {
                                                Label("Balanced", systemImage: "checkmark.circle.fill")
                                                    .font(.system(size: 11, design: .monospaced))
                                                    .foregroundColor(.green)
                                            } else {
                                                Text("₹\(String(format: "%.2f", diff)) remaining")
                                                    .font(.system(size: 11, design: .monospaced))
                                                    .foregroundColor(.orange)
                                            }
                                        }
                                        .foregroundColor(Color.AccentColor.opacity(0.6))
                                        .padding(.horizontal, 4)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Notes
                    fieldCard(label: "NOTES (OPTIONAL)") {
                        TextField("Any extra details...", text: $notes, axis: .vertical)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(Color.AccentColor)
                            .lineLimit(3)
                    }
                    
                    // Save button
                    Button { saveExpense() } label: {
                        Text("SAVE EXPENSE")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .kerning(2)
                            .foregroundColor(canSave ? .white : Color.AccentColor.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(canSave ? Color.AccentColor : Color.AccentColor.opacity(0.1))
                            .cornerRadius(16)
                    }
                    .disabled(!canSave)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Add Expense")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { dismiss() }
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
            }
        }
        .onAppear {
            // pre-select all members by default
            selectedMembers = Set(tripMembers)
            payerName = tripMembers.first ?? ""
        }
    }
    
    // MARK: - Field Card
    private func fieldCard<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)
            content()
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1)
        )
    }
    
    // MARK: - Category Chip
    private func categoryChip(_ cat: ExpenseCategory) -> some View {
        let isSelected = category == cat
        return Button { category = cat } label: {
            HStack(spacing: 6) {
                Image(systemName: cat.icon)
                    .font(.system(size: 11))
                Text(cat.rawValue)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
            }
            .foregroundColor(isSelected ? .white : Color.AccentColor.opacity(0.6))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.AccentColor : Color.AccentColor.opacity(0.08))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.AccentColor.opacity(isSelected ? 0 : 0.2), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Member Chip
    private func memberChip(name: String, isSelected: Bool, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : color.opacity(0.15))
                        .frame(width: 22, height: 22)
                    Text(String(name.prefix(1)).uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isSelected ? .white : color)
                }
                Text(name)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(isSelected ? color : color.opacity(0.6))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.12) : Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(isSelected ? 0.4 : 0.2), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Save
    private func saveExpense() {
        var members: [ExpenseMember] = selectedMembers.sorted().map { name in
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
        dismiss()
    }
}

// MARK: - Flow Layout (wrapping chips)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0 }
            .reduce(0) { $0 + $1 + spacing } - spacing
        return CGSize(width: proposal.width ?? 0, height: max(height, 0))
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
                x += size.width + spacing
            }
            y += rowHeight + spacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var x: CGFloat = 0
        let maxWidth = proposal.width ?? 0
        for subview in subviews {
            let width = subview.sizeThatFits(.unspecified).width
            if x + width > maxWidth && !rows[rows.count - 1].isEmpty {
                rows.append([])
                x = 0
            }
            rows[rows.count - 1].append(subview)
            x += width + spacing
        }
        return rows
    }
}

#Preview {
    AddExpenseView(
        store: ExpenseStore(),
            tripMembers: ["You", "Rahul", "Priya", "Arun"]
    )
        
}
