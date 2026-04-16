//
//  ExpenseRowView.swift
//  TripMate
//
//  Created by iMac on 16/04/26.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: ExpenseEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Top row — title + amount
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(expense.category ?? "Expense")
                        .font(.system(size: 15, weight: .medium))
                    Text(expense.notes ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("₹\(expense.amount, specifier: "%.0f")")
                    .font(.system(size: 18, weight: .medium))
            }

            Divider()

            // Payer row
            HStack(spacing: 6) {
                Text("Paid by")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                // ✅ Payer avatar (small)
                AvatarView(seed: expense.payerName ?? "", size: 22)

                Text(expense.payerName ?? "Unknown")
                    .font(.system(size: 13, weight: .medium))

                Spacer()
            }

            // ✅ Split chips row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(expense.sharesArray) { share in
                        HStack(spacing: 4) {
                            AvatarView(seed: share.memberName ?? "", size: 18)
                            Text("₹\(share.shareAmount, specifier: "%.0f")")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    }
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}
