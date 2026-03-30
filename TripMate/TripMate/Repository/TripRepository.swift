//
//  TripRepository.swift
//  TripMate
//
//  Created by iMac on 25/03/26.
//

import CoreData

protocol TripRepositoryProtocol {
    func saveTrip(title: String,
                  destination: String,
                  startLatitude: Double,
                  startLongitude: Double,
                  endLatitude: Double,
                  endLongitude: Double,
                  userObjectID: NSManagedObjectID) throws -> TripEntity
    
    func fetchTrips(for userObjectID: NSManagedObjectID) throws -> [TripEntity]
    
    func deleteTrip(_ trip: TripEntity) throws
    
    func startTrip(_ trip: TripEntity) throws
    
    func endTrip(_ trip: TripEntity) throws
    
    func updateTrip(_ trip: TripEntity,
                    title: String,
                    destination: String,
                    startLatitude: Double,
                    startLongitude: Double,
                    endLatitude: Double,
                    endLongitude: Double) throws
    
}

final class TripRepository: TripRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func saveTrip(title: String,
                  destination: String,
                  startLatitude: Double,
                  startLongitude: Double,
                  endLatitude: Double,
                  endLongitude: Double,
                  userObjectID: NSManagedObjectID) throws -> TripEntity {

        let trip        = TripEntity(context: context)
        trip.tid        = UUID()
        trip.title      = title
        trip.destination = destination
        trip.startDate  = nil  // ✅ nil until user taps Start Trip
        trip.endDate    = nil  // ✅ nil until user taps End Trip
        trip.startLatitude  = startLatitude
        trip.startLongitude = startLongitude
        trip.endLatitude    = endLatitude
        trip.endLongitude   = endLongitude
        trip.createdAt  = Date()

        if let user = try? context.existingObject(with: userObjectID) as? UserEntity {
            trip.user = user
        }

        try context.save()
        print("✅ Trip saved: \(title)")
        return trip
    }

    func startTrip(_ trip: TripEntity) throws {
        trip.startDate = Date()  // ✅ use existing field
        try context.save()
        print("✅ Trip started: \(trip.title ?? "")")
    }

    func endTrip(_ trip: TripEntity) throws {
        trip.endDate = Date()    // ✅ use existing field
        try context.save()
        print("✅ Trip ended: \(trip.title ?? "")")
    }
    
    func fetchTrips(for userObjectID: NSManagedObjectID) throws -> [TripEntity] {
        let request = TripEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        if let user = try? context.existingObject(with: userObjectID) as? UserEntity {
            request.predicate = NSPredicate(format: "user == %@", user)
        }
        return try context.fetch(request)
    }

    func deleteTrip(_ trip: TripEntity) throws {
        context.delete(trip)
        try context.save()
    }
    
    func updateTrip(_ trip: TripEntity,
                    title: String,
                    destination: String,
                    startLatitude: Double,
                    startLongitude: Double,
                    endLatitude: Double,
                    endLongitude: Double) throws {
        trip.title          = title
        trip.destination    = destination
        trip.startLatitude  = startLatitude
        trip.startLongitude = startLongitude
        trip.endLatitude    = endLatitude
        trip.endLongitude   = endLongitude
        try context.save()
        print("✅ Trip updated: \(title)")
    }
    
}
