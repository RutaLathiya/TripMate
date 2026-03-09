//
//  CreateTripView.swift
//  TripMate
//
//  Created by iMac on 10/02/26.
//


import SwiftUI
import MapKit

// MARK: - Models

struct TripLocation: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D

    static func == (lhs: TripLocation, rhs: TripLocation) -> Bool {
        lhs.id == rhs.id
    }
}

struct TripStop: Identifiable {
    let id = UUID()
    var location: TripLocation
    var index: Int
}

struct PackItem: Identifiable {
    let id = UUID()
    var text: String
    var isChecked: Bool = false
}

// MARK: - Color Theme

//extension Color {
//    static let tripOrange      = Color(red: 1.0,  green: 0.549, blue: 0.0)
//    static let tripOrangeDark  = Color(red: 0.9,  green: 0.42,  blue: 0.0)
//    static let tripBG          = Color(red: 0.035, green: 0.059, blue: 0.082)
//    static let tripCard        = Color(red: 0.08,  green: 0.13,  blue: 0.18)
//    static let tripCardBorder  = Color(red: 0.12,  green: 0.19,  blue: 0.26)
//    static let tripDim         = Color(red: 0.2,   green: 0.2,   blue: 0.2)
//}

// MARK: - Map Picker Modal

struct MapPickerModal: View {
    let title: String
    var onSelect: (TripLocation) -> Void
    var onClose: () -> Void

    @State private var searchText  = ""
    @State private var selected: TripLocation? = nil
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 22.3, longitude: 73.0),
            span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
        )
    )

    let suggestions: [TripLocation] = [
        TripLocation(name: "Mumbai, Maharashtra",  coordinate: .init(latitude: 19.076, longitude: 72.877)),
        TripLocation(name: "Delhi, India",          coordinate: .init(latitude: 28.613, longitude: 77.209)),
        TripLocation(name: "Surat, Gujarat",        coordinate: .init(latitude: 21.170, longitude: 72.831)),
        TripLocation(name: "Ahmedabad, Gujarat",    coordinate: .init(latitude: 23.022, longitude: 72.571)),
        TripLocation(name: "Vadodara, Gujarat",     coordinate: .init(latitude: 22.307, longitude: 73.181)),
        TripLocation(name: "Rajkot, Gujarat",       coordinate: .init(latitude: 22.303, longitude: 70.802)),
        TripLocation(name: "Pune, Maharashtra",     coordinate: .init(latitude: 18.520, longitude: 73.856)),
        TripLocation(name: "Jaipur, Rajasthan",     coordinate: .init(latitude: 26.912, longitude: 75.787)),
    ]

    var filtered: [TripLocation] {
        searchText.isEmpty ? suggestions : suggestions.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color.BackgroundColor
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 0) {
                    // Handle
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 40, height: 5)
                        .padding(.top, 14)
                        .padding(.bottom, 20)

                    // Map Preview
                    ZStack(alignment: .topLeading) {
                        Map(position: $cameraPosition) {
                            if let loc = selected {
                                Marker(loc.name, coordinate: loc.coordinate)
                                    .tint(Color.accentColor)
                            }
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.accentColor.opacity(0.25), lineWidth: 1)
                        )

                        Text(title.uppercased())
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.BackgroundColor.opacity(0.9))
                            .cornerRadius(8)
                            .padding(12)

                        if selected == nil {
                            Text("TAP A LOCATION BELOW")
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.25))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(height: 200)
                    .padding(.horizontal, 20)

                    // Search Bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.AccentColor)
                            .font(.system(size: 15))
                        TextField("Search city or place...", text: $searchText)
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(.white)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.BackgroundColor)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Suggestions List
                    ScrollView {
                        VStack(spacing: 6) {
                            ForEach(filtered) { loc in
                                Button {
                                    selected = loc
                                    withAnimation {
                                        cameraPosition = .region(MKCoordinateRegion(
                                            center: loc.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
                                        ))
                                    }
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(selected?.id == loc.id ? .tripOrange : .tripDim)
                                            .font(.system(size: 18))

                                        Text(loc.name)
                                            .font(.system(size: 13, design: .monospaced))
                                            .foregroundColor(selected?.id == loc.id ? .tripOrange : Color.white.opacity(0.6))

                                        Spacer()

                                        if selected?.id == loc.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.tripOrange)
                                                .font(.system(size: 12, weight: .bold))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 11)
                                    .background(
                                        selected?.id == loc.id
                                            ? Color.tripOrange.opacity(0.1)
                                            : Color.clear
                                    )
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                selected?.id == loc.id
                                                    ? Color.tripOrange.opacity(0.35)
                                                    : Color.clear,
                                                lineWidth: 1
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .frame(maxHeight: 200)

                    // Action Buttons
                    HStack(spacing: 12) {
                        Button("CANCEL") { onClose() }
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.tripCard)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )

                        Button("CONFIRM LOCATION") {
                            if let s = selected { onSelect(s) }
                        }
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(selected != nil ? .black : Color.white.opacity(0.2))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            selected != nil
                                ? LinearGradient(colors: [.tripOrange, .tripOrangeDark],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing)
                                : LinearGradient(colors: [Color.tripOrange.opacity(0.15),
                                                           Color.tripOrange.opacity(0.15)],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(14)
                        .disabled(selected == nil)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 36)
                }
                .background(
                    Color(red: 0.059, green: 0.098, blue: 0.137)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Route Preview Shape

struct RoutePreviewShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.05, y: h * 0.7))
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.3),
            control1: CGPoint(x: w * 0.2, y: h * 0.1),
            control2: CGPoint(x: w * 0.35, y: h * 0.55)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.95, y: h * 0.2),
            control1: CGPoint(x: w * 0.65, y: h * 0.05),
            control2: CGPoint(x: w * 0.8, y: h * 0.4)
        )
        return path
    }
}

