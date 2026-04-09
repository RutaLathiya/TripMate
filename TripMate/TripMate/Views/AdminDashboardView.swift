//
//  AdminDashboardView.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var adminVM: AdminViewModel
    @State private var selectedTab: AdminTab = .users

    enum AdminTab: String, CaseIterable {
        case users = "Users"
        case trips = "Trips"

        var icon: String {
            switch self {
            case .users: return "person.2.fill"
            case .trips: return "airplane"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.BackgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    dashboardHeader

                    // Stats row
                    statsRow
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    // Tab picker
                    tabPicker
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    // Content
                    if selectedTab == .users {
                        usersList
                    } else {
                        tripsList
                    }
                }
            }
            .onAppear { adminVM.loadData() }
        }
    }

    // MARK: - Header
    private var dashboardHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("ADMIN DASHBOARD")
                    .font(.system(size: 16, weight: .heavy, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .kerning(2)
                Text("TripMate Control Center")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.4))
            }
            Spacer()
            Button {
                adminVM.logout()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 13))
                    Text("LOGOUT")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .kerning(1)
                }
                .foregroundColor(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.08))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 4)
    }

    // MARK: - Stats
    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(
                title: "TOTAL USERS",
                value: "\(adminVM.users.count)",
                icon: "person.fill",
                color: Color(red: 0.3, green: 0.6, blue: 0.9)
            )
            statCard(
                title: "TOTAL TRIPS",
                value: "\(adminVM.trips.count)",
                icon: "airplane",
                color: Color(red: 0.3, green: 0.75, blue: 0.4)
            )
            statCard(
                title: "ACTIVE",
                value: "\(adminVM.users.filter { $0.status == "Active" }.count)",
                icon: "checkmark.circle.fill",
                color: Color(red: 0.9, green: 0.6, blue: 0.1)
            )
        }
    }

    private func statCard(title: String, value: String,
                           icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 20, weight: .heavy, design: .monospaced))
                .foregroundColor(Color.AccentColor)
            Text(title)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.4))
                .kerning(1)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.AccentColor.opacity(0.06))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(Color.AccentColor.opacity(0.1), lineWidth: 1))
    }

    // MARK: - Tab Picker
    private var tabPicker: some View {
        HStack(spacing: 8) {
            ForEach(AdminTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation { selectedTab = tab }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 13))
                        Text(tab.rawValue.uppercased())
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .kerning(1)
                    }
                    .foregroundColor(selectedTab == tab ? .white : Color.AccentColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedTab == tab
                        ? Color.AccentColor
                        : Color.AccentColor.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }

    // MARK: - Users List
    private var usersList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if adminVM.users.isEmpty {
                    emptyState(icon: "person.slash", message: "NO USERS FOUND")
                } else {
                    ForEach(adminVM.users, id: \.objectID) { user in
                        userRow(user)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }

    private func userRow(_ user: UserEntity) -> some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.AccentColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(String(user.name?.prefix(1) ?? "?").uppercased())
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name ?? "Unknown")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                Text(user.email ?? "No email")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.5))
            }

            Spacer()

            VStack(spacing: 6) {
                // Status badge
                Text(user.status ?? "Active")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(user.status == "Inactive" ? .red : .green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(user.status == "Inactive"
                        ? Color.red.opacity(0.1)
                        : Color.green.opacity(0.1))
                    .cornerRadius(6)

                HStack(spacing: 6) {
                    // Toggle status
                    Button {
                        adminVM.toggleUserStatus(user)
                    } label: {
                        Image(systemName: user.status == "Active"
                            ? "pause.circle" : "play.circle")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                    }

                    // Delete
                    Button {
                        adminVM.deleteUser(user)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(.red.opacity(0.7))
                    }
                }
            }
        }
        .padding(14)
        .background(Color.BackgroundColor)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(Color.AccentColor.opacity(0.1), lineWidth: 1))
    }

    // MARK: - Trips List
    private var tripsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if adminVM.trips.isEmpty {
                    emptyState(icon: "airplane.slash", message: "NO TRIPS FOUND")
                } else {
                    ForEach(adminVM.trips, id: \.objectID) { trip in
                        tripRow(trip)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }

    private func tripRow(_ trip: TripEntity) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.3, green: 0.75, blue: 0.4).opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "airplane")
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.3, green: 0.75, blue: 0.4))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(trip.title ?? "Untitled Trip")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                Text(trip.destination ?? "No destination")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.5))
            }

            Spacer()

            Button {
                adminVM.deleteTrip(trip)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(.red.opacity(0.7))
                    .frame(width: 32, height: 32)
                    .background(Color.red.opacity(0.08))
                    .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Color.BackgroundColor)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(Color.AccentColor.opacity(0.1), lineWidth: 1))
    }

    // MARK: - Empty State
    private func emptyState(icon: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundColor(Color.AccentColor.opacity(0.3))
            Text(message)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.4))
                .kerning(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
