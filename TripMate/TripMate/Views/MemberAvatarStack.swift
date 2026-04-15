//
//  MemberAvatarStack.swift
//  TripMate
//
//  Created by iMac on 15/04/26.
//

//import SwiftUI

//struct MemberAvatarStack: View {
//    let members: [TripMemberRepository]
//    var size: CGFloat = 32
//    var maxVisible: Int = 3
//    var overlap: CGFloat = 8
//    var borderColor: Color = .white
//    private var visibleMembers: [TripMemberRepository] { Array(members.prefix(maxVisible)) }
//    private var remaining: Int { max(0, members.count - maxVisible) }
//    var body: some View {
//        HStack(spacing: -overlap) {
//            ForEach(visibleMembers) { member in AvatarView(seed: member.name, size: size)
//
//                    .overlay(
//                        Circle().stroke(borderColor, lineWidth: 2)
//                    )
//                    .zIndex(Double(visibleMembers
//                        .firstIndex(of: member) ?? 0)) }
//            if remaining > 0 {
//                ZStack {
//                    Circle()
//                        .fill(Color(.systemGray5))
//                        .overlay(
//                            Circle()
//                                .stroke(borderColor, lineWidth: 2)
//                        )
//                    Text("+\(remaining)")
//                        .font(.system(size: size * 0.35, weight: .medium))
//                    .foregroundColor(.secondary) }
//                .frame(width: size, height: size)
//            }
//        }
//    }
//} // Usage: // MemberAvatarStack(members: trip.members) // MemberAvatarStack(members: trip.members, size: 26, maxVisible: 4)
//

import SwiftUI
import CoreData

struct MemberAvatarStack: View {
    let members: [TripMemberEntity]
    var size: CGFloat = 32
    var maxVisible: Int = 3
    var overlap: CGFloat = 8
    var borderColor: Color = Color(.systemBackground) // adapts light/dark

    private var visibleMembers: [TripMemberEntity] {
        Array(members.prefix(maxVisible))
    }
    private var remaining: Int {
        max(0, members.count - maxVisible)
    }

    var body: some View {
        HStack(spacing: -overlap) {
            ForEach(Array(visibleMembers.enumerated()), id: \.offset) { index, member in
                AvatarView(seed: member.memberName ?? "", size: size)
                    .overlay(Circle().stroke(borderColor, lineWidth: 2))
                    .zIndex(Double(visibleMembers.count - index)) // ✅ last on top
            }
            if remaining > 0 {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .overlay(Circle().stroke(borderColor, lineWidth: 2))
                    Text("+\(remaining)")
                        .font(.system(size: size * 0.35, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(width: size, height: size)
            }
        }
    }
}

//#Preview {
//    let m1 = TripMemberEntity()
//    m1.memberName = "Vraj"
//
//    let m2 = TripMemberEntity()
//    m2.memberName = "Krushna"
//
//    let m3 = TripMemberEntity()
//    m3.memberName = "Meet"
//
//    let m4 = TripMemberEntity()
//    m4.memberName = "Jay"
//
//    return MemberAvatarStack(members: [m1, m2, m3, m4])
//}
