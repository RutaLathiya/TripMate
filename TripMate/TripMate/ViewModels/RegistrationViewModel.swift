//
//  RegistrationViewModel.swift
//  TripMate
//
//  Created by iMac on 28/01/26.
//

import SwiftUI
import Combine

class RegistrationViewModel: ObservableObject {
    
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    func register() {
        // This is where you'll add Core Data logic
        // For now, just printing values
        print("Full Name: \(fullName)")
        print("Email: \(email)")
        print("Password: \(password)")
        print("Confirm Password: \(confirmPassword)")
        
        // Add validation and Core Data save logic here
    }
}
