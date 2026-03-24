////
////  AddFriendsView.swift
////  TripMate
////
////  Created by iMac on 10/03/26.
////
//
//
//import SwiftUI
//
//struct AddFriendsView: View {
//
//    @Binding var friends: [TripFriend]
//    @State private var showAddSheet = false
//
//    var body: some View {
//        VStack(spacing: 12) {
//            addButton
//            if friends.isEmpty {
//                emptyState
//            } else {
//                friendsList
//            }
//        }
//        .sheet(isPresented: $showAddSheet) {
//            AddFriendSheet { newFriend in
//                withAnimation { friends.append(newFriend) }
//            }
//        }
//    }
//
//    // MARK: - Add Button
//
//    private var addButton: some View {
//        Button {
//            showAddSheet = true
//        } label: {
//            HStack(spacing: 8) {
//                Image(systemName: "person.badge.plus")
//                    .font(.system(size: 18))
//                Text("ADD MEMBER")
//                    .font(.system(size: 12, weight: .bold, design: .monospaced))
//                    .kerning(2)
//            }
//            .foregroundColor(Color.AccentColor)
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 16)
//            .background(Color.AccentColor.opacity(0.05))
//            .cornerRadius(14)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(
//                        Color.AccentColor.opacity(0.3),
//                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
//                    )
//            )
//        }
//    }
//
//    // MARK: - Empty State
//
//    private var emptyState: some View {
//        VStack(spacing: 12) {
//            Image(systemName: "person.2.slash")
//                .font(.system(size: 44))
//                .foregroundColor(.AccentColor.opacity(0.4))
//            Text("NO MEMBERS YET")
//                .font(.system(size: 12, design: .monospaced))
//                .foregroundColor(.AccentColor.opacity(0.4))
//                .kerning(2)
//            Text("Add friends to share this trip")
//                .font(.system(size: 11, design: .monospaced))
//                .foregroundColor(.AccentColor.opacity(0.4))
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 48)
//    }
//
//    // MARK: - Friends List
//
//    private var friendsList: some View {
//        VStack(spacing: 10) {
//            // Member count badge
//            HStack {
//                Text("\(friends.count) MEMBER\(friends.count == 1 ? "" : "S")")
//                    .font(.system(size: 10, weight: .bold, design: .monospaced))
//                    .foregroundColor(Color.AccentColor)
//                    .kerning(2)
//                Spacer()
//            }
//            .padding(.horizontal, 4)
//
//            ForEach(friends) { friend in
//                friendRow(friend)
//                    .transition(.scale.combined(with: .opacity))
//            }
//        }
//    }
//
//    private func friendRow(_ friend: TripFriend) -> some View {
//        HStack(spacing: 14) {
//
//            // Avatar
//            ZStack {
//                Circle()
//                    .fill(
//                        LinearGradient(
//                            colors: [Color.AccentColor.opacity(0.4), Color.AccentColor.opacity(0.2)],
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .frame(width: 42, height: 42)
//                    .overlay(
//                        Circle()
//                            .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1)
//                    )
//                Text(friend.avatarInitials)
//                    .font(.system(size: 14, weight: .bold, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//            }
//
//            // Info
//            VStack(alignment: .leading, spacing: 4) {
//                Text(friend.name)
//                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//
//                HStack(spacing: 6) {
//                    Image(systemName: "phone")
//                        .font(.system(size: 9))
//                        .foregroundColor(Color.AccentColor.opacity(0.6))
//                    Text(friend.phone)
//                        .font(.system(size: 11, design: .monospaced))
//                        .foregroundColor(.AccentColor.opacity(0.35))
//                }
//            }
//
//            Spacer()
//
//            // Linked badge
//            VStack(spacing: 6) {
//                if friend.isLinked {
//                    HStack(spacing: 4) {
//                        Image(systemName: "link.circle.fill")
//                            .font(.system(size: 10))
//                        Text("LINKED")
//                            .font(.system(size: 9, weight: .bold, design: .monospaced))
//                            .kerning(0.5)
//                    }
//                    .foregroundColor(.green)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color.green.opacity(0.1))
//                    .cornerRadius(6)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 6)
//                            .stroke(Color.green.opacity(0.25), lineWidth: 1)
//                    )
//                }
//
//                // Remove button
//                Button {
//                    withAnimation { friends.removeAll { $0.id == friend.id } }
//                } label: {
//                    Image(systemName: "xmark")
//                        .font(.system(size: 10, weight: .bold))
//                        .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
//                        .frame(width: 26, height: 26)
//                        .background(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.1))
//                        .cornerRadius(7)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 7)
//                                .stroke(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.2), lineWidth: 1)
//                        )
//                }
//            }
//        }
//        .padding(14)
//        .background(Color.BackgroundColor)
//        .cornerRadius(14)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
//        )
//    }
//}
//
//// MARK: - Add Friend Sheet
//
//struct AddFriendSheet: View {
//    var onAdd: (TripFriend) -> Void
//
//    @Environment(\.dismiss) private var dismiss
//    @State private var name    = ""
//    @State private var phone   = ""
//    @State private var isLinked = false
//
//    private var canAdd: Bool {
//        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
//        !phone.trimmingCharacters(in: .whitespaces).isEmpty
//    }
//
//    var body: some View {
//        ZStack {
//            Color.BackgroundColor.ignoresSafeArea()
//
//            VStack(alignment: .leading, spacing: 0) {
//
//                // Header
//                sheetHeader
//
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 20) {
//                        nameField
//                        phoneField
//                        linkedToggle
//                        Spacer(minLength: 8)
//                        addButton
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.top, 28)
//                    .padding(.bottom, 50)
//                }
//            }
//        }
//        .presentationDetents([.medium, .large])
//        .presentationDragIndicator(.visible)
//    }
//
//    // MARK: Sheet Header
//
//    private var sheetHeader: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                HStack(spacing: 8) {
//                    Circle()
//                        .fill(Color.AccentColor)
//                        .frame(width: 7, height: 7)
//                        .shadow(color: Color.AccentColor.opacity(0.5), radius: 3)
//                    Text("ADD MEMBER")
//                        .font(.system(size: 10, weight: .bold, design: .monospaced))
//                        .foregroundColor(Color.AccentColor)
//                        .kerning(2)
//                }
//                Text("Who's joining ?")
//                    .font(.system(size: 22, weight: .heavy, design: .rounded))
//                    .foregroundColor(.AccentColor)
//            }
//            Spacer()
//            Button {
//                dismiss()
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(.AccentColor.opacity(0.5))
//                    .frame(width: 32, height: 32)
//                    .background(Color.AccentColor.opacity(0.08))
//                    .clipShape(Circle())
//            }
//        }
//        .padding(.horizontal, 24)
//        .padding(.top, 28)
//        .padding(.bottom, 8)
//    }
//
//    // MARK: Name Field
//
//    private var nameField: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("FULL NAME")
//                .font(.system(size: 10, weight: .bold, design: .monospaced))
//                .foregroundColor(Color.AccentColor)
//                .kerning(2)
//
//            HStack(spacing: 12) {
//                Image(systemName: "person")
//                    .foregroundColor(Color.AccentColor.opacity(0.6))
//                    .font(.system(size: 15))
//                TextField("e.g. Raj Patel", text: $name)
//                    .font(.system(size: 14, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//                    .autocorrectionDisabled()
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 14)
//            .background(Color.AccentColor.opacity(0.08))
//            .cornerRadius(14)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(
//                        name.isEmpty ? Color.AccentColor.opacity(0.2) : Color.AccentColor.opacity(0.35),
//                        lineWidth: 1
//                    )
//            )
//        }
//        
//    }
//        
//
//    // MARK: Phone Field
//
//    private var phoneField: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("PHONE NUMBER")
//                .font(.system(size: 10, weight: .bold, design: .monospaced))
//                .foregroundColor(Color.AccentColor)
//                .kerning(2)
//
//            HStack(spacing: 12) {
//                Image(systemName: "phone")
//                    .foregroundColor(Color.AccentColor.opacity(0.6))
//                    .font(.system(size: 15))
//                TextField("+91 98765 43210", text: $phone)
//                    .font(.system(size: 14, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//                    .keyboardType(.phonePad)
//                    .autocorrectionDisabled()
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 14)
//            .background(Color.AccentColor.opacity(0.08))
//            .cornerRadius(14)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(
//                        phone.isEmpty ? Color.AccentColor.opacity(0.2) : Color.AccentColor.opacity(0.35),
//                        lineWidth: 1
//                    )
//            )
//        }
//    }
//
//    // MARK: Linked Toggle
//
//    private var linkedToggle: some View {
//        HStack(spacing: 16) {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("LINK TO ACCOUNT")
//                    .font(.system(size: 11, weight: .bold, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//                    .kerning(1)
//                Text("Connect to their TripMate account")
//                    .font(.system(size: 11, design: .monospaced))
//                    .foregroundColor(.AccentColor.opacity(0.45))
//            }
//            Spacer()
//            Toggle("", isOn: $isLinked)
//                .tint(Color.AccentColor)
//                .labelsHidden()
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 14)
//        .background(Color.AccentColor.opacity(0.08))
//        .cornerRadius(14)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1)
//        )
//    }
//
//    // MARK: Add Button
//
//    private var addButton: some View {
//        Button {
//            guard canAdd else { return }
//            let friend = TripFriend(
//                name: name.trimmingCharacters(in: .whitespaces),
//                phone: phone.trimmingCharacters(in: .whitespaces),
//                isLinked: isLinked
//            )
//            onAdd(friend)
//            dismiss()
//        } label: {
//            HStack(spacing: 10) {
//               
//                Text("🚗 ADD TO TRIP")
//                    .font(.system(size: 18, weight: .heavy, design: .rounded))
//                    .kerning(2)
//            }
//            .foregroundColor(canAdd ? Color.AccentColor : Color.AccentColor.opacity(0.2))
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 18)
//            .background(addButtonBG)
//            .cornerRadius(16)
//            .shadow(
//                color: canAdd ? Color.AccentColor.opacity(0.35) : Color.clear,
//                radius: 14, y: 4
//            )
//        }
//        .disabled(!canAdd)
//    }
//
//    @ViewBuilder
//    private var addButtonBG: some View {
//        if canAdd {
//            LinearGradient(
//                colors: [Color.ContainerColor, Color.ContainerColor.opacity(0.75)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        } else {
//            Color.AccentColor.opacity(0.05)
//        }
//    }
//}
//#Preview {
//    AddFriendSheet{ _ in }
//}


