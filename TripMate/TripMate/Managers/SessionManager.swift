//
//  SessionManager.swift
//  TripMate
//
//  Created by iMac on 17/04/26.
//


import Foundation
import CoreData

class SessionManager {

    static let shared = SessionManager()
    private init() {}

    private let userIDKey = "loggedInUserObjectID"

    // MARK: - Save after login

    func saveLoggedInUser(_ objectID: NSManagedObjectID) {
        let uriString = objectID.uriRepresentation().absoluteString
        UserDefaults.standard.set(uriString, forKey: userIDKey)
    }

    // MARK: - Retrieve current user's objectID

    func loggedInUserObjectID(in context: NSManagedObjectContext) -> NSManagedObjectID? {
        guard
            let uriString = UserDefaults.standard.string(forKey: userIDKey),
            let url = URL(string: uriString),
            let coordinator = context.persistentStoreCoordinator,
            let objectID = coordinator.managedObjectID(forURIRepresentation: url)
        else { return nil }
        return objectID
    }

    // MARK: - Clear on logout

    func clearSession() {
        UserDefaults.standard.removeObject(forKey: userIDKey)
    }
}
