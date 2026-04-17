//
//  ChangePasswordViewModel.swift
//  TripMate
//
//  Created by iMac on 17/04/26.
//

import Foundation
import CoreData
import CryptoKit
import Combine

// MARK: - Alert Model

struct AlertMessage: Identifiable {
    let id = UUID()
    let message: String
    let isSuccess: Bool
}

// MARK: - ViewModel

@MainActor
final class ChangePasswordViewModel: ObservableObject {

    // MARK: - Published Fields

    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""

    @Published var isLoading: Bool = false
    @Published var alert: AlertMessage? = nil

    @Published var showCurrentPassword: Bool = false
    @Published var showNewPassword: Bool = false
    @Published var showConfirmPassword: Bool = false

    // MARK: - Computed: Password Strength

    enum PasswordStrength: String {
        case empty    = ""
        case weak     = "Weak"
        case fair     = "Fair"
        case strong   = "Strong"

        var color: String {
            switch self {
            case .empty:   return "gray"
            case .weak:    return "red"
            case .fair:    return "orange"
            case .strong:  return "green"
            }
        }
    }

    var passwordStrength: PasswordStrength {
        guard !newPassword.isEmpty else { return .empty }
        var score = 0
        if newPassword.count >= 8                                              { score += 1 }
        if newPassword.rangeOfCharacter(from: .uppercaseLetters) != nil        { score += 1 }
        if newPassword.rangeOfCharacter(from: .decimalDigits) != nil           { score += 1 }
        if newPassword.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;':\",./<>?")) != nil { score += 1 }
        switch score {
        case 0...1: return .weak
        case 2...3: return .fair
        default:    return .strong
        }
    }

    var passwordsMatch: Bool {
        !confirmPassword.isEmpty && newPassword == confirmPassword
    }

    // MARK: - CoreData Context

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // MARK: - Validation

    private func validate() -> String? {
        if currentPassword.isEmpty { return "Please enter your current password." }
        if newPassword.isEmpty     { return "Please enter a new password." }
        if newPassword.count < 8   { return "New password must be at least 8 characters." }
        if newPassword == currentPassword { return "New password must be different from the current password." }
        if newPassword != confirmPassword  { return "New password and confirm password do not match." }
        return nil
    }

    // MARK: - Hashing

    /// SHA-256 hash — replace with bcrypt via a Swift package (e.g. SwiftBcrypt) for production.
    nonisolated private func hash(_ password: String) -> String {
        let data = Data(password.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Core Action

    func updatePassword(userID: NSManagedObjectID) {
        if let error = validate() {
            alert = AlertMessage(message: error, isSuccess: false)
            return
        }

        isLoading = true

        // Run CoreData work on a background context to keep UI responsive
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()

//        Task {
//            do {
//                try await backgroundContext.perform {
//                    // 1. Fetch the user by objectID
//                    guard let user = try? backgroundContext.existingObject(with: userID) as? UserEntity else {
//                        throw PasswordError.userNotFound
//                    }
//
//                    // 2. Verify current password
//                    let currentHash = self.hash(self.currentPassword)
//                    guard user.password == currentHash else {
//                        throw PasswordError.incorrectCurrentPassword
//                    }
//
//                    // 3. Save new hashed password
//                    user.password   = self.hash(self.newPassword)
//                    user.updatedAt = Date()
//
//                    // 4. Persist
//                    try backgroundContext.save()
//                }
//
//                // 5. Back on main thread — update UI
//                self.isLoading = false
//                self.clearFields()
//                self.alert = AlertMessage(message: "Password updated successfully.", isSuccess: true)
//
//            } catch PasswordError.userNotFound {
//                self.isLoading = false
//                self.alert = AlertMessage(message: "User not found. Please log in again.", isSuccess: false)
//
//            } catch PasswordError.incorrectCurrentPassword {
//                self.isLoading = false
//                self.alert = AlertMessage(message: "Current password is incorrect.", isSuccess: false)
//
//            } catch {
//                self.isLoading = false
//                self.alert = AlertMessage(message: "Something went wrong. Please try again.", isSuccess: false)
//            }
//        }
        Task {
            do {
                let currentPassword = self.currentPassword
                let newPassword = self.newPassword

                try await backgroundContext.perform {
                    guard let user = try? backgroundContext.existingObject(with: userID) as? UserEntity else {
                        throw PasswordError.userNotFound
                    }

                    let currentHash = self.hash(currentPassword)

                    guard user.password == currentHash else {
                        throw PasswordError.incorrectCurrentPassword
                    }

                    user.password = self.hash(newPassword)
                    user.updatedAt = Date()

                    try backgroundContext.save()
                }

                await MainActor.run {
                    self.isLoading = false
                    self.clearFields()
                    self.alert = AlertMessage(message: "Password updated successfully.", isSuccess: true)
                }

            } catch PasswordError.userNotFound {
                await MainActor.run {
                    self.isLoading = false
                    self.alert = AlertMessage(message: "User not found. Please log in again.", isSuccess: false)
                }

            } catch PasswordError.incorrectCurrentPassword {
                await MainActor.run {
                    self.isLoading = false
                    self.alert = AlertMessage(message: "Current password is incorrect.", isSuccess: false)
                }

            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.alert = AlertMessage(message: "Something went wrong. Please try again.", isSuccess: false)
                }
            }
        }
    }

    // MARK: - Helpers

    private func clearFields() {
        currentPassword  = ""
        newPassword      = ""
        confirmPassword  = ""
    }
}

// MARK: - Custom Errors

private enum PasswordError: LocalizedError {
    case userNotFound
    case incorrectCurrentPassword

    var errorDescription: String? {
        switch self {
        case .userNotFound:            return "User not found."
        case .incorrectCurrentPassword: return "Incorrect current password."
        }
    }
}