// MARK: - Section Tab Enum

enum TripSection: String, CaseIterable {
    case route    = "ROUTE"
    case stops    = "STOPS"
    case pack     = "PACK LIST"

    var icon: String {
        switch self {
        case .route:  return "map"
        case .stops:  return "mappin"
        case .pack:   return "bag"
        }
    }
}

// MARK: - Main Create Trip View

struct CreateTripView: View {

    @State private var tripName       = ""
    @State private var startLocation: TripLocation? = nil
    @State private var endLocation:   TripLocation? = nil
    @State private var stops:         [TripStop]    = []
    @State private var packItems:     [PackItem]    = [
        PackItem(text: "Passport / ID"),
        PackItem(text: "Charger & Power Bank"),
        PackItem(text: "First Aid Kit"),
    ]
    @State private var newPackItem    = ""
    @State private var activeSection: TripSection = .route
    @State private var activeModal:   String?      = nil   // "start" | "end" | "stop"
    @State private var tripStarted    = false
    @FocusState private var packFieldFocused: Bool

    var canStart: Bool {
        !tripName.trimmingCharacters(in: .whitespaces).isEmpty
            && startLocation != nil
            && endLocation != nil
    }

    var startButtonLabel: String {
        if tripStarted             { return "🚗  TRIP IN PROGRESS" }
        if canStart                { return "🚀  START TRIP" }
        if tripName.trimmingCharacters(in: .whitespaces).isEmpty { return "ENTER TRIP NAME TO BEGIN" }
        if startLocation == nil    { return "SET START LOCATION TO CONTINUE" }
        return "SET DESTINATION TO CONTINUE"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.BackgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Header ──────────────────────────────────────────
                    headerSection

                    // ── Tabs ────────────────────────────────────────────
                    tabRow
                        .padding(.horizontal, 20)
                        .padding(.bottom, 22)

                    // ── Content ─────────────────────────────────────────
                    Group {
                        switch activeSection {
                        case .route: routeSection
                        case .stops: stopsSection
                        case .pack:  packSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))

                    Spacer(minLength: 130)
                }
            }

            // ── Start Button ─────────────────────────────────────────────
            startButton
        }
        .overlay {
            if activeModal == "start" {
                MapPickerModal(title: "Start Location") { loc in
                    startLocation = loc
                    activeModal = nil
                } onClose: { activeModal = nil }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            if activeModal == "end" {
                MapPickerModal(title: "Destination") { loc in
                    endLocation = loc
                    activeModal = nil
                } onClose: { activeModal = nil }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            if activeModal == "stop" {
                MapPickerModal(title: "Add Stop") { loc in
                    let s = TripStop(location: loc, index: stops.count + 1)
                    stops.append(s)
                    activeModal = nil
                } onClose: { activeModal = nil }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: activeModal)
        .animation(.easeInOut(duration: 0.25), value: activeSection)
    }

    // MARK: Header

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 8, height: 8)
                        .shadow(color: .accentColor, radius: 4)
                    Text("NEW TRIP")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.accentColor)
                        .kerning(3)
                }
                Spacer()
                Text("WANDERLOG")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.15))
                    .kerning(2)
            }

            VStack(alignment: .leading, spacing: 0) {
                TextField("NAME YOUR ADVENTURE...", text: $tripName)
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .kerning(1.5)
                    .autocorrectionDisabled()

                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.AccentColor.opacity(0.2))
                        .frame(height: 2)
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.AccentColor)
                            .frame(
                                width: tripName.isEmpty ? 0
                                    : CGFloat(min(tripName.count, 20)) / 20.0 * geo.size.width,
                                height: 2
                            )
                            .animation(.spring(response: 0.4), value: tripName.count)
                    }
                    .frame(height: 2)
                }
                .padding(.top, 6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 26)
    }

    // MARK: Tab Row

    var tabRow: some View {
        HStack(spacing: 8) {
            ForEach(TripSection.allCases, id: \.self) { tab in
                Button {
                    withAnimation { activeSection = tab }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 15))
                        Text(tab.rawValue)
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .kerning(0.8)
                    }
                    .foregroundColor(activeSection == tab ? .tripOrange : .tripDim)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        activeSection == tab
                            ? Color.tripOrange.opacity(0.1)
                            : Color.tripCard
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                activeSection == tab
                                    ? Color.tripOrange.opacity(0.45)
                                    : Color.white.opacity(0.06),
                                lineWidth: 1
                            )
                    )
                }
            }
        }
    }

    // MARK: Route Section

    var routeSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            // FROM
            locationCard(
                label: "FROM",
                location: startLocation,
                icon: "circle.fill",
                iconColor: .green,
                placeholder: "Set Starting Point",
                action: { activeModal = "start" }
            )

            // Dash line
            HStack(spacing: 0) {
                VStack(spacing: 3) {
                    ForEach(0..<4, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.accentColor.opacity(0.3))
                            .frame(width: 2, height: 6)
                    }
                }
                .padding(.leading, 18)
                Text("YOUR JOURNEY")
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.15))
                    .kerning(2)
                    .padding(.leading, 12)
            }

            // TO
            locationCard(
                label: "TO",
                location: endLocation,
                icon: "circle.fill",
                iconColor: .red,
                placeholder: "Set Destination",
                action: { activeModal = "end" }
            )

            // Route preview card
            if startLocation != nil && endLocation != nil {
                routePreviewCard
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }

    func locationCard(label: String, location: TripLocation?, icon: String, iconColor: Color, placeholder: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .kerning(3)

            Button(action: action) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(location != nil ? iconColor.opacity(0.15) : Color.tripCard)
                            .frame(width: 42, height: 42)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(location != nil ? iconColor.opacity(0.3) : Color.clear, lineWidth: 1)
                            )
                        Image(systemName: icon)
                            .font(.system(size: 14))
                            .foregroundColor(location != nil ? iconColor : .tripDim)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(location?.name ?? placeholder)
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .foregroundColor(location != nil ? .white : Color.white.opacity(0.2))
                        if let loc = location {
                            Text(String(format: "%.4f, %.4f", loc.coordinate.latitude, loc.coordinate.longitude))
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.tripOrange.opacity(0.6))
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.tripDim)
                        .font(.system(size: 14))
                }
                .padding(16)
                .background(Color.tripCard)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            location != nil
                                ? Color.tripOrange.opacity(0.35)
                                : Color.white.opacity(0.07),
                            lineWidth: 1
                        )
                )
            }
        }
    }

    var routePreviewCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("ROUTE PREVIEW")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .kerning(3)

            ZStack {
                // Grid lines
                VStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { _ in
                        Spacer()
                        Rectangle().fill(Color.white.opacity(0.03)).frame(height: 1)
                    }
                }
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { _ in
                        Spacer()
                        Rectangle().fill(Color.white.opacity(0.03)).frame(width: 1)
                    }
                }

                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height

                    // Route path
                    RoutePreviewShape()
                        .stroke(
                            LinearGradient(
                                colors: [.green, .orange, .red],
                                startPoint: .leading, endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2.5, dash: [7, 4])
                        )

                    // Start dot
                    Circle().fill(Color.green)
                        .frame(width: 10, height: 10)
                        .shadow(color: .green, radius: 4)
                        .position(x: w * 0.05, y: h * 0.7)

                    // End dot
                    Circle().fill(Color.red)
                        .frame(width: 10, height: 10)
                        .shadow(color: .red, radius: 4)
                        .position(x: w * 0.95, y: h * 0.2)

                    // Stop dots
                    ForEach(0..<stops.count, id: \.self) { i in
                        Circle().fill(Color.tripOrange)
                            .frame(width: 8, height: 8)
                            .shadow(color: .tripOrange, radius: 3)
                            .position(
                                x: w * (0.25 + Double(i) * 0.2),
                                y: h * (0.45 + (i % 2 == 0 ? 0.15 : -0.1))
                            )
                    }
                }
                .frame(height: 80)
            }
            .frame(height: 80)
            .clipped()

            HStack {
                Label(startLocation?.name.components(separatedBy: ",").first ?? "", systemImage: "")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.green)
                Spacer()
                Text("\(stops.count) STOP\(stops.count == 1 ? "" : "S")")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.tripOrange)
                Spacer()
                Text(endLocation?.name.components(separatedBy: ",").first ?? "")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.red)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color(red: 0.065, green: 0.125, blue: 0.188), Color(red: 0.04, green: 0.1, blue: 0.157)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.tripOrange.opacity(0.15), lineWidth: 1)
        )
    }

    // MARK: Stops Section

    var stopsSection: some View {
        VStack(spacing: 12) {
            // Add Stop Button
            Button {
                activeModal = "stop"
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 18))
                    Text("ADD NEW STOP")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .kerning(2)
                }
                .foregroundColor(Color.AccentColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.BackgroundColor.opacity(0.05))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.AccentColor.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                )
            }

            if stops.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "mappin.slash")
                        .font(.system(size: 44))
                        .foregroundColor(.white.opacity(0.1))
                    Text("NO STOPS YET")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(.white.opacity(0.2))
                        .kerning(2)
                    Text("Add waypoints along your route")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.1))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 48)
            } else {
                ForEach(Array(stops.enumerated()), id: \.element.id) { idx, stop in
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.BackgroundColor.opacity(0.15))
                                .frame(width: 34, height: 34)
                            Text("\(idx + 1)")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(stop.location.name.components(separatedBy: ",").first ?? stop.location.name)
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white)
                            Text(String(format: "%.3f, %.3f",
                                        stop.location.coordinate.latitude,
                                        stop.location.coordinate.longitude))
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.white.opacity(0.3))
                        }

                        Spacer()

                        Button {
                            withAnimation { stops.removeAll { $0.id == stop.id } }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                                .frame(width: 30, height: 30)
                                .background(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding(14)
                    .background(Color.BackgroundColor)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.BackgroundColor.opacity(0.15), lineWidth: 1)
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    // MARK: Pack Section

    var packSection: some View {
        VStack(spacing: 14) {

            // Add item input
            HStack(spacing: 10) {
                TextField("Add item to pack...", text: $newPackItem)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(.white)
                    .focused($packFieldFocused)
                    .submitLabel(.done)
                    .onSubmit { addPackItem() }

                Button("ADD") { addPackItem() }
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .kerning(1)
                    .foregroundColor(Color.ContainerColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.BackgroundColor.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.BackgroundColor.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.BackgroundColor)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )

            // Progress bar
            let checkedCount = packItems.filter(\.isChecked).count
            VStack(spacing: 8) {
                HStack {
                    Text("PACKED")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                        .kerning(2)
                    Spacer()
                    Text("\(checkedCount)/\(packItems.count)")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.05))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(colors: [Color.AccentColor, Color.AccentColor.opacity(0.5)],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(
                                width: packItems.isEmpty ? 0
                                    : geo.size.width * CGFloat(checkedCount) / CGFloat(packItems.count),
                                height: 4
                            )
                            .animation(.spring(response: 0.4), value: checkedCount)
                    }
                }
                .frame(height: 4)
            }

            // Items
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
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(
                                            item.isChecked ? Color.AccentColor : Color.white.opacity(0.2),
                                            lineWidth: 1.5
                                        )
                                )
                            if item.isChecked {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .animation(.spring(response: 0.25), value: item.isChecked)
                    }

                    Text(item.text)
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(item.isChecked ? Color.AccentColor.opacity(0.5) : Color.white.opacity(0.8))
                        .strikethrough(item.isChecked, color: Color.AccentColor.opacity(0.5))
                        .animation(.easeInOut(duration: 0.2), value: item.isChecked)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        withAnimation {
                            packItems.removeAll { $0.id == item.id }
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.2))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    item.isChecked
                        ? Color.AccentColor.opacity(0.05)
                        : Color.AccentColor.opacity(0.5)
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
    }

    // MARK: Start Button

    var startButton: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [Color.BackgroundColor.opacity(0), Color.BackgroundColor],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 40)

            Button {
                guard canStart else { return }
                withAnimation { tripStarted = true }
            } label: {
                Text(startButtonLabel)
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .kerning(2)
                    .foregroundColor(canStart ? .black : Color.white.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 19)
                    .background(
                        Group {
                            if canStart {
                                LinearGradient(
                                    colors: [Color.ContainerColor, Color.ContainerColor.opacity(0.5)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            } else {
                                LinearGradient(
                                    colors: [Color.white.opacity(0.05), Color.white.opacity(0.05)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            }
                        }
                    )
                    .cornerRadius(18)
                    .shadow(color: canStart ? Color.AccentColor.opacity(0.4) : .clear, radius: 16, y: 4)
            }
            .disabled(!canStart)
            .padding(.horizontal, 20)
            .padding(.bottom, 36)
        }
        .background(Color.BackgroundColor)
    }

    // MARK: Helpers

    func addPackItem() {
        let trimmed = newPackItem.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation { packItems.append(PackItem(text: trimmed)) }
        newPackItem = ""
    }
}

// MARK: - Preview

#Preview {
    CreateTripView()
        //.preferredColorScheme(.dark)
}
