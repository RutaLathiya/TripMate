//
//  EmailOTPRepository.swift
//  TripMate
//
//  Created by iMac on 24/03/26.
//


import Foundation

// MARK: - ⚙️ PASTE YOUR EMAILJS KEYS HERE
private enum EmailJSConfig {
    static let serviceID  = "service_khdiybk"   // ← EmailJS → Email Services → your service → Service ID
    static let templateID = "template_uuayz1r"  // ← EmailJS → Email Templates → your template → Template ID
    static let publicKey  = "nrXxLCExWc90ajC0L"   // ← EmailJS → Account → General → Public Key
    static let privateKey  = "EE64rAUSUHTr2_j-PSK3P"
}

// MARK: - Protocol
protocol EmailOTPRepositoryProtocol {
    func sendOTP(to email: String) async throws -> String  // returns the generated OTP
    func verifyOTP(entered: String, actual: String) -> Bool
}

// MARK: - Repository
final class EmailOTPRepository: EmailOTPRepositoryProtocol {

    // MARK: - Generate 6 digit OTP
    private func generateOTP() -> String {
        let otp = Int.random(in: 100000...999999)
        return "\(otp)"
    }

    // MARK: - Send OTP via EmailJS REST API
    func sendOTP(to email: String) async throws -> String {
        let otp = generateOTP()

        guard let url = URL(string: "https://api.emailjs.com/api/v1.0/email/send") else {
            throw EmailOTPError.invalidURL
        }

        let body: [String: Any] = [
            "service_id": EmailJSConfig.serviceID,
            "template_id": EmailJSConfig.templateID,
            "user_id": EmailJSConfig.publicKey,
            "accessToken": EmailJSConfig.privateKey,
            "template_params": [
                "otp_code": otp,
                "to_email": email
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        // ✅ Add detailed logging
        print("📧 Sending OTP to: \(email)")
        print("📧 Service ID: \(EmailJSConfig.serviceID)")
        print("📧 Template ID: \(EmailJSConfig.templateID)")

        let (data, response) = try await URLSession.shared.data(for: request)

        // ✅ Print full response
        let responseString = String(data: data, encoding: .utf8) ?? "no response body"
        print("📧 EmailJS response: \(responseString)")

        guard let httpResponse = response as? HTTPURLResponse else {
            throw EmailOTPError.sendFailed
        }

        print("📧 Status code: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            throw EmailOTPError.sendFailed
        }

        print("✅ Email OTP sent to \(email): \(otp)")
        return otp
    }

    // MARK: - Verify OTP
    func verifyOTP(entered: String, actual: String) -> Bool {
        return entered.trimmingCharacters(in: .whitespaces) == actual
    }
}

// MARK: - Errors
enum EmailOTPError: LocalizedError {
    case invalidURL
    case sendFailed
    case invalidOTP

    var errorDescription: String? {
        switch self {
        case .invalidURL:   return "Invalid EmailJS URL."
        case .sendFailed:   return "Failed to send OTP email. Check your EmailJS keys."
        case .invalidOTP:   return "Invalid OTP. Please try again."
        }
    }
}
