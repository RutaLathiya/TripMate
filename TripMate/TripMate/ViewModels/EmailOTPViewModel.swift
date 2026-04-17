//
//  EmailOTPViewModel.swift
//  TripMate
//
//  Created by iMac on 24/03/26.
//

import Foundation
import Combine

final class EmailOTPViewModel: ObservableObject {

    // MARK: - State
    @Published var otpCode: String        = ""
    @Published var isLoading: Bool        = false
    @Published var isEmailVerified: Bool  = false
    @Published var errorMessage: String?  = nil
    @Published var showOTPSheet: Bool     = false
    @Published var sentToEmail: String    = ""  // ✅ stores email for display in sheet

    // MARK: - Internal — stores the generated OTP
    private var actualOTP: String         = ""
    private let repository: EmailOTPRepositoryProtocol

    // MARK: - Init
    init(repository: EmailOTPRepositoryProtocol = EmailOTPRepository()) {
        self.repository = repository
    }

    // MARK: - Computed
    var canVerifyOTP: Bool {
        otpCode.trimmingCharacters(in: .whitespaces).count == 6
    }

    // MARK: - Step 1: Send OTP
    @MainActor
    func sendOTP(to email: String) async {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address first."
            return
        }
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }

        isLoading    = true
        errorMessage = nil

        do {
            actualOTP     = try await repository.sendOTP(to: email)
            showOTPSheet  = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Step 2: Verify OTP
    @MainActor
    func verifyOTP() {
        guard canVerifyOTP else {
            errorMessage = "Please enter the 6-digit OTP."
            return
        }

        if repository.verifyOTP(entered: otpCode, actual: actualOTP) {
            isEmailVerified = true
            showOTPSheet    = false
            print("✅ Email verified successfully")
        } else {
            errorMessage = "Invalid OTP. Please try again."
            otpCode      = ""
        }
    }

    // MARK: - Resend OTP
    @MainActor
    func resendOTP(to email: String) async {
        otpCode      = ""
        errorMessage = nil
        await sendOTP(to: email)
    }

    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
