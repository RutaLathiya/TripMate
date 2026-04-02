//
//  TransactionHistoryView.swift
//  TripMate
//
//  Created by iMac on 02/04/26.
//


// MARK: - TransactionHistoryView.swift
// TripMate — Payment log, accessible via toolbar clock icon
// Uses PaymentStore (same instance passed from parent)

import SwiftUI

struct TransactionHistoryView: View {

    @ObservedObject var paymentStore: PaymentStore
    @State private var selectedFilter: PaymentStatus? = nil  // nil = ALL

    // MARK: - Filtered records
    private var filtered: [PaymentRecord] {
        guard let f = selectedFilter else { return paymentStore.records }
        return paymentStore.records.filter { $0.status == f }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    statsBar
                    filterRow
                    recordsList

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Stats Bar
    private var statsBar: some View {
        let paid     = paymentStore.records.filter { $0.status == .success && $0.fromName == "You" }.reduce(0) { $0 + $1.amount }
        let received = paymentStore.records.filter { $0.status == .success && $0.toName   == "You" }.reduce(0) { $0 + $1.amount }
        let pending  = paymentStore.records.filter { $0.status == .pending }.count

        return HStack(spacing: 0) {
            statItem(label: "PAID OUT",  value: "₹\(Int(paid))",     valueColor: Color(red: 1, green: 0.27, blue: 0.27))
            Rectangle().fill(Color.AccentColor.opacity(0.1)).frame(width: 1, height: 32)
            statItem(label: "RECEIVED",  value: "₹\(Int(received))", valueColor: .green)
            Rectangle().fill(Color.AccentColor.opacity(0.1)).frame(width: 1, height: 32)
            statItem(label: "PENDING",   value: "\(pending)",         valueColor: .orange)
        }
        .padding(.vertical, 14)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
    }

    private func statItem(label: String, value: String, valueColor: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                .foregroundColor(valueColor)
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.4))
                .kerning(1.5)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Filter Row (matches categoryChip style)
    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(label: "ALL", isSelected: selectedFilter == nil) {
                    withAnimation(.spring(response: 0.25)) { selectedFilter = nil }
                }
                ForEach([PaymentStatus.success, .pending, .failed, .processing], id: \.rawValue) { status in
                    filterChip(label: status.rawValue.uppercased(), isSelected: selectedFilter == status) {
                        withAnimation(.spring(response: 0.25)) { selectedFilter = status }
                    }
                }
            }
        }
    }

    private func filterChip(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .kerning(1.5)
                .foregroundColor(isSelected ? Color.AccentColor : Color.AccentColor.opacity(0.4))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(isSelected ? Color.AccentColor.opacity(0.12) : Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isSelected ? Color.AccentColor.opacity(0.4) : Color.AccentColor.opacity(0.15),
                            lineWidth: 1
                        )
                )
        }
    }

    // MARK: - Records List
    @ViewBuilder
    private var recordsList: some View {
        if filtered.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "tray")
                    .font(.system(size: 36))
                    .foregroundColor(Color.AccentColor.opacity(0.2))
                Text("NO TRANSACTIONS")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.3))
                    .kerning(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 48)
        } else {
            VStack(spacing: 10) {
                ForEach(filtered) { record in
                    recordCard(record)
                }
            }
        }
    }

    // MARK: - Record Card
    private func recordCard(_ record: PaymentRecord) -> some View {
        let isOutgoing = record.fromName == "You"
        let otherName  = isOutgoing ? record.toName : record.fromName
        let amtColor: Color = isOutgoing ? Color(red: 1, green: 0.27, blue: 0.27) : .green
        let amtPrefix  = isOutgoing ? "−" : "+"

        return VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 14) {

                // Avatar (matches memberChip avatar)
                ZStack {
                    Circle()
                        .fill(Color.AccentColor.opacity(0.15))
                        .overlay(Circle().stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
                    Text(String(otherName.prefix(1)).uppercased())
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 5) {
                    Text(isOutgoing ? "PAID TO" : "RECEIVED FROM")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                        .kerning(1.5)
                    Text(otherName)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)

                    // Status + method
                    HStack(spacing: 8) {
                        statusBadge(record.status)
                        HStack(spacing: 4) {
                            Image(systemName: record.method.icon).font(.system(size: 9))
                            Text(record.method.rawValue)
                                .font(.system(size: 9, design: .monospaced))
                        }
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(amtPrefix)₹\(Int(record.amount))")
                        .font(.system(size: 18, weight: .heavy, design: .monospaced))
                        .foregroundColor(amtColor)
                    Text(record.date, style: .date)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.3))
                }
            }
            .padding(16)

            // Note row (if present)
            if !record.note.isEmpty {
                Rectangle()
                    .fill(Color.AccentColor.opacity(0.08))
                    .frame(height: 1)
                    .padding(.horizontal, 16)

                HStack(spacing: 6) {
                    Image(systemName: "text.quote").font(.system(size: 10))
                    Text(record.note)
                        .font(.system(size: 11, design: .monospaced))
                }
                .foregroundColor(Color.AccentColor.opacity(0.4))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }

            // Razorpay ID (if present)
            if let pid = record.razorpayPaymentId {
                Rectangle()
                    .fill(Color.AccentColor.opacity(0.08))
                    .frame(height: 1)
                    .padding(.horizontal, 16)

                HStack(spacing: 6) {
                    Image(systemName: "number").font(.system(size: 9))
                    Text(pid)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.3))
                    Spacer()
                    Button {
                        UIPasteboard.general.string = pid
                    } label: {
                        Text("COPY")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .kerning(1)
                            .foregroundColor(Color.AccentColor)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.AccentColor.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
    }

    // MARK: - Status Badge
    private func statusBadge(_ status: PaymentStatus) -> some View {
        let color: Color = {
            switch status {
            case .success:    return .green
            case .failed:     return Color(red: 1, green: 0.27, blue: 0.27)
            case .pending:    return .orange
            case .processing: return Color.AccentColor
            }
        }()

        return HStack(spacing: 4) {
            Circle().fill(color).frame(width: 5, height: 5)
            Text(status.rawValue.uppercased())
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .kerning(1)
                .foregroundColor(color)
        }
        .padding(.horizontal, 7).padding(.vertical, 3)
        .background(color.opacity(0.1))
        .cornerRadius(6)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

#Preview {
    let store = PaymentStore()
    store.add(PaymentRecord(fromName: "You", toName: "Raj", amount: 450, method: .upi, status: .success, date: Date(), razorpayPaymentId: "pay_ABC123", note: "Hotel split"))
    store.add(PaymentRecord(fromName: "Priya", toName: "You", amount: 200, method: .cash, status: .success, date: Date().addingTimeInterval(-86400), razorpayPaymentId: nil, note: ""))
    store.add(PaymentRecord(fromName: "You", toName: "Aryan", amount: 800, method: .card, status: .pending, date: Date().addingTimeInterval(-3600), razorpayPaymentId: nil, note: "Fuel"))
    return NavigationStack { TransactionHistoryView(paymentStore: store) }
        .preferredColorScheme(.dark)
}
