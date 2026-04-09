//
//  AdminRepository.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import CoreData

class AdminRepository {
    private let context = PersistenceController.shared.container.viewContext

    // Seed a default admin if none exists
    func seedAdminIfNeeded() {
        let req: NSFetchRequest<AdminEntity> = AdminEntity.fetchRequest()
        let count = (try? context.count(for: req)) ?? 0
        guard count == 0 else { return }
        let admin = AdminEntity(context: context)
        admin.adminId   = UUID()
        admin.adminName = "Admin"
        admin.password  = "admin123"   // change this
        admin.role      = "Super Admin"
        admin.status    = "Active"
        try? context.save()
    }

    func login(username: String, password: String) -> AdminEntity? {
        let req: NSFetchRequest<AdminEntity> = AdminEntity.fetchRequest()
        req.predicate = NSPredicate(
            format: "adminName == %@ AND password == %@", username, password
        )
        return try? context.fetch(req).first
    }

    func fetchAllUsers() -> [UserEntity] {
        let req: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return (try? context.fetch(req)) ?? []
    }

    func fetchAllTrips() -> [TripEntity] {
        let req: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return (try? context.fetch(req)) ?? []
    }

    func deleteUser(_ user: UserEntity) {
        context.delete(user)
        try? context.save()
    }

    func deleteTrip(_ trip: TripEntity) {
        context.delete(trip)
        try? context.save()
    }

    func toggleUserStatus(_ user: UserEntity) {
        user.status = (user.status == "Active") ? "Inactive" : "Active"
        try? context.save()
    }
}
