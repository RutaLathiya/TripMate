//
//  ProfileImageManager.swift
//  TripMate
//
//  Created by iMac on 11/03/26.
//

import SwiftUI
import CoreData
import Combine

class ProfileImageManager: ObservableObject {
    @Published var profileImage: UIImage? = nil
    @Published var profileAvatar: String? = nil
    
    func load(uid: UUID, context: NSManagedObjectContext) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid == %@", uid as CVarArg)
        
        if let user = try? context.fetch(request).first,
           let picData = user.profilePic {
            if let avatarString = String(data: picData, encoding: .utf8),
               avatarString.count <= 4 {
                profileAvatar = avatarString
                profileImage = nil
            } else {
                profileImage = UIImage(data: picData)
                profileAvatar = nil
            }
        }
    }
}
