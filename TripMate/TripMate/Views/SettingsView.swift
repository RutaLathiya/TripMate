//
//  SettingsView.swift
//  TripMate
//
//  Created by iMac on 14/04/26.
//

import SwiftUI
import CoreData

struct SettingsView: View {

    let userID: NSManagedObjectID   // 👈 direct injection
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
            .navigationDestination(isPresented: $showChangePassword) {
                ChangePasswordView(userID: userID)
            }
        }
    }
}

//#Preview {
//    SettingsView(userID: userID)
//        .environment(\.managedObjectContext,
//            PersistenceController.shared.container.viewContext)
//}
