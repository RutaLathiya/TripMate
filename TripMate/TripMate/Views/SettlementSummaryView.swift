//
//  SettlementSummaryView.swift
//  TripMate
//
//  Created by iMac on 02/04/26.
//

// MARK: - SettlementSummaryView.swift
// TripMate — Who owes whom in the trip
// Theme: BackgroundColor, AccentColor, monospaced, uppercase labels

import SwiftUI

// MARK: - Settlement Row
private struct SettlementRowView: View {
    let settlement: Settlement
    let onPay: () -> Void

    var isYouPaying: Bool { settlement.fromMember.name == "You" }

    var body: some View {
        HStack(spacing: 14) {
            MemberAvatar(name: settlement.fromMember.name, size: 40)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(settlement.fromMember.name)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                    Text(settlement.toMember.name)
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
            // You Owe
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

            // Owed to you
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
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
    }
}

// MARK: - Main View
struct SettlementSummaryView: View {
    @State private var settlements: [Settlement] = MockData.settlements
    @State private var selectedSettlement: Settlement?
    @State private var showPayNow = false

    private var youOwe: Double {
        settlements.filter { $0.fromMember.name == "You" && !$0.isPaid }.reduce(0) { $0 + $1.amount }
    }
    private var owedToYou: Double {
        settlements.filter { $0.toMember.name == "You" && !$0.isPaid }.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // Stats
                    SummaryStatsRow(youOwe: youOwe, owedToYou: owedToYou)

                    // Section label
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

                    // Rows
                    ForEach(settlements) { settlement in
                        SettlementRowView(settlement: settlement) {
                            selectedSettlement = settlement
                            showPayNow = true
                        }
                    }

                    // All settled
                    if settlements.allSatisfy({ $0.isPaid }) {
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
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
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
                NavigationLink(destination: TransactionHistoryView()) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 14))
                        .foregroundColor(Color.AccentColor)
                }
            }
        }
        .sheet(isPresented: $showPayNow) {
//            if let s = selectedSettlement {
//                PayNowView(receiver: s.toMember.name, prefilledAmount: s.amount) { paid in
//                    if paid, let idx = settlements.firstIndex(where: { $0.id == s.id }) {
//                        settlements[idx].isPaid = true
//                    }
//                }
//            }
        }
    }
}

#Preview {
    NavigationStack { SettlementSummaryView() }
        .preferredColorScheme(.dark)
}
