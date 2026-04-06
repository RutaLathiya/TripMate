//
//  SettlementSummaryView.swift
//  TripMate
//
//  Created by iMac on 02/04/26.
//

// MARK: - SettlementSummaryView.swift
// TripMate — Who owes whom in the trip
// Theme: BackgroundColor, AccentColor, monospaced, uppercase labels

//  SettlementSummaryView.swift
import SwiftUI

// MARK: - Settlement Row
private struct SettlementRowView: View {
    let settlement: Settlement
    let currentUserName: String
    let onPay: () -> Void

    var isYouPaying: Bool { settlement.fromName == currentUserName }

    var body: some View {
        HStack(spacing: 14) {
            MemberAvatar(name: settlement.fromName, size: 40)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(settlement.fromName)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                    Text(settlement.toName)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                }
                Text(isYouPaying ? "YOU OWE" : "OWES YOU")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(isYouPaying
                        ? Color(red: 1, green: 0.27, blue: 0.27).opacity(0.8)
                        : Color.green.opacity(0.8))
                    .kerning(1.5)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("₹\(Int(settlement.amount))")
                    .font(.system(size: 18, weight: .heavy, design: .monospaced))
                    .foregroundColor(isYouPaying
                        ? Color(red: 1, green: 0.27, blue: 0.27)
                        : Color.green)

                if settlement.isPaid {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill").font(.system(size: 10))
                        Text("PAID").font(.system(size: 9, weight: .bold, design: .monospaced)).kerning(1)
                    }
                    .foregroundColor(.green)
                } else if isYouPaying {
                    Button(action: onPay) {
                        Text("PAY NOW")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .kerning(1.5)
                            .foregroundColor(Color.AccentColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.AccentColor.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
                    }
                }
            }
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(settlement.isPaid ? 0.08 : 0.15), lineWidth: 1)
        )
        .opacity(settlement.isPaid ? 0.5 : 1)
    }
}

// MARK: - Summary Stats Row
private struct SummaryStatsRow: View {
    let youOwe: Double
    let owedToYou: Double

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 4) {
                Text("₹\(Int(youOwe))")
                    .font(.system(size: 22, weight: .heavy, design: .monospaced))
                    .foregroundColor(youOwe > 0
                        ? Color(red: 1, green: 0.27, blue: 0.27)
                        : Color.AccentColor.opacity(0.3))
                Text("YOU OWE")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.4))
                    .kerning(2)
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.AccentColor.opacity(0.1))
                .frame(width: 1, height: 36)

            VStack(spacing: 4) {
                Text("₹\(Int(owedToYou))")
                    .font(.system(size: 22, weight: .heavy, design: .monospaced))
                    .foregroundColor(owedToYou > 0 ? Color.green : Color.AccentColor.opacity(0.3))
                Text("OWED TO YOU")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.4))
                    .kerning(2)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 18)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
    }
}

// MARK: - Main View
struct SettlementSummaryView: View {

    // ✅ Injected from TripDetailView
    @ObservedObject var expenseStore: ExpenseStore
    let currentUserName: String          // e.g. logged-in user's name

    @State private var settlements: [Settlement] = []
    @State private var selectedSettlement: Settlement?

    private var youOwe: Double {
        settlements
            .filter { $0.fromName == currentUserName && !$0.isPaid }
            .reduce(0) { $0 + $1.amount }
    }
    private var owedToYou: Double {
        settlements
            .filter { $0.toName == currentUserName && !$0.isPaid }
            .reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    SummaryStatsRow(youOwe: youOwe, owedToYou: owedToYou)

                    HStack {
                        Text("SETTLEMENTS")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.AccentColor.opacity(0.5))
                            .kerning(2)
                        Spacer()
                        Text("\(settlements.filter { !$0.isPaid }.count) PENDING")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.AccentColor.opacity(0.4))
                            .kerning(1)
                    }

                    if settlements.isEmpty {
                        // ✅ Show while loading or truly empty
                        VStack(spacing: 10) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 36))
                                .foregroundColor(Color.AccentColor)
                            Text("ALL SETTLED UP")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                                .kerning(2)
                            Text("No pending payments in this trip.")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .background(Color.BackgroundColor)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
                    } else {
                        ForEach(settlements) { settlement in
                            SettlementRowView(
                                settlement: settlement,
                                currentUserName: currentUserName
                            ) {
                                selectedSettlement = settlement
                            }
                        }
                    }

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Split Summary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: TransactionHistoryView(paymentStore: PaymentStore())) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 14))
                        .foregroundColor(Color.AccentColor)
                }
            }
        }
        // ✅ Recalculate whenever expenses change
        .onAppear { recalculate() }
        .onChange(of: expenseStore.expenses.count) { _ in recalculate() }
        .sheet(item: $selectedSettlement) { s in
            PayNowView(
                receiverName: s.toName,
                receiverPhone: "",
                prefilledAmount: s.amount,
                paymentStore: PaymentStore()
            ) {
                if let idx = settlements.firstIndex(where: { $0.id == s.id }) {
                    settlements[idx].isPaid = true
                }
            }
        }
    }

    // MARK: - Calculate settlements from ExpenseStore
    private func recalculate() {
        let raw = expenseStore.settlements()   // [(from: String, to: String, amount: Double)]
        settlements = raw.map { s in
            // Preserve isPaid if already marked
            let existing = settlements.first { $0.fromName == s.from && $0.toName == s.to }
            return Settlement(
                id: existing?.id ?? UUID(),
                fromName: s.from,
                toName: s.to,
                amount: s.amount,
                isPaid: existing?.isPaid ?? false
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettlementSummaryView(
            expenseStore: ExpenseStore(),
            currentUserName: "Ruta Lathiya"
        )
    }
    .preferredColorScheme(.dark)
}
