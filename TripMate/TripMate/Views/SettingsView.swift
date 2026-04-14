//
//  SettingsView.swift
//  TripMate
//
//  Created by iMac on 14/04/26.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showChangePassword = false
    
    var body: some View {
        ZStack {
            Color.BackgroundColor
                .ignoresSafeArea()
            VStack(spacing: 20) {
                
                Button {
                    showChangePassword = true
                } label: {
                    HStack {
                        Image(systemName: "lock")
                        Text("Change Password")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.AccentColor.opacity(0.2))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
           // .navigationTitle("Settings")
            .navigationDestination(isPresented: $showChangePassword) {
                ChangePasswordView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
