//
//  TripViewModel.swift
//  TripMate
//
//  Created by iMac on 25/03/26.
//


import SwiftUI
import CoreData
import Combine

final class TripViewModel: ObservableObject {

    @Published var trips:        [TripEntity] = []
    @Published var isLoading:    Bool         = false
    @Published var errorMessage: String?      = nil
    @Published var isSaved:      Bool         = false
    @Published var lastSavedTrip: TripEntity?
    
    private let repository: TripRepositoryProtocol

    init(repository: TripRepositoryProtocol = TripRepository()) {
        self.repository = repository
    }

    // MARK: - Save
    @MainActor
    func saveTrip(title: String,
                  destination: String,
                  startLat: Double, startLng: Double,
                  endLat: Double,   endLng: Double,
                  userObjectID: NSManagedObjectID,
                  friends: [TripFriend] = [] ) async {
        isLoading = true
        do {
            let trip = try repository.saveTrip(
                title: title,
                destination: destination,
                startLatitude: startLat,
                startLongitude: startLng,
                endLatitude: endLat,
                endLongitude: endLng,
                userObjectID: userObjectID
            )
            // ✅ Save members after trip is saved
            if !friends.isEmpty {
                      let memberRepo = TripMemberRepository()
                      for friend in friends {
                          try memberRepo.saveMember(friend, tripID: trip.objectID)
                      }
                      print("✅ Saved \(friends.count) members")
                  }
            lastSavedTrip = trip
            isSaved = true
            
            await fetchTrips(userObjectID: userObjectID)
        } catch {
            errorMessage = "Failed to save trip: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // MARK: - Fetch
    @MainActor
    func fetchTrips(userObjectID: NSManagedObjectID) async {
        do {
            trips = try repository.fetchTrips(for: userObjectID)
        } catch {
            errorMessage = "Failed to fetch trips."
        }
    }

    // MARK: - Delete
    @MainActor
    func deleteTrip(_ trip: TripEntity) {
        do {
            try repository.deleteTrip(trip)
            trips.removeAll { $0.tid == trip.tid }
        } catch {
            errorMessage = "Failed to delete trip."
        }
    }
    
    @MainActor
    func startTrip(_ trip: TripEntity) {
        do {
            try repository.startTrip(trip)
        } catch {
            errorMessage = "Failed to start trip."
        }
    }

    @MainActor
    func endTrip(_ trip: TripEntity) {
        do {
            try repository.endTrip(trip)
        } catch {
            errorMessage = "Failed to end trip."
        }
    }
    
    // MARK: - UPDATE TRIP

    @MainActor
    func updateTrip(_ trip: TripEntity,
                    title: String,
                    destination: String,
                    startLat: Double, startLng: Double,
                    endLat: Double, endLng: Double,
                    friends: [TripFriend] = [],
                    userObjectID: NSManagedObjectID) async {
        isLoading = true
        do {
            try repository.updateTrip(
                trip,
                title: title,
                destination: destination,
                startLatitude: startLat,
                startLongitude: startLng,
                endLatitude: endLat,
                endLongitude: endLng
            )

            // ✅ Update members — delete old, save new
            let memberRepo = TripMemberRepository()
            let oldMembers = try memberRepo.fetchMembers(for: trip.objectID)
            for old in oldMembers {
                try memberRepo.deleteMember(old)
            }
            for friend in friends {
                try memberRepo.saveMember(friend, tripID: trip.objectID)
            }

            isSaved = true
            await fetchTrips(userObjectID: userObjectID)
        } catch {
            errorMessage = "Failed to update trip: \(error.localizedDescription)"
        }
        isLoading = false
    }

}
 
