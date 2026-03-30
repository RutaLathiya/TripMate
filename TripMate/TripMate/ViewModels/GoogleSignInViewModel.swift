//
//  GoogleSignInViewModel.swift
//  TripMate
//
//  Created by iMac on 24/03/26.
//

import Foundation
import SwiftUI
import GoogleSignIn
import Combine
import FirebaseCore
import FirebaseAuth


final class GoogleSignInViewModel: ObservableObject {

    // MARK: - State
    @Published var isSignedIn: Bool      = false
    @Published var isLoading: Bool       = false
    @Published var errorMessage: String? = nil

    private let repository = GoogleSignInRepository()

    
    nonisolated init() { }
    // MARK: - Sign In
    @MainActor
//    func signIn(viewModel: RegistrationViewModel) async {
//        isLoading    = true
//        errorMessage = nil
//
//        // Get root view controller to present Google Sign In
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootVC = windowScene.windows.first?.rootViewController else {
//            errorMessage = "Could not find root view controller."
//            isLoading = false
//            return
//        }
//
//        do {
//            let userInfo = try await repository.signIn(presenting: rootVC)
//
//            // ✅ Auto-fill registration form with Google info
//            viewModel.firstName = userInfo.name.components(separatedBy: " ").first ?? ""
//            viewModel.lastName  = userInfo.name.components(separatedBy: " ").dropFirst().joined(separator: " ")
//            viewModel.email     = userInfo.email
//
//            isSignedIn = true
//            print("✅ Google Sign In success: \(userInfo.email)")
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//
//        isLoading = false
//    }
    
    func signIn(viewModel: RegistrationViewModel) async {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController =  windowScene.windows.first?.rootViewController else {
            return
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            guard let idToken = result.user.idToken?.tokenString else { return }
            let accessToken = result.user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )

            let authResult = try await Auth.auth().signIn(with: credential)

            // ✅ Save user info in your VM
            viewModel.email = authResult.user.email ?? ""
            viewModel.firstName = authResult.user.displayName ?? ""

            self.isSignedIn = true

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}
