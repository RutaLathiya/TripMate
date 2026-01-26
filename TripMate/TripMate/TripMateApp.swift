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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
