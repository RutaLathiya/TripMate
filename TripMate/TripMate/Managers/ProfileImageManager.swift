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
    @Published var avatarImage: UIImage? = nil  // ✅ cache DiceBear here

    func load(uid: UUID, context: NSManagedObjectContext) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid == %@", uid as CVarArg)

        if let user = try? context.fetch(request).first {
            if let data = user.profilePic, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                    self.avatarImage = nil  // ✅ clear avatar cache when real photo exists
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImage = nil  // ✅ clear real photo
                    // don't touch avatarImage here — let it persist
                }
            }
        }
    }

    func loadAvatar(seed: String) {
            guard !seed.isEmpty, avatarImage == nil else { return }
            guard let url = AvatarHelper.url(seed: seed) else { return }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.avatarImage = image
                    }
                }
            }.resume()
        }

    func clear() {
        profileImage = nil
        avatarImage = nil
    }
}
