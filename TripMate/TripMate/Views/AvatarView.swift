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

    var body: some View {
        AsyncImage(url: AvatarHelper.url(seed: seed)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure(_):
                // Network failed — show initials circle
                fallbackView

            case .empty:
                // Still loading — show placeholder
                Circle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.6)
                    )

            @unknown default:
                fallbackView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    // Initials fallback — uses first letter of seed
    private var fallbackView: some View {
        Circle()
            .fill(Color(.systemGray5))
            .overlay(
                Text(seed.prefix(1).uppercased())
                    .font(.system(size: size * 0.4, weight: .medium))
                    .foregroundColor(.secondary)
            )
    }
}
