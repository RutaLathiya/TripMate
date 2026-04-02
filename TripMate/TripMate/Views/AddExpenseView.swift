//
//  AddExpenseView.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//

import SwiftUI

struct AddExpenseView: View {

    @StateObject private var vm: AddExpenseViewModel
    @ObservedObject private var paymentStore = PaymentStore()
    @Environment(\.dismiss) private var dismiss

    // MARK: - Init
    init(store: ExpenseStore, tripMembers: [String]) {
        _vm = StateObject(wrappedValue: AddExpenseViewModel(store: store, tripMembers: tripMembers))
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    titleField
                    amountField
                    categoryField
                    dateField
                    payerField
                    splitBetweenField

                    if !vm.selectedMembers.isEmpty {
                        splitTypeField
                    }

                    notesField
                    saveButton
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
    }
}

// MARK: - Subviews
private extension AddExpenseView {

    var titleField: some View {
        fieldCard(label: "EXPENSE TITLE") {
            TextField("e.g. Hotel in Goa", text: $vm.title)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(Color.AccentColor)
        }
    }

    var amountField: some View {
        fieldCard(label: "AMOUNT (₹)") {
            HStack {
                Text("₹")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                TextField("0.00", text: $vm.amount)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .keyboardType(.decimalPad)
            }
        }
    }

    var categoryField: some View {
        fieldCard(label: "CATEGORY") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ExpenseCategory.allCases, id: \.self) { cat in
                        categoryChip(cat)
                    }
                }
            }
        }
    }

    var dateField: some View {
        fieldCard(label: "DATE") {
            DatePicker("", selection: $vm.date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .tint(Color.AccentColor)
                .labelsHidden()
        }
    }

    var payerField: some View {
        fieldCard(label: "WHO PAID?") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(vm.tripMembers, id: \.self) { member in
                        memberChip(
                            name: member,
                            isSelected: vm.payerName == member,
                            color: Color.AccentColor
                        ) {
                            vm.selectPayer(member)
                        }
                    }
                }
            }
        }
    }

    var splitBetweenField: some View {
        fieldCard(label: "SPLIT BETWEEN") {
            VStack(spacing: 10) {
                HStack {
                    Button {
                        vm.toggleSelectAll()
                    } label: {
                        Text(vm.allMembersSelected ? "DESELECT ALL" : "SELECT ALL")
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
                    ForEach(vm.tripMembers, id: \.self) { member in
                        memberChip(
                            name: member,
                            isSelected: vm.selectedMembers.contains(member),
                            color: Color.AccentColor
                        ) {
                            vm.toggleMember(member)
                        }
                    }
                }
            }
        }
    }

    var splitTypeField: some View {
        fieldCard(label: "SPLIT TYPE") {
            VStack(spacing: 12) {
                Picker("Split Type", selection: $vm.splitType) {
                    ForEach(SplitType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .tint(Color.AccentColor)

                if vm.splitType == .equal {
                    equalSplitPreview
                } else {
                    customSplitInputs
                }
            }
        }
    }

    var equalSplitPreview: some View {
        HStack {
            Image(systemName: "equal.circle.fill")
                .foregroundColor(Color.AccentColor.opacity(0.6))
            Text("Each person pays ₹\(String(format: "%.2f", vm.equalShare))")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.7))
            Spacer()
        }
        .padding(10)
        .background(Color.AccentColor.opacity(0.05))
        .cornerRadius(8)
    }

    var customSplitInputs: some View {
        VStack(spacing: 8) {
            ForEach(Array(vm.selectedMembers).sorted(), id: \.self) { member in
                HStack {
                    Text(member)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    Spacer()
                    Text("₹")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                    TextField("0.00", text: Binding(
                        get: { vm.customAmounts[member] ?? "" },
                        set: { vm.customAmounts[member] = $0 }
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

            // Validation row
            HStack {
                Text("Total: ₹\(String(format: "%.2f", vm.customTotal))")
                    .font(.system(size: 11, design: .monospaced))
                Spacer()
                if vm.isCustomBalanced {
                    Label("Balanced", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.green)
                } else {
                    Text("₹\(String(format: "%.2f", vm.customDifference)) remaining")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.orange)
                }
            }
            .foregroundColor(Color.AccentColor.opacity(0.6))
            .padding(.horizontal, 4)
        }
    }

    var notesField: some View {
        fieldCard(label: "NOTES (OPTIONAL)") {
            TextField("Any extra details...", text: $vm.notes, axis: .vertical)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .lineLimit(3)
        }
    }

    var saveButton: some View {
        Button {
            vm.saveExpense { dismiss() }
        } label: {
            Text("SAVE EXPENSE")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .kerning(2)
                .foregroundColor(vm.canSave ? .white : Color.AccentColor.opacity(0.3))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(vm.canSave ? Color.AccentColor : Color.AccentColor.opacity(0.1))
                .cornerRadius(16)
        }
        .disabled(!vm.canSave)
        .padding(.bottom, 40)
    }
}

// MARK: - Reusable Components
private extension AddExpenseView {

    func fieldCard<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
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

    func categoryChip(_ cat: ExpenseCategory) -> some View {
        let isSelected = vm.category == cat
        return Button { vm.category = cat } label: {
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

    func memberChip(name: String, isSelected: Bool, color: Color, action: @escaping () -> Void) -> some View {
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

// MARK: - Preview
#Preview {
    AddExpenseView(
        store: ExpenseStore(),
        tripMembers: ["You", "Rahul", "Priya", "Arun"]
    )
}
