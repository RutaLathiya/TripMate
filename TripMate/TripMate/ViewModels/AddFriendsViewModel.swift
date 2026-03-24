//
//  AddFriendsViewModel.swift
//  TripMate
//
//  Created by iMac on 23/03/26.
//

import SwiftUI
import CoreData
import Combine
//
//// MARK: - AddFriends ViewModel
//final class AddFriendsViewModel: ObservableObject {
//
//    // MARK: - Published State
//    @Published var friends: [TripFriend] = []
//    @Published var saveError: String? = nil
//
//    // MARK: - Dependencies
//    private let repository: TripMemberRepositoryProtocol
//    private let tripObjectID: NSManagedObjectID
//
//    // MARK: - Init
//    init(
//        tripObjectID: NSManagedObjectID,
//        repository: TripMemberRepositoryProtocol = TripMemberRepository()
//    ) {
//        self.tripObjectID = tripObjectID
//        self.repository   = repository
//    }
//
//    // MARK: - Intents
//
//    func addFriend(_ friend: TripFriend) {
//        friends.append(friend)
//        persist(friend)
//    }
//
//    func removeFriend(_ friend: TripFriend) {
//        friends.removeAll { $0.id == friend.id }
//        // Note: to also delete from CoreData, fetch by member_id and call repository.deleteMember()
//    }
//
//    // MARK: - Private: Persist to CoreData
//    private func persist(_ friend: TripFriend) {
//        do {
//            try repository.saveMember(friend, tripID: tripObjectID)
//        } catch {
//            saveError = error.localizedDescription
//        }
//    }
//}
//
//// MARK: - AddFriendSheet ViewModel
//final class AddFriendSheetViewModel: ObservableObject {
//
//    // MARK: - Form Fields
//    @Published var name: String     = ""
//    @Published var phone: String    = ""
//    @Published var isLinked: Bool   = false
//
//    // MARK: - Validation
//    var canAdd: Bool {
//        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
//        !phone.trimmingCharacters(in: .whitespaces).isEmpty
//    }
//
//    // MARK: - Build TripFriend model
//    func buildFriend() -> TripFriend? {
//        guard canAdd else { return nil }
//        return TripFriend(
//            name: name.trimmingCharacters(in: .whitespaces),
//            phone: phone.trimmingCharacters(in: .whitespaces),
//            isLinked: isLinked
//        )
//    }
//}

 
// MARK: - Mode
// Determines whether we're in "create trip" flow or "edit existing trip" flow
enum AddFriendsMode {
    case create                              // local only — save later with trip
    case edit(tripObjectID: NSManagedObjectID) // save to CoreData immediately
}
 
// MARK: - AddFriends ViewModel
final class AddFriendsViewModel: ObservableObject {
 
    // MARK: - Published State
    @Published var friends: [TripFriend] = []
    @Published var saveError: String? = nil
 
    // MARK: - Mode
    let mode: AddFriendsMode
 
    // MARK: - Dependencies
    private let repository: TripMemberRepositoryProtocol?
 
    // MARK: - Init
 
    /// Create Trip flow — no CoreData saving yet, just local array
    init() {
        self.mode       = .create
        self.repository = nil
    }
 
    /// Trip Detail flow — saves to CoreData immediately
    init(
        tripObjectID: NSManagedObjectID,
        repository: TripMemberRepositoryProtocol = TripMemberRepository()
    ) {
        self.mode       = .edit(tripObjectID: tripObjectID)
        self.repository = repository
    }
 
    // MARK: - Intents
 
    func addFriend(_ friend: TripFriend) {
        friends.append(friend)
 
        // Only persist immediately in edit mode
        if case .edit(let tripObjectID) = mode {
            persist(friend, tripID: tripObjectID)
        }
        // In create mode, friends stay local until trip is saved
    }
 
    func removeFriend(_ friend: TripFriend) {
        friends.removeAll { $0.id == friend.id }
        // CoreData delete can be wired here later for edit mode
    }
 
    // MARK: - Private: Persist to CoreData
    private func persist(_ friend: TripFriend, tripID: NSManagedObjectID) {
        do {
            try repository?.saveMember(friend, tripID: tripID)
        } catch {
            saveError = error.localizedDescription
        }
    }
}
 
// MARK: - AddFriendSheet ViewModel
final class AddFriendSheetViewModel: ObservableObject {
 
    // MARK: - Form Fields
    @Published var name: String   = ""
    @Published var phone: String  = ""
    @Published var isLinked: Bool = false
 
    // MARK: - Validation
    var canAdd: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }
 
    // MARK: - Build TripFriend model
    func buildFriend() -> TripFriend? {
        guard canAdd else { return nil }
        return TripFriend(
            name: name.trimmingCharacters(in: .whitespaces),
            phone: phone.trimmingCharacters(in: .whitespaces),
            isLinked: isLinked
        )
    }
}
