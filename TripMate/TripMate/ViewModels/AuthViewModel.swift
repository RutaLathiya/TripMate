//
//  AuthViewModel.swift
//  TripMate
//
//  Created by iMac on 23/03/26.
//



import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {

    // MARK: - Phone Input
    @Published var phoneNumber: String   = ""
    @Published var countryCode: String   = "+91"

    // MARK: - OTP Input
    @Published var otpCode: String       = ""

    // MARK: - State
    @Published var isLoading: Bool       = false
    @Published var isPhoneVerified: Bool = false  // ✅ turns true after OTP verified
    @Published var errorMessage: String? = nil

    // MARK: - Navigation (used by standalone PhoneLoginView if needed)
    @Published var showOTPScreen: Bool   = false
    @Published var isLoggedIn: Bool      = false

    // MARK: - Internal
    private var verificationID: String?  = nil
    private let repository: AuthRepositoryProtocol

    // MARK: - Init
   init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }

    // MARK: - Computed
    var fullPhoneNumber: String {
        "\(countryCode)\(phoneNumber.trimmingCharacters(in: .whitespaces))"
    }

    var canSendOTP: Bool {
        phoneNumber.trimmingCharacters(in: .whitespaces).count >= 10
    }

    var canVerifyOTP: Bool {
        otpCode.count == 6
    }

    // MARK: - Step 1: Send OTP
    @MainActor
    func sendOTP() async {
        print("📱 Sending OTP to: \(fullPhoneNumber)")
        guard canSendOTP else {
            errorMessage = "Please enter a valid 10-digit phone number."
            return
        }
        isLoading    = true
        errorMessage = nil
        do {
            verificationID = try await repository.sendOTP(to: fullPhoneNumber)
            showOTPScreen  = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Step 2: Verify OTP
    @MainActor
    func verifyOTP() async {
        guard canVerifyOTP, let verificationID else {
            errorMessage = "Please enter the 6-digit OTP."
            return
        }
        isLoading    = true
        errorMessage = nil
        do {
            try await repository.verifyOTP(verificationID: verificationID, otp: otpCode)
            isPhoneVerified = true  // ✅ marks phone as verified
            isLoggedIn      = true
        } catch {
            errorMessage = "Invalid OTP. Please try again."
        }
        isLoading = false
    }

    // MARK: - Resend OTP
    @MainActor
    func resendOTP() async {
        otpCode      = ""
        errorMessage = nil
        await sendOTP()
    }
}
