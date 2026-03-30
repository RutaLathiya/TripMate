//
//  EditTripView.swift
//  TripMate
//
//  Created by iMac on 30/03/26.
//

import SwiftUI
import MapKit
import CoreData
import Combine

struct EditTripView: View {

    // MARK: - Input
    @ObservedObject var trip: TripEntity

    // MARK: - Environment
    @EnvironmentObject var SessionVM: SessionViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - ViewModels
    @StateObject private var tripVM      = TripViewModel()
    @StateObject private var friendsVM   = AddFriendsViewModel()
    @StateObject private var weatherService = WeatherService()

    // MARK: - State (pre-filled from trip)
    @State private var tripName: String
    @State private var startLocation: TripModelsView?
    @State private var endLocation: TripModelsView?
    @State private var stops: [TripStop] = []
    @State private var packItems: [PackItem] = []
    @State private var newPackItem = ""
    @State private var activeSection: TripSection = .route
    @State private var activeModal: String? = nil
    @FocusState private var packFieldFocused: Bool

    // MARK: - Init — pre-fill from existing trip
    init(trip: TripEntity) {
        self.trip = trip
        _tripName = State(initialValue: trip.title ?? "")
        _startLocation = State(initialValue:
            trip.startLatitude != 0 ? TripModelsView(
                name: "Start Location",
                coordinate: CLLocationCoordinate2D(
                    latitude: trip.startLatitude,
                    longitude: trip.startLongitude
                )
            ) : nil
        )
        _endLocation = State(initialValue:
            trip.endLatitude != 0 ? TripModelsView(
                name: trip.destination ?? "Destination",
                coordinate: CLLocationCoordinate2D(
                    latitude: trip.endLatitude,
                    longitude: trip.endLongitude
                )
            ) : nil
        )
    }

