//
//  SharedComponents.swift
//  TripMate
//
//  Created by iMac on 02/04/26.
//


// MARK: - PaymentSharedComponents.swift
// TripMate — shared views for Payment module
// Matches app theme: BackgroundColor, AccentColor, monospaced, uppercase kerned labels

import SwiftUI

// MARK: - Member Avatar
/// Circular avatar with member's initial — uses AccentColor to match app theme
struct MemberAvatar: View {
    let name: String
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.AccentColor.opacity(0.15))
                .overlay(
                    Circle().stroke(Color.AccentColor.opacity(0.3), lineWidth: 1)
                )
            Text(String(name.prefix(1)).uppercased())
                .font(.system(size: size * 0.38, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Field Card (matches AddExpenseView.fieldCard exactly)
struct FieldCard<Content: View>: View {
    let label: String
    @ViewBuilder let content: () -> Content

    var body: some View {
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
}

// MARK: - Status Badge
struct PaymentStatusBadge: View {
    let status: PaymentStatus

    var color: Color {
        switch status {
        case .success:    return .green
        case .failed:     return Color(red: 1, green: 0.27, blue: 0.27)
        case .pending:    return .orange
        case .initiated:  return Color.AccentColor
        case .processing: return Color.AccentColor.opacity(0.7)
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 5, height: 5)
            Text(status.displayName.uppercased())
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .kerning(1)
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(6)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

// MARK: - Scale Button Style (same as CreateTripView)
struct PayScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}
