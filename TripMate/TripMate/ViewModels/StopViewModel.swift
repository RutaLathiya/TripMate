//
//  StopViewModel.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import CoreData
import Foundation
import Combine

class StopViewModel: ObservableObject {
    @Published var stops: [StopEntity] = []
    private let context = PersistenceController.shared.container.viewContext

    func fetchStops(for trip: TripEntity) {
        let request: NSFetchRequest<StopEntity> = StopEntity.fetchRequest()
        request.predicate = NSPredicate(format: "trip == %@", trip)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            stops = try context.fetch(request)
        } catch {
            print("Fetch stops error: \(error)")
        }
    }

    func addStop(to trip: TripEntity, name: String, date: Date, note: String, latitude: Double, longitude: Double) {
        let stop = StopEntity(context: context)
        stop.stopId = UUID()
        stop.stopName = name
        stop.date = date
        stop.note = note
        stop.latitude = latitude
        stop.longitude = longitude
        stop.trip = trip
        saveContext()
        fetchStops(for: trip)
    }

    func updateStop(_ stop: StopEntity, name: String, date: Date, note: String, latitude: Double, longitude: Double) {
        stop.stopName = name
        stop.date = date
        stop.note = note
        stop.latitude = latitude
        stop.longitude = longitude
        saveContext()
    }

    func deleteStop(_ stop: StopEntity, from trip: TripEntity) {
        context.delete(stop)
        saveContext()
        fetchStops(for: trip)
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Save stop error: \(error)")
        }
    }
}