    // MARK: - Computed
    private var canSave: Bool {
        !tripName.trimmingCharacters(in: .whitespaces).isEmpty
            && startLocation != nil
            && endLocation != nil
    }

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    tabRow.padding(.horizontal, 20).padding(.bottom, 22)
                    sectionContent
                    Spacer(minLength: 200)
                }
            }

            saveButtonBar
        }
        .overlay { modalOverlay }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: activeModal)
        .animation(.easeInOut(duration: 0.25), value: activeSection)
        .navigationTitle("Edit Trip")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadExistingMembers() }

        .alert("Trip Updated! ✅", isPresented: $tripVM.isSaved) {
            Button("OK", role: .cancel) {
                tripVM.isSaved = false
                dismiss()
            }
        } message: { Text("'\(tripName)' has been updated!") }

        .alert("Error", isPresented: Binding(
            get: { tripVM.errorMessage != nil },
            set: { if !$0 { DispatchQueue.main.async { tripVM.errorMessage = nil } } }
        )) {
            Button("OK", role: .cancel) { tripVM.errorMessage = nil }
        } message: { Text(tripVM.errorMessage ?? "") }
    }

    // MARK: - Load Existing Members
    private func loadExistingMembers() {
        let memberRepo = TripMemberRepository()
        if let members = try? memberRepo.fetchMembers(for: trip.objectID) {
            friendsVM.friends = members.map {
                TripFriend(
                    name: $0.memberName ?? "",
                    phone: $0.phoneNo ?? "",
                    isLinked: $0.user != nil
                )
            }
        }
    }

    // MARK: - Modals
    @ViewBuilder
    private var modalOverlay: some View {
        if activeModal == "start" {
            MapPickerView(title: "Start Location") { loc in
                startLocation = loc; activeModal = nil
            } onClose: { activeModal = nil }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        if activeModal == "end" {
            MapPickerView(title: "Destination") { loc in
                endLocation = loc; activeModal = nil
            } onClose: { activeModal = nil }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        if activeModal == "stop" {
            MapPickerView(title: "Add Stop") { loc in
                stops.append(TripStop(location: loc, index: stops.count + 1))
                activeModal = nil
            } onClose: { activeModal = nil }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    // MARK: - Section Switcher
    @ViewBuilder
    private var sectionContent: some View {
        switch activeSection {
        case .route:  routeSection.padding(.horizontal, 20)
        case .stops:  stopsSection.padding(.horizontal, 20)
        case .pack:   packSection.padding(.horizontal, 20)
        case .friends: AddFriendsView(vm: friendsVM).padding(.horizontal, 20)
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.AccentColor)
                        .frame(width: 8, height: 8)
                        .shadow(color: Color.AccentColor.opacity(0.4), radius: 4)
                    Text("EDIT TRIP")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                        .kerning(2)
                }
                Spacer()
            }
            VStack(alignment: .leading, spacing: 0) {
                TextField("TRIP NAME...", text: $tripName)
                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.AccentColor)
                    .kerning(1.5)
                    .autocorrectionDisabled()
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color.AccentColor.opacity(0.2)).frame(height: 2)
                        let progress = tripName.isEmpty ? 0.0 : min(CGFloat(tripName.count) / 20.0, 1.0)
                        Rectangle()
                            .fill(Color.AccentColor)
                            .frame(width: geo.size.width * progress, height: 2)
                            .animation(.spring(response: 0.4), value: tripName.count)
                    }
                }
                .frame(height: 2).padding(.top, 6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 26)
    }

    // MARK: - Tab Row
    private var tabRow: some View {
        HStack(spacing: 6) {
            ForEach(TripSection.allCases, id: \.self) { tab in
                tabButton(tab)
            }
        }
    }

    private func tabButton(_ tab: TripSection) -> some View {
        let isActive = activeSection == tab
        return Button {
            withAnimation { activeSection = tab }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: tab.icon).font(.system(size: 14))
                Text(tab.rawValue)
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .kerning(0.5).lineLimit(1).minimumScaleFactor(0.7)
            }
            .foregroundColor(Color.AccentColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isActive ? Color.AccentColor.opacity(0.25) : Color.AccentColor.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isActive ? Color.AccentColor.opacity(0.45) : Color.AccentColor.opacity(0.06), lineWidth: 2)
            )
        }
    }

    // MARK: - Route Section
    private var routeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            locationCard(label: "FROM", location: startLocation,
                         iconName: "circle.fill", iconColor: Color(red: 0.92, green: 0.75, blue: 0.15),
                         placeholder: "Set Starting Point") { activeModal = "start" }
            routeDivider
            locationCard(label: "TO", location: endLocation,
                         iconName: "circle.fill", iconColor: Color(red: 0.44, green: 0.56, blue: 0.40),
                         placeholder: "Set Destination") { activeModal = "end" }
            if startLocation != nil && endLocation != nil {
                routePreviewCard
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                    .padding(.bottom, 100)
            }
        }
        .padding(.top, 8)
    }

    private var routeDivider: some View {
        HStack(spacing: 12) {
            VStack(spacing: 3) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.AccentColor.opacity(0.3))
                        .frame(width: 2.5, height: 6)
                }
            }
            .padding(.leading, 18)
            Text("YOUR JOURNEY")
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundColor(Color.AccentColor).kerning(2).padding(.leading, 12)
        }
    }

    private func locationCard(label: String, location: TripModelsView?,
                               iconName: String, iconColor: Color,
                               placeholder: String, action: @escaping () -> Void) -> some View {
        let hasLoc = location != nil
        return VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor).kerning(3)
            Button { action() } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(hasLoc ? iconColor.opacity(0.15) : Color.clear)
                            .frame(width: 42, height: 42)
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(hasLoc ? iconColor.opacity(0.3) : Color.clear, lineWidth: 1))
                        Image(systemName: iconName).font(.system(size: 14))
                            .foregroundColor(hasLoc ? iconColor : Color.AccentColor)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(location?.name ?? placeholder)
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .foregroundColor(hasLoc ? .AccentColor : Color.AccentColor.opacity(0.5))
                        if let loc = location {
                            Text(String(format: "%.4f, %.4f", loc.coordinate.latitude, loc.coordinate.longitude))
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.6))
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(Color.AccentColor).font(.system(size: 14))
                }
                .padding(16).background(Color.BackgroundColor).cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(hasLoc ? Color.AccentColor.opacity(0.65) : Color.AccentColor.opacity(0.4), lineWidth: 2))
            }
        }
    }

    private var routePreviewCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("ROUTE PREVIEW")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor).kerning(2)
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                ZStack {
                    RoutePreviewShape()
                        .stroke(
                            LinearGradient(
                                colors: [Color(red: 0.92, green: 0.75, blue: 0.08),
                                         Color(red: 0.44, green: 0.56, blue: 0.40)],
                                startPoint: .leading, endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2.5, dash: [7, 4])
                        )
                    Circle().fill(Color(red: 0.92, green: 0.75, blue: 0.08))
                        .frame(width: 10, height: 10).position(x: w * 0.05, y: h * 0.7)
                    Circle().fill(Color(red: 0.44, green: 0.56, blue: 0.40))
                        .frame(width: 10, height: 10).position(x: w * 0.95, y: h * 0.2)
                }
            }
            .frame(height: 60)
            HStack {
                Text(startLocation?.name.components(separatedBy: ",").first ?? "")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color(red: 0.92, green: 0.75, blue: 0.08))
                Spacer()
                Text(endLocation?.name.components(separatedBy: ",").first ?? "")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color(red: 0.44, green: 0.56, blue: 0.40))
            }
        }
        .padding(16)
        .background(LinearGradient(colors: [Color.AccentColor.opacity(0.1), Color.AccentColor.opacity(0.4)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.AccentColor.opacity(0.5), lineWidth: 1))
    }

    // MARK: - Stops Section
    private var stopsSection: some View {
        VStack(spacing: 12) {
            Button { activeModal = "stop" } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle").font(.system(size: 18))
                    Text("ADD NEW STOP")
                        .font(.system(size: 12, weight: .bold, design: .monospaced)).kerning(2)
                }
                .foregroundColor(Color.AccentColor).frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(Color.AccentColor.opacity(0.05)).cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.AccentColor.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])))
            }
            if stops.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "mappin.slash").font(.system(size: 44))
                        .foregroundColor(.AccentColor.opacity(0.5))
                    Text("NO STOPS YET").font(.system(size: 12, design: .monospaced))
                        .foregroundColor(.AccentColor.opacity(0.5)).kerning(2)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 48)
            } else {
                ForEach(Array(stops.enumerated()), id: \.element.id) { idx, stop in
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).fill(Color.AccentColor.opacity(0.15))
                                .frame(width: 34, height: 34)
                            Text("\(idx + 1)")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text(stop.location.name.components(separatedBy: ",").first ?? stop.location.name)
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundColor(.AccentColor)
                            Text(String(format: "%.3f, %.3f",
                                        stop.location.coordinate.latitude, stop.location.coordinate.longitude))
                                .font(.system(size: 10, design: .monospaced)).foregroundColor(.AccentColor.opacity(0.5))
                        }
                        Spacer()
                        Button { withAnimation { stops.removeAll { $0.id == stop.id } } } label: {
                            Image(systemName: "xmark").font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                                .frame(width: 30, height: 30)
                                .background(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(14).background(Color.BackgroundColor).cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    // MARK: - Pack Section
    private var packSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                TextField("Add item to pack...", text: $newPackItem)
                    .font(.system(size: 13, design: .monospaced)).foregroundColor(.AccentColor)
                    .focused($packFieldFocused).submitLabel(.done).onSubmit { addPackItem() }
                    .autocorrectionDisabled()
                Button { addPackItem() } label: {
                    Text("ADD").font(.system(size: 11, weight: .bold, design: .monospaced)).kerning(1)
                        .foregroundColor(Color.AccentColor).padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color.AccentColor.opacity(0.15)).cornerRadius(10)
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(Color.BackgroundColor.opacity(0.3)).cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.AccentColor.opacity(0.7), lineWidth: 1))

            ForEach(packItems) { item in
                HStack(spacing: 14) {
                    Button {
                        withAnimation {
                            if let idx = packItems.firstIndex(where: { $0.id == item.id }) {
                                packItems[idx].isChecked.toggle()
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(item.isChecked ? Color.AccentColor : Color.clear)
                                .frame(width: 24, height: 24)
                                .overlay(RoundedRectangle(cornerRadius: 7)
                                    .stroke(item.isChecked ? Color.AccentColor : Color.AccentColor.opacity(0.2), lineWidth: 1.5))
                            if item.isChecked {
                                Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.black)
                            }
                        }
                    }
                    Text(item.text).font(.system(size: 13, design: .monospaced))
                        .foregroundColor(item.isChecked ? Color.AccentColor : Color.AccentColor.opacity(0.8))
                        .strikethrough(item.isChecked, color: Color.AccentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button { withAnimation { packItems.removeAll { $0.id == item.id } } } label: {
                        Image(systemName: "xmark").font(.system(size: 11)).foregroundColor(.AccentColor.opacity(0.2))
                    }
                }
                .padding(.horizontal, 14).padding(.vertical, 12)
                .background(item.isChecked ? Color.AccentColor.opacity(0.05) : Color.BackgroundColor.opacity(0.5))
                .cornerRadius(12)
            }
        }
    }

    // MARK: - Save Button
    private var saveButtonBar: some View {
        Button {
            guard canSave else { return }
            guard let objID = SessionVM.currentUserObjectID else {
                tripVM.errorMessage = "Session expired. Please log in again."
                return
            }
            Task {
                await tripVM.updateTrip(
                    trip,
                    title: tripName,
                    destination: endLocation?.name ?? "",
                    startLat: startLocation?.coordinate.latitude  ?? 0,
                    startLng: startLocation?.coordinate.longitude ?? 0,
                    endLat:   endLocation?.coordinate.latitude    ?? 0,
                    endLng:   endLocation?.coordinate.longitude   ?? 0,
                    friends:  friendsVM.friends,
                    userObjectID: objID
                )
            }
        } label: {
            Text(canSave ? "💾  SAVE CHANGES" : "FILL ALL FIELDS TO SAVE")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .kerning(2)
                .foregroundColor(canSave ? Color.AccentColor : Color.AccentColor.opacity(0.3))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 19)
                .background(ZStack {
                    Color.white.opacity(0.1)
                    Color.BackgroundColor.opacity(0.5)
                })
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.6), lineWidth: 1.5))
                .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!canSave)
        .padding(.horizontal, 20)
        .padding(.bottom, 36)
    }

    // MARK: - Helpers
    private func addPackItem() {
        let trimmed = newPackItem.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation { packItems.append(PackItem(text: trimmed)) }
        newPackItem = ""
    }
}

#Preview {
    let context = PersistenceController.shared.context
    let trip = TripEntity(context: context)
    trip.title = "Shimla Trip"
    trip.destination = "Shimla, India"
    return NavigationStack {
        EditTripView(trip: trip)
            .environmentObject(SessionViewModel())
    }
}
