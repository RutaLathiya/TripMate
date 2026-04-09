//
//  StopRepository.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import CoreData

class StopRepository {
    private let context = PersistenceController.shared.container.viewContext

    func addStop(name: String, date: Date, note: String,
                 latitude: Double, longitude: Double,
                 tripID: NSManagedObjectID) {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else { return }
        let stop = StopEntity(context: context)
        stop.stopId    = UUID()
        stop.stopName  = name
        stop.date      = date
        stop.note      = note
        stop.latitude  = latitude
        stop.longitude = longitude
        stop.trip      = trip
        try? context.save()
    }

    func fetchStops(for trip: TripEntity) -> [StopEntity] {
        let req: NSFetchRequest<StopEntity> = StopEntity.fetchRequest()
        req.predicate = NSPredicate(format: "trip == %@", trip)
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return (try? context.fetch(req)) ?? []
    }

    func deleteStop(_ stop: StopEntity) {
        context.delete(stop)
        try? context.save()
    }
}
