//
//  AvatarView.swift
//  TripMate
//
//  Created by iMac on 15/04/26.
//

import SwiftUI

struct AvatarView: View {
    let seed: String
    var size: CGFloat = 40
    
    // ✅ Cache rendered image in memory to avoid re-fetch flicker
   // var imageManager: ProfileImageManager? = nil
    //@State private var hasFailed = false

    var body: some View {
//       Group {
//            if let cached = imageManager?.avatarImage, imageManager?.profileImage == nil {
//                // ✅ Already loaded — show instantly, no flash
//                Image(uiImage: cached)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: size, height: size)
//                    .clipShape(Circle())
//            } else if hasFailed || seed.isEmpty {
//                // ✅ Network failed or no seed — show initials
//                fallbackView
//            } else {
                AsyncImage(
                    url: AvatarHelper.url(seed: seed),
                    transaction: Transaction(animation: .easeIn(duration: 0.2))
                ) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())

                    case .failure(let error):
                        let _ = print("❌ Avatar failed: \(error.localizedDescription) | seed: \(seed)")
                        fallbackView
                           // .onAppear { hasFailed = true }

                    case .empty:
//                        // Loading — show subtle placeholder, not grey circle
//                        if let cached = imageManager?.avatarImage {
//                            Image(uiImage: cached)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: size, height: size)
//                                .clipShape(Circle())
//                        } else {
                            Circle()
                                .fill(Color.AccentColor.opacity(0.15))
                                .frame(width: size, height: size)
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(0.6)
                                        .tint(Color.AccentColor)
                                )
                        //}
                    @unknown default:
                        fallbackView
                    }
                }
           // }
     //   }
        // ✅ When seed changes (e.g. after logout/login), reset cache
      //  .onChange(of: seed) { _, _ in
       //     hasFailed = false
        //}
                .frame(width: size, height: size)
                .clipShape(Circle())
    }

    private var fallbackView: some View {
        Circle()
            .fill(Color.AccentColor.opacity(0.15))
            .frame(width: size, height: size)
            .overlay(
                Text(seed.prefix(1).uppercased())
                    .font(.system(size: size * 0.4, weight: .medium))
                    .foregroundColor(Color.AccentColor)
            )
    }
}
#Preview {
    HStack {
        AvatarView(seed: "Ruta", size: 100)
        AvatarView(seed: "Lathiya", size: 60)
        AvatarView(seed: "", size: 40)
    }
    .padding()
}
