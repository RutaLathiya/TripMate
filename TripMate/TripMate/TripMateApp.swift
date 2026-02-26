//
//  TripMateApp.swift
//  TripMate
//
//  Created by iMac on 26/01/26.
//

import SwiftUI
import CoreData

@main
struct TripMateApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var SessionVM = SessionViewModel()
   
    var body: some Scene {
        WindowGroup {
//            RegistrationView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environmentObject(SessionViewModel())
            
            if SessionVM.isLoggedIn {
                            HomeView()
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .environmentObject(SessionVM)   // 👈 same sessionVM everywhere
            } else if SessionVM.showLogIn {
                            LogIn()
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .environmentObject(SessionVM)   // 👈 same sessionVM everywhere
            } else {
                RegistrationView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(SessionVM)
            }
        }
    }
}