import SwiftUI
import CoreData

//struct AddFriendsView: View {
//
//    @ObservedObject var vm: AddFriendsViewModel
//    @State private var showAddSheet = false
//
//    var body: some View {
//        VStack(spacing: 12) {
//            addButton
//            if vm.friends.isEmpty {
//                emptyState
//            } else {
//                friendsList
//            }
//        }
//        .sheet(isPresented: $showAddSheet) {
//            AddFriendSheet { newFriend in
//                withAnimation { vm.addFriend(newFriend) }
//            }
//        }
//        // Show error alert if CoreData save fails
//        .alert("Save Error", isPresented: Binding(
//            get: { vm.saveError != nil },
//            set: { if !$0 { vm.saveError = nil } }
//        )) {
//            Button("OK", role: .cancel) { vm.saveError = nil }
//        } message: {
//            Text(vm.saveError ?? "")
//        }
//    }
//
//    // MARK: - Add Button
//    private var addButton: some View {
//        Button { showAddSheet = true } label: {
//            HStack(spacing: 8) {
//                Image(systemName: "person.badge.plus")
//                    .font(.system(size: 18))
//                Text("ADD MEMBER")
//                    .font(.system(size: 12, weight: .bold, design: .monospaced))
//                    .kerning(2)
//            }
//            .foregroundColor(Color.AccentColor)
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 16)
//            .background(Color.AccentColor.opacity(0.05))
//            .cornerRadius(14)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(
//                        Color.AccentColor.opacity(0.3),
//                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
//                    )
//            )
//        }
//    }
//
//    // MARK: - Empty State
//    private var emptyState: some View {
//        VStack(spacing: 12) {
//            Image(systemName: "person.2.slash")
//                .font(.system(size: 44))
//                .foregroundColor(.AccentColor.opacity(0.4))
//            Text("NO MEMBERS YET")
//                .font(.system(size: 12, design: .monospaced))
//                .foregroundColor(.AccentColor.opacity(0.4))
//                .kerning(2)
//            Text("Add friends to share this trip")
//                .font(.system(size: 11, design: .monospaced))
//                .foregroundColor(.AccentColor.opacity(0.4))
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 48)
//    }
//
//    // MARK: - Friends List
//    private var friendsList: some View {
//        VStack(spacing: 10) {
//            HStack {
//                Text("\(vm.friends.count) MEMBER\(vm.friends.count == 1 ? "" : "S")")
//                    .font(.system(size: 10, weight: .bold, design: .monospaced))
//                    .foregroundColor(Color.AccentColor)
//                    .kerning(2)
//                Spacer()
//            }
//            .padding(.horizontal, 4)
//
//            ForEach(vm.friends) { friend in
//                friendRow(friend)
//                    .transition(.scale.combined(with: .opacity))
//            }
//        }
//    }
//
//    // MARK: - Friend Row
//    private func friendRow(_ friend: TripFriend) -> some View {
//        HStack(spacing: 14) {
//
//            // Avatar
//            ZStack {
//                Circle()
//                    .fill(
//                        LinearGradient(
//                            colors: [Color.AccentColor.opacity(0.4), Color.AccentColor.opacity(0.2)],
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .frame(width: 42, height: 42)
//                    .overlay(Circle().stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
//                Text(friend.avatarInitials)
//                    .font(.system(size: 14, weight: .bold, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//            }
//
//            // Info
//            VStack(alignment: .leading, spacing: 4) {
//                Text(friend.name)
//                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//                HStack(spacing: 6) {
//                    Image(systemName: "phone")
//                        .font(.system(size: 9))
//                        .foregroundColor(Color.AccentColor.opacity(0.6))
//                    Text(friend.phone)
//                        .font(.system(size: 11, design: .monospaced))
//                        .foregroundColor(.AccentColor.opacity(0.35))
//                }
//            }
//
//            Spacer()
//
//            // Linked badge + Remove button
//            VStack(spacing: 6) {
//                if friend.isLinked {
//                    linkedBadge
//                }
//                removeButton(for: friend)
//            }
//        }
//        .padding(14)
//        .background(Color.BackgroundColor)
//        .cornerRadius(14)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
//        )
//    }
//
//    private var linkedBadge: some View {
//        HStack(spacing: 4) {
//            Image(systemName: "link.circle.fill").font(.system(size: 10))
//            Text("LINKED")
//                .font(.system(size: 9, weight: .bold, design: .monospaced))
//                .kerning(0.5)
//        }
//        .foregroundColor(.green)
//        .padding(.horizontal, 8)
//        .padding(.vertical, 4)
//        .background(Color.green.opacity(0.1))
//        .cornerRadius(6)
//        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.green.opacity(0.25), lineWidth: 1))
//    }
//
//    private func removeButton(for friend: TripFriend) -> some View {
//        Button {
//            withAnimation { vm.removeFriend(friend) }
//        } label: {
//            Image(systemName: "xmark")
//                .font(.system(size: 10, weight: .bold))
//                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
//                .frame(width: 26, height: 26)
//                .background(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.1))
//                .cornerRadius(7)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 7)
//                        .stroke(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.2), lineWidth: 1)
//                )
//        }
//    }
//}
//
//// MARK: - Add Friend Sheet
//struct AddFriendSheet: View {
//
//    var onAdd: (TripFriend) -> Void
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var vm = AddFriendSheetViewModel()
//
//    var body: some View {
//        ZStack {
//            Color.BackgroundColor.ignoresSafeArea()
//            VStack(alignment: .leading, spacing: 0) {
//                sheetHeader
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 20) {
//                        nameField
//                        phoneField
//                        linkedToggle
//                        Spacer(minLength: 8)
//                        addButton
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.top, 28)
//                    .padding(.bottom, 50)
//                }
//            }
//        }
//        .presentationDetents([.medium, .large])
//        .presentationDragIndicator(.visible)
//    }
//
//    // MARK: - Sheet Header
//    private var sheetHeader: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                HStack(spacing: 8) {
//                    Circle()
//                        .fill(Color.AccentColor)
//                        .frame(width: 7, height: 7)
//                        .shadow(color: Color.AccentColor.opacity(0.5), radius: 3)
//                    Text("ADD MEMBER")
//                        .font(.system(size: 10, weight: .bold, design: .monospaced))
//                        .foregroundColor(Color.AccentColor)
//                        .kerning(2)
//                }
//                Text("Who's joining ?")
//                    .font(.system(size: 22, weight: .heavy, design: .rounded))
//                    .foregroundColor(.AccentColor)
//            }
//            Spacer()
//            Button { dismiss() } label: {
//                Image(systemName: "xmark")
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(.AccentColor.opacity(0.5))
//                    .frame(width: 32, height: 32)
//                    .background(Color.AccentColor.opacity(0.08))
//                    .clipShape(Circle())
//            }
//        }
//        .padding(.horizontal, 24)
//        .padding(.top, 28)
//        .padding(.bottom, 8)
//    }
//
//    // MARK: - Name Field
//    private var nameField: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("FULL NAME")
//                .font(.system(size: 10, weight: .bold, design: .monospaced))
//                .foregroundColor(Color.AccentColor)
//                .kerning(2)
//            HStack(spacing: 12) {
//                Image(systemName: "person")
//                    .foregroundColor(Color.AccentColor.opacity(0.6))
//                    .font(.system(size: 15))
//                TextField("e.g. Raj Patel", text: $vm.name)
//                    .font(.system(size: 14, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//                    .autocorrectionDisabled()
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 14)
//            .background(Color.AccentColor.opacity(0.08))
//            .cornerRadius(14)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(
//                        vm.name.isEmpty ? Color.AccentColor.opacity(0.2) : Color.AccentColor.opacity(0.35),
//                        lineWidth: 1
//                    )
//            )
//        }
//    }
//
//    // MARK: - Phone Field
//    private var phoneField: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("PHONE NUMBER")
//                .font(.system(size: 10, weight: .bold, design: .monospaced))
//                .foregroundColor(Color.AccentColor)
//                .kerning(2)
//            HStack(spacing: 12) {
//                Image(systemName: "phone")
//                    .foregroundColor(Color.AccentColor.opacity(0.6))
//                    .font(.system(size: 15))
//                TextField("+91 98765 43210", text: $vm.phone)
//                    .font(.system(size: 14, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//                    .keyboardType(.phonePad)
//                    .autocorrectionDisabled()
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 14)
//            .background(Color.AccentColor.opacity(0.08))
//            .cornerRadius(14)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(
//                        vm.phone.isEmpty ? Color.AccentColor.opacity(0.2) : Color.AccentColor.opacity(0.35),
//                        lineWidth: 1
//                    )
//            )
//        }
//    }
//
//    // MARK: - Linked Toggle
//    private var linkedToggle: some View {
//        HStack(spacing: 16) {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("LINK TO ACCOUNT")
//                    .font(.system(size: 11, weight: .bold, design: .monospaced))
//                    .foregroundColor(.AccentColor)
//                    .kerning(1)
//                Text("Connect to their TripMate account")
//                    .font(.system(size: 11, design: .monospaced))
//                    .foregroundColor(.AccentColor.opacity(0.45))
//            }
//            Spacer()
//            Toggle("", isOn: $vm.isLinked)
//                .tint(Color.AccentColor)
//                .labelsHidden()
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 14)
//        .background(Color.AccentColor.opacity(0.08))
//        .cornerRadius(14)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1)
//        )
//    }
//
//    // MARK: - Add Button
//    private var addButton: some View {
//        Button {
//            guard let friend = vm.buildFriend() else { return }
//            onAdd(friend)
//            dismiss()
//        } label: {
//            Text("🚗 ADD TO TRIP")
//                .font(.system(size: 18, weight: .heavy, design: .rounded))
//                .kerning(2)
//                .foregroundColor(vm.canAdd ? Color.AccentColor : Color.AccentColor.opacity(0.2))
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 18)
//                .background(addButtonBG)
//                .cornerRadius(16)
//                .shadow(
//                    color: vm.canAdd ? Color.AccentColor.opacity(0.35) : Color.clear,
//                    radius: 14, y: 4
//                )
//        }
//        .disabled(!vm.canAdd)
//    }
//
//    @ViewBuilder
//    private var addButtonBG: some View {
//        if vm.canAdd {
//            LinearGradient(
//                colors: [Color.ContainerColor, Color.ContainerColor.opacity(0.75)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        } else {
//            Color.AccentColor.opacity(0.05)
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    AddFriendSheet { _ in }
//}
struct AddFriendsView: View {
 
