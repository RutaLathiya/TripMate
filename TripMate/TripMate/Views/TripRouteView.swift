//
//  TripRouteView.swift
//  TripMate
//
//  Created by iMac on 31/03/26.
//

import SwiftUI
import MapKit
import CoreData

struct TripRouteView: View {

    let trip: TripEntity
    let stops: [TripStop]

    // MARK: - State
    @State private var routes: [MKRoute] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var selectedTransport: MKDirectionsTransportType = .automobile
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var totalDistance: Double = 0
    @State private var totalTime: TimeInterval = 0
    @State private var showOpenInMaps = false

    // MARK: - Computed
    private var startCoord: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: trip.startLatitude, longitude: trip.startLongitude)
    }

    private var endCoord: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: trip.endLatitude, longitude: trip.endLongitude)
    }

    private var allWaypoints: [CLLocationCoordinate2D] {
        var points = [startCoord]
        points += stops.map { $0.location.coordinate }
        points.append(endCoord)
        return points
    }

    private var distanceString: String {
        let km = totalDistance / 1000
        return String(format: "%.1f km", km)
    }

    private var etaString: String {
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes) min"
    }

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            // Map
            Map(position: $cameraPosition) {
                // ✅ Route polylines
                ForEach(0..<routes.count, id: \.self) { i in
                    MapPolyline(routes[i].polyline)
                        .stroke(Color.AccentColor, lineWidth: 4)
                }

                // ✅ Start marker
                Annotation("Start", coordinate: startCoord) {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 32, height: 32)
                        Image(systemName: "figure.walk")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                // ✅ Stop markers
                ForEach(0..<stops.count, id: \.self) { i in
                    Annotation("Stop \(i + 1)", coordinate: stops[i].location.coordinate) {
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 28, height: 28)
                            Text("\(i + 1)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }

                // ✅ End marker
                Annotation(trip.destination ?? "Destination", coordinate: endCoord) {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 32, height: 32)
                        Image(systemName: "mappin")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .ignoresSafeArea()

            // ✅ Bottom info card
            VStack(spacing: 0) {
                // Transport picker
                transportPicker
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // Route info
                if isLoading {
                    ProgressView()
                        .tint(Color.AccentColor)
                        .padding(.vertical, 20)
                } else if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(.red)
                        .padding()
                } else {
                    routeInfoCard
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                }

                // Open in Maps button
                Button {
                    openInAppleMaps()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "map.fill")
                            .font(.system(size: 16))
                        Text("OPEN IN APPLE MAPS")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .kerning(1)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 36)
            }
            .background(
                Color.BackgroundColor
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .ignoresSafeArea(edges: .bottom)
                    .shadow(color: .black.opacity(0.15), radius: 20, y: -5)
            )
        }
        .navigationTitle(trip.title ?? "Route")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { fetchRoutes() }
        .onChange(of: selectedTransport) { _ in fetchRoutes() }
    }

    // MARK: - Transport Picker
    private var transportPicker: some View {
        HStack(spacing: 10) {
            transportButton(icon: "car.fill", label: "DRIVE", type: .automobile)
            transportButton(icon: "figure.walk", label: "WALK", type: .walking)
        }
    }

    private func transportButton(icon: String, label: String,
                                  type: MKDirectionsTransportType) -> some View {
        let isSelected = selectedTransport == type
        return Button {
            selectedTransport = type
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14))
                Text(label).font(.system(size: 11, weight: .bold, design: .monospaced))
            }
            .foregroundColor(isSelected ? .white : Color.AccentColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color.AccentColor : Color.AccentColor.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1)
            )
        }
    }

    // MARK: - Route Info Card
    private var routeInfoCard: some View {
        HStack(spacing: 0) {
            // Distance
            VStack(spacing: 4) {
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 18))
                    .foregroundColor(Color.AccentColor)
                Text(distanceString)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                Text("Distance")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.5))
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 50)

            // ETA
            VStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color.AccentColor)
                Text(etaString)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                Text("ETA")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.5))
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 50)

            // Stops
            VStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color.AccentColor)
                Text("\(stops.count)")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                Text("Stops")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Color.ContainerColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1)
        )
    }

    // MARK: - Fetch Routes (with stops as waypoints)
    private func fetchRoutes() {
        isLoading = true
        errorMessage = nil
        routes = []
        totalDistance = 0
        totalTime = 0

        // Build segments: start → stop1 → stop2 → end
        var segments: [(CLLocationCoordinate2D, CLLocationCoordinate2D)] = []
        for i in 0..<allWaypoints.count - 1 {
            segments.append((allWaypoints[i], allWaypoints[i + 1]))
        }

        let group = DispatchGroup()
        var fetchedRoutes: [MKRoute] = []

        for (from, to) in segments {
            group.enter()
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
            request.transportType = selectedTransport

            MKDirections(request: request).calculate { response, error in
                if let route = response?.routes.first {
                    fetchedRoutes.append(route)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.routes = fetchedRoutes
            self.totalDistance = fetchedRoutes.reduce(0) { $0 + $1.distance }
            self.totalTime = fetchedRoutes.reduce(0) { $0 + $1.expectedTravelTime }
            self.isLoading = false

            // ✅ Fit map to show full route
            if !fetchedRoutes.isEmpty {
                let rect = fetchedRoutes.reduce(MKMapRect.null) {
                    $0.union($1.polyline.boundingMapRect)
                }
                withAnimation {
                    self.cameraPosition = .rect(rect.insetBy(dx: -5000, dy: -5000))
                }
            } else {
                self.errorMessage = "Could not calculate route."
            }
        }
    }

    // MARK: - Open in Apple Maps with all stops
    private func openInAppleMaps() {
        var mapItems: [MKMapItem] = []

        // Add all waypoints
        for coord in allWaypoints {
            let placemark = MKPlacemark(coordinate: coord)
            mapItems.append(MKMapItem(placemark: placemark))
        }

        let options: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey:
                selectedTransport == .walking
                ? MKLaunchOptionsDirectionsModeWalking
                : MKLaunchOptionsDirectionsModeDriving
        ]

        MKMapItem.openMaps(with: mapItems, launchOptions: options)
    }
}

#Preview {
    let context = PersistenceController.shared.context
    let trip = TripEntity(context: context)
    trip.title = "Shimla Trip"
    trip.startLatitude = 28.613
    trip.startLongitude = 77.209
    trip.endLatitude = 31.104
    trip.endLongitude = 77.173
    trip.destination = "Shimla"
    return NavigationStack {
        TripRouteView(trip: trip, stops: [])
    }
}
