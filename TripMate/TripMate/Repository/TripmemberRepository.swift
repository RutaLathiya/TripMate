//
//  TripmemberRepository.swift
//  TripMate
//
//  Created by iMac on 23/03/26.
//

import CoreData
 
// MARK: - Protocol
protocol TripMemberRepositoryProtocol {
    func saveMember(_ friend: TripFriend, tripID: NSManagedObjectID) throws
    func fetchMembers(for tripID: NSManagedObjectID) throws -> [TripMemberEntity]
    func deleteMember(_ entity: TripMemberEntity) throws
}
 
// MARK: - Repository
final class TripMemberRepository: TripMemberRepositoryProtocol {
 
    private let context: NSManagedObjectContext
 
    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }
 
    // MARK: - Save
    func saveMember(_ friend: TripFriend, tripID: NSManagedObjectID) throws {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else {
            throw MemberRepositoryError.tripNotFound
        }
 
        let entity = TripMemberEntity(context: context)
        entity.tripMemberId = UUID()
        entity.memberName = friend.name
        entity.phoneNo = friend.phone
        entity.trip = trip
        
        if friend.isLinked {
            let request = UserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "phone_no == %@", friend.phone)
            request.fetchLimit = 1
            entity.user = try? context.fetch(request).first
        }
 
        try context.save()
    }
 
    // MARK: - Fetch all members for a trip
    func fetchMembers(for tripID: NSManagedObjectID) throws -> [TripMemberEntity] {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else {
            throw MemberRepositoryError.tripNotFound
        }
 
        let request = TripMemberEntity.fetchRequest()
        request.predicate = NSPredicate(format: "trip == %@", trip)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return try context.fetch(request)
    }
 
    // MARK: - Delete
    func deleteMember(_ entity: TripMemberEntity) throws {
        context.delete(entity)
        try context.save()
    }
}
 
// MARK: - Errors
enum MemberRepositoryError: LocalizedError {
    case tripNotFound
 
    var errorDescription: String? {
        switch self {
        case .tripNotFound:
            return "Trip not found in database."
        }
    }
}
