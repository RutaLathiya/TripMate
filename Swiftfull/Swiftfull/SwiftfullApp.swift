//
//  SwiftfullApp.swift
//  Swiftfull
//
//  Created by iMac on 02/02/26.
//

import SwiftUI
import CoreData

@main
struct SwiftfullApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
