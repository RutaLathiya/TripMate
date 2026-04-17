//
//  ChangePasswordView.swift
//  TripMate
//
//  Created by iMac on 14/04/26.
//
//
//import SwiftUI
//
//struct ChangePasswordView: View {
//    
//    @State private var currentPassword = ""
//    @State private var newPassword = ""
//    @State private var confirmPassword = ""
//    
//    var body: some View {
//        ZStack {
//            Color.BackgroundColor
//                .ignoresSafeArea()
//        VStack(spacing: 20) {
//            
//            SecureField("Current Password", text: $currentPassword)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.ContainerColor)
//                .cornerRadius(15)
//                
//            
//            SecureField("New Password", text: $newPassword)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.ContainerColor)
//                .cornerRadius(15)
//            
//            SecureField("Confirm Password", text: $confirmPassword)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.ContainerColor)
//                .cornerRadius(15)
//            
//            Button("Update Password") {
//                updatePassword()
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color.AccentColor)
//            .foregroundColor(.white)
//            .cornerRadius(15)
//            
//            Spacer()
//        }
//        .padding()
//        .navigationTitle("Change Password")
//    }
//}
//    
//    func updatePassword() {
//        if newPassword != confirmPassword {
//            print("❌ Passwords do not match")
//            return
//        }
//        
//        // 🔥 integrate backend / Firebase / CoreData here
//        print("✅ Password Updated")
//    }
//}
//
//#Preview {
//    ChangePasswordView()
//}
import SwiftUI
import CoreData
 
struct ChangePasswordView: View {
 
    // Pass the logged-in user's CoreData ObjectID from the parent view.
    // Example: ChangePasswordView(userID: currentUser.objectID)
    let userID: NSManagedObjectID
 
    @StateObject private var viewModel = ChangePasswordViewModel()
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        ZStack {
            Color.BackgroundColor
                .ignoresSafeArea()
 
            ScrollView {
                VStack(spacing: 20) {
 
                    // MARK: - Current Password
                    PasswordField(
                        placeholder: "Current Password",
                        text: $viewModel.currentPassword,
                        isVisible: $viewModel.showCurrentPassword
                    )
 
                    // MARK: - New Password + Strength Indicator
                    VStack(alignment: .leading, spacing: 6) {
                        PasswordField(
                            placeholder: "New Password",
                            text: $viewModel.newPassword,
                            isVisible: $viewModel.showNewPassword
                        )
 
                        if viewModel.passwordStrength != .empty {
                            HStack(spacing: 6) {
                                StrengthBar(filled: true,  color: strengthColor(viewModel.passwordStrength))
                                StrengthBar(filled: viewModel.passwordStrength != .weak,  color: strengthColor(viewModel.passwordStrength))
                                StrengthBar(filled: viewModel.passwordStrength == .strong, color: strengthColor(viewModel.passwordStrength))
                                Text(viewModel.passwordStrength.rawValue)
                                    .font(.caption)
                                    .foregroundColor(strengthColor(viewModel.passwordStrength))
                            }
                            .padding(.horizontal, 4)
                            .animation(.easeInOut, value: viewModel.passwordStrength)
                        }
                    }
 
                    // MARK: - Confirm Password + Match Indicator
                    VStack(alignment: .leading, spacing: 6) {
                        PasswordField(
                            placeholder: "Confirm Password",
                            text: $viewModel.confirmPassword,
                            isVisible: $viewModel.showConfirmPassword
                        )
 
                        if !viewModel.confirmPassword.isEmpty {
                            Label(
                                viewModel.passwordsMatch ? "Passwords match" : "Passwords do not match",
                                systemImage: viewModel.passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill"
                            )
                            .font(.caption)
                            .foregroundColor(viewModel.passwordsMatch ? .green : .red)
                            .padding(.horizontal, 4)
                            .animation(.easeInOut, value: viewModel.passwordsMatch)
                        }
                    }
 
                    // MARK: - Update Button
                    Button {
                        viewModel.updatePassword(userID: userID)
                    } label: {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Update Password")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.AccentColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    .disabled(viewModel.isLoading)
 
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        // MARK: - Alert
        .alert(item: $viewModel.alert) { alertMsg in
            Alert(
                title: Text(alertMsg.isSuccess ? "Success" : "Error"),
                message: Text(alertMsg.message),
                dismissButton: .default(Text("OK")) {
                    if alertMsg.isSuccess { dismiss() }
                }
            )
        }
    }
 
    // MARK: - Helpers
 
    private func strengthColor(_ strength: ChangePasswordViewModel.PasswordStrength) -> Color {
        switch strength {
        case .weak:   return .red
        case .fair:   return .orange
        case .strong: return .green
        case .empty:  return .gray
        }
    }
}
 
// MARK: - Reusable Password Field
 
private struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
 
    var body: some View {
        HStack {
            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
 
            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.ContainerColor)
        .cornerRadius(15)
    }
}
 
// MARK: - Strength Bar Segment
 
private struct StrengthBar: View {
    let filled: Bool
    let color: Color
 
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(filled ? color : Color.gray.opacity(0.3))
            .frame(width: 40, height: 5)
    }
}
 
