//
//  AdminLoginView.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import SwiftUI

struct AdminLoginView: View {
    @StateObject private var adminVM = AdminViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            if adminVM.isLoggedIn {
                AdminDashboardView(adminVM: adminVM)
            } else {
                loginForm
            }
        }
    }

    private var loginForm: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.12))
                    .frame(width: 80, height: 80)
                Image(systemName: "shield.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.red)
            }
            .padding(.bottom, 20)

            Text("ADMIN PANEL")
                .font(.system(size: 22, weight: .heavy, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .kerning(3)
                .padding(.bottom, 6)

            Text("TripMate Control Center")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.4))
                .padding(.bottom, 40)

            // Username
            VStack(alignment: .leading, spacing: 6) {
                Text("USERNAME")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.6))
                    .kerning(2)
                TextField("Enter admin username", text: $username)
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(14)
                    .background(Color.AccentColor.opacity(0.05))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1))
            }
            .padding(.bottom, 16)

            // Password
            VStack(alignment: .leading, spacing: 6) {
                Text("PASSWORD")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.6))
                    .kerning(2)
                HStack {
                    Group {
                        if showPassword {
                            TextField("Enter password", text: $password)
                        } else {
                            SecureField("Enter password", text: $password)
                        }
                    }
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(Color.AccentColor.opacity(0.4))
                    }
                }
                .padding(14)
                .background(Color.AccentColor.opacity(0.05))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1))
            }
            .padding(.bottom, 12)

            // Error
            if let error = adminVM.errorMessage {
                Text(error)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.red)
                    .padding(.bottom, 12)
            }

            // Login Button
            Button {
                adminVM.login(username: username, password: password)
            } label: {
                Text("LOGIN AS ADMIN")
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .kerning(2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.red.opacity(0.4), lineWidth: 1.5))
            }
            .padding(.bottom, 8)

//            Text("Default: Admin / admin123")
//                .font(.system(size: 10, design: .monospaced))
//                .foregroundColor(Color.AccentColor.opacity(0.3))

            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

#Preview {
    AdminLoginView()
}
