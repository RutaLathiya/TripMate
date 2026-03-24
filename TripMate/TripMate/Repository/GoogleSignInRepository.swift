//
//  GoogleSignInRepository.swift
//  TripMate
//
//  Created by iMac on 24/03/26.
//


import Foundation
import GoogleSignIn
import FirebaseAuth
import CoreData

// MARK: - ⚙️ PASTE YOUR WEB CLIENT ID HERE
private enum GoogleConfig {
    static let webClientID = "68070130385-dbl7cephtri6ji8qseuj68b8u43uff34.apps.googleusercontent.com"  // ← Firebase Console → Authentication → Google → Web client ID
}

// MARK: - Protocol
protocol GoogleSignInRepositoryProtocol {
    func signIn(presenting viewController: UIViewController) async throws -> GoogleUserInfo
}

// MARK: - User Info returned after Google Sign In
struct GoogleUserInfo {
    let name: String
    let email: String
    let profileURL: URL?
}

// MARK: - Repository
final class GoogleSignInRepository: GoogleSignInRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    // MARK: - Sign In with Google
    func signIn(presenting viewController: UIViewController) async throws -> GoogleUserInfo {

        // Configure Google Sign In
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: GoogleConfig.webClientID)

        // Present Google Sign In screen
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        let user   = result.user

        guard let idToken = user.idToken?.tokenString else {
            throw GoogleSignInError.missingToken
        }

        // Sign in to Firebase with Google credential
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
        )
        try await Auth.auth().signIn(with: credential)

        // Return user info to ViewModel
        return GoogleUserInfo(
            name:       user.profile?.name       ?? "",
            email:      user.profile?.email      ?? "",
            profileURL: user.profile?.imageURL(withDimension: 200)
        )
    }
}

// MARK: - Errors
enum GoogleSignInError: LocalizedError {
    case missingToken
    case signInFailed

    var errorDescription: String? {
        switch self {
        case .missingToken:  return "Google Sign In failed — missing token."
        case .signInFailed:  return "Google Sign In failed. Please try again."
        }
    }
}
