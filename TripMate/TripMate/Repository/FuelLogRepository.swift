//
//  FuelLogRepository.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import CoreData

class FuelLogRepository {
    private let context = PersistenceController.shared.container.viewContext

    func addLog(tripID: NSManagedObjectID, liters: Double,
                pricePerLiter: Double, location: String,
                odometer: Double, date: Date) {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else { return }
        let log = FuelLogEntity(context: context)
        log.fuelId        = UUID()
        log.liters        = liters
        log.pricePerLiter = pricePerLiter
        log.totalCost     = liters * pricePerLiter
        log.location      = location
        log.odometer      = odometer
        log.date          = date
        log.trip          = trip
        try? context.save()
    }

    func fetchLogs(for trip: TripEntity) -> [FuelLogEntity] {
        let req: NSFetchRequest<FuelLogEntity> = FuelLogEntity.fetchRequest()
        req.predicate = NSPredicate(format: "trip == %@", trip)
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return (try? context.fetch(req)) ?? []
    }

    func deleteLog(_ log: FuelLogEntity) {
        context.delete(log)
        try? context.save()
    }
}
