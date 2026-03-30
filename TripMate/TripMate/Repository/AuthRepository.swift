//
//  AuthRepository.swift
//  TripMate
//
//  Created by iMac on 23/03/26.
//


import FirebaseAuth
import CoreData

// MARK: - Protocol
protocol AuthRepositoryProtocol {
    func sendOTP(to phoneNumber: String) async throws -> String  // returns verificationID
    func verifyOTP(verificationID: String, otp: String) async throws
    
}

// MARK: - Repository
final class AuthRepository: AuthRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    // MARK: - Step 1: Send OTP
    func sendOTP(to phoneNumber: String) async throws -> String {
        //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
       // do{  // Firebase sends OTP SMS automatically
            let verificationID = try await PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        print("✅ Firebase returned verificationID:", verificationID)
        print("🔥 sendOTP called")
            return verificationID
       // } catch {
           // print("🔥 Firebase sendOTP error:", error.localizedDescription)
           // throw error
        //}
    }

    // MARK: - Step 2: Verify OTP + Save User to CoreData
    func verifyOTP(verificationID: String, otp: String) async throws {
        // Create Firebase credential
        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID, verificationCode: otp)

        // Sign in with Firebase
        try await Auth.auth().signIn(with: credential)
        //let firebaseUser = result.user

        // Save or update user in CoreData
    //        _ = try saveUserToCorData(firebaseUID: firebaseUser.uid,
    //                                     phone: firebaseUser.phoneNumber ?? "")
    }

    // MARK: - Save User to CoreData
    private func saveUserToCorData(firebaseUID: String, phone: String) throws -> UserEntity {
        // Check if user already exists
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "firebaseUID == %@", firebaseUID)
        request.fetchLimit = 1

        if let existing = try context.fetch(request).first {
            return existing  // returning existing user — already registered
        }

        // New user — create record
        let user = UserEntity(context: context)
        user.uid     = UUID()
        user.firebaseUID = firebaseUID
        user.phoneNo    = phone
        user.created_at  = Date()

        try context.save()
        return user
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case invalidPhoneNumber
    case invalidOTP
    case userSaveFailed

    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber: return "Please enter a valid phone number with country code."
        case .invalidOTP:         return "Invalid OTP. Please try again."
        case .userSaveFailed:     return "Could not save user. Please try again."
        }
    }
}
