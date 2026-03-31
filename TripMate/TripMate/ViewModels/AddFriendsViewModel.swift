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
 
final class AddFriendsViewModel: ObservableObject {
 
    // MARK: - Published State
    @Published var friends: [TripFriend] = []
    @Published var saveError: String? = nil
 
    // MARK: - Mode
    let mode: AddFriendsMode
 
    // MARK: - Dependencies
    private let repository: TripMemberRepositoryProtocol?
 
    // MARK: - Init
 
    // Create Trip flow — no CoreData saving yet, just local array
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
        // ✅ If isLinked, verify user exists before adding
        if friend.isLinked {
           // let repo = TripMemberRepository()
            let context = PersistenceController.shared.context
            let request = UserEntity.fetchRequest()
            let normalizedPhone = friend.phone
                .replacingOccurrences(of: "+91", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
                .trimmingCharacters(in: .whitespaces)
            
            request.predicate = NSPredicate(format: "phoneNo == %@", normalizedPhone)
            request.fetchLimit = 1
            
            if let count = try? context.count(for: request), count == 0 {
                // ✅ No matching user — add as unlinked
                let unlinkedFriend = TripFriend(
                    name: friend.name,
                    phone: friend.phone,
                    isLinked: false  // ← force unlinked
                )
                friends.append(unlinkedFriend)
                saveError = "No TripMate account found for \(friend.phone). Added as unlinked."
                return
            }
        }
        
        friends.append(friend)
        if case .edit(let tripObjectID) = mode {
            persist(friend, tripID: tripObjectID)
        }
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