    @ObservedObject var vm: AddFriendsViewModel
    @State private var showAddSheet = false
 
    var body: some View {
        VStack(spacing: 12) {
            addButton
            if vm.friends.isEmpty {
                emptyState
            } else {
                friendsList
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddFriendSheet { newFriend in
                withAnimation { vm.addFriend(newFriend) }
            }
        }
        // Show error alert only in edit mode if CoreData save fails
        .alert("Save Error", isPresented: Binding(
            get: { vm.saveError != nil },
            set: { if !$0 { vm.saveError = nil } }
        )) {
            Button("OK", role: .cancel) { vm.saveError = nil }
        } message: {
            Text(vm.saveError ?? "")
        }
    }
 
    // MARK: - Add Button
    private var addButton: some View {
        Button { showAddSheet = true } label: {
            HStack(spacing: 8) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 18))
                Text("ADD MEMBER")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .kerning(2)
            }
            .foregroundColor(Color.AccentColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.AccentColor.opacity(0.05))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        Color.AccentColor.opacity(0.3),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                    )
            )
        }
    }
 
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 44))
                .foregroundColor(.AccentColor.opacity(0.4))
            Text("NO MEMBERS YET")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.AccentColor.opacity(0.4))
                .kerning(2)
            Text("Add friends to share this trip")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.AccentColor.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
 
    // MARK: - Friends List
    private var friendsList: some View {
        VStack(spacing: 10) {
            HStack {
                Text("\(vm.friends.count) MEMBER\(vm.friends.count == 1 ? "" : "S")")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .kerning(2)
                Spacer()
            }
            .padding(.horizontal, 4)
 
            ForEach(vm.friends) { friend in
                friendRow(friend)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
 
    // MARK: - Friend Row
    private func friendRow(_ friend: TripFriend) -> some View {
        HStack(spacing: 14) {
 
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.AccentColor.opacity(0.4), Color.AccentColor.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 42, height: 42)
                    .overlay(Circle().stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
                Text(friend.avatarInitials)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.AccentColor)
            }
 
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(.AccentColor)
                HStack(spacing: 6) {
                    Image(systemName: "phone")
                        .font(.system(size: 9))
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                    Text(friend.phone)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.AccentColor.opacity(0.35))
                }
            }
 
            Spacer()
 
            // Linked badge + Remove button
            VStack(spacing: 6) {
                if friend.isLinked { linkedBadge }
                removeButton(for: friend)
            }
        }
        .padding(14)
        .background(Color.BackgroundColor)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
        )
    }
 
    private var linkedBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "link.circle.fill").font(.system(size: 10))
            Text("LINKED")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .kerning(0.5)
        }
        .foregroundColor(.green)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.green.opacity(0.1))
        .cornerRadius(6)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.green.opacity(0.25), lineWidth: 1))
    }
 
    private func removeButton(for friend: TripFriend) -> some View {
        Button {
            withAnimation { vm.removeFriend(friend) }
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                .frame(width: 26, height: 26)
                .background(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.1))
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.2), lineWidth: 1)
                )
        }
    }
}
 
