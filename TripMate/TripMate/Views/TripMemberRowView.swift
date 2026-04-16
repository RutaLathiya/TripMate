//
//  TripMemberRowView.swift
//  TripMate
//
//  Created by iMac on 16/04/26.
//

import SwiftUI

struct TripMemberRowView: View {
    let member: TripMemberEntity
    let isOwner: Bool

    var body: some View {
        HStack(spacing: 12) {

            // ✅ Avatar
            AvatarView(seed: member.memberName ?? "", size: 42)

            VStack(alignment: .leading, spacing: 2) {
                Text(member.memberName ?? "Unknown")
                    .font(.system(size: 14, weight: .medium))
                Text(member.phoneNo ?? "Not on TripMate")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Owner badge
            if isOwner {
                Text("Owner")
                    .font(.system(size: 11, weight: .semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
            }
        }
        .padding(.vertical, 6)
    }
}
