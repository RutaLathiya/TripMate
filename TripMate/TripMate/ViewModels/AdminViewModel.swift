//
//  AdminViewModel.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import Foundation
import Combine

class AdminViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var errorMessage: String? = nil
    @Published var users: [UserEntity] = []
    @Published var trips: [TripEntity] = []

    private let repo = AdminRepository()

    func login(username: String, password: String) {
        repo.seedAdminIfNeeded()
        if repo.login(username: username, password: password) != nil {
            isLoggedIn = true
            errorMessage = nil
            loadData()
        } else {
            errorMessage = "Invalid username or password"
        }
    }

    func loadData() {
        users = repo.fetchAllUsers()
        trips = repo.fetchAllTrips()
    }

    func deleteUser(_ user: UserEntity) {
        repo.deleteUser(user)
        loadData()
    }

    func deleteTrip(_ trip: TripEntity) {
        repo.deleteTrip(trip)
        loadData()
    }

    func toggleUserStatus(_ user: UserEntity) {
        repo.toggleUserStatus(user)
        loadData()
    }

    func logout() {
        isLoggedIn = false
    }
}