// MARK: - Add Friend Sheet
struct AddFriendSheet: View {
 
    var onAdd: (TripFriend) -> Void
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AddFriendSheetViewModel()
 
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                sheetHeader
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        nameField
                        phoneField
                        linkedToggle
                        Spacer(minLength: 8)
                        addButton
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 50)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
 
    // MARK: - Sheet Header
    private var sheetHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.AccentColor)
                        .frame(width: 7, height: 7)
                        .shadow(color: Color.AccentColor.opacity(0.5), radius: 3)
                    Text("ADD MEMBER")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                        .kerning(2)
                }
                Text("Who's joining ?")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.AccentColor)
            }
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.AccentColor.opacity(0.5))
                    .frame(width: 32, height: 32)
                    .background(Color.AccentColor.opacity(0.08))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
        .padding(.bottom, 8)
    }
 
    // MARK: - Name Field
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FULL NAME")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .kerning(2)
            HStack(spacing: 12) {
                Image(systemName: "person")
                    .foregroundColor(Color.AccentColor.opacity(0.6))
                    .font(.system(size: 15))
                TextField("e.g. Raj Patel", text: $vm.name)
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.AccentColor)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.AccentColor.opacity(0.08))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        vm.name.isEmpty ? Color.AccentColor.opacity(0.2) : Color.AccentColor.opacity(0.35),
                        lineWidth: 1
                    )
            )
        }
    }
 
    // MARK: - Phone Field
    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PHONE NUMBER")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .kerning(2)
            HStack(spacing: 12) {
                Image(systemName: "phone")
                    .foregroundColor(Color.AccentColor.opacity(0.6))
                    .font(.system(size: 15))
                TextField("+91 98765 43210", text: $vm.phone)
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.AccentColor)
                    .keyboardType(.phonePad)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.AccentColor.opacity(0.08))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        vm.phone.isEmpty ? Color.AccentColor.opacity(0.2) : Color.AccentColor.opacity(0.35),
                        lineWidth: 1
                    )
            )
        }
    }
 
    // MARK: - Linked Toggle
    private var linkedToggle: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("LINK TO ACCOUNT")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.AccentColor)
                    .kerning(1)
                Text("Connect to their TripMate account")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.AccentColor.opacity(0.45))
            }
            Spacer()
            Toggle("", isOn: $vm.isLinked)
                .tint(Color.AccentColor)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.AccentColor.opacity(0.08))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1)
        )
    }
 
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            guard let friend = vm.buildFriend() else { return }
            onAdd(friend)
            dismiss()
        } label: {
            Text("🚗 ADD TO TRIP")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .kerning(2)
                .foregroundColor(vm.canAdd ? Color.AccentColor : Color.AccentColor.opacity(0.2))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(addButtonBG)
                .cornerRadius(16)
                .shadow(
                    color: vm.canAdd ? Color.AccentColor.opacity(0.35) : Color.clear,
                    radius: 14, y: 4
                )
        }
        .disabled(!vm.canAdd)
    }
 
    @ViewBuilder
    private var addButtonBG: some View {
        if vm.canAdd {
            LinearGradient(
                colors: [Color.ContainerColor, Color.ContainerColor.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            Color.AccentColor.opacity(0.05)
        }
    }
}
 
// MARK: - Preview
#Preview {
    AddFriendSheet { _ in }
}
