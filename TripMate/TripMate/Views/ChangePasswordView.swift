//
//  ChangePasswordView.swift
//  TripMate
//
//  Created by iMac on 14/04/26.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            Color.BackgroundColor
                .ignoresSafeArea()
        VStack(spacing: 20) {
            
            SecureField("Current Password", text: $currentPassword)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.ContainerColor)
                .cornerRadius(15)
                
            
            SecureField("New Password", text: $newPassword)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.ContainerColor)
                .cornerRadius(15)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.ContainerColor)
                .cornerRadius(15)
            
            Button("Update Password") {
                updatePassword()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.AccentColor)
            .foregroundColor(.white)
            .cornerRadius(15)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Change Password")
    }
}
    
    func updatePassword() {
        if newPassword != confirmPassword {
            print("❌ Passwords do not match")
            return
        }
        
        // 🔥 integrate backend / Firebase / CoreData here
        print("✅ Password Updated")
    }
}

#Preview {
    ChangePasswordView()
}
