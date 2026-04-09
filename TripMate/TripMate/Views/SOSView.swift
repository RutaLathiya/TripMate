//
//  SOSView.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import SwiftUI
import MapKit

struct SOSView: View {
    let tripName: String

    @StateObject private var locationManager  = LocationManager()
    @StateObject private var placesService    = NearbyPlacesService()
    @State private var selectedCategory: SOSCategory? = nil
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var hasSearched = false
    @State private var selectedPlace: NearbyPlace? = nil

    private var filteredPlaces: [NearbyPlace] {
        guard let cat = selectedCategory else { return placesService.places }
        return placesService.places.filter { $0.category == cat }
    }

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── SOS Header ─────────────────────────────────
                    sosHeader

                    // ── Map ────────────────────────────────────────
                    mapSection

                    // ── Category Filter ────────────────────────────
                    categoryFilter

                    // ── Search Button ──────────────────────────────
                    if !hasSearched {
                        searchButton
                    }

                    // ── Places List ────────────────────────────────
                    if placesService.isLoading {
                        HStack(spacing: 10) {
                            ProgressView()
                                .tint(Color.AccentColor)
                            Text("FINDING NEARBY HELP...")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.6))
                                .kerning(1)
                        }
                        .padding(.vertical, 20)
                    } else if hasSearched {
                        placesList
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("SOS")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: locationManager.userLocation) { newLocation in
            if let loc = newLocation {
                withAnimation {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: loc,
                        latitudinalMeters: 5000,
                        longitudinalMeters: 5000
                    ))
                }
            }
        }
    }

    // MARK: - SOS Header
    private var sosHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay(Circle().stroke(Color.red.opacity(0.3), lineWidth: 1.5))
                Image(systemName: "sos.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("EMERGENCY ASSIST")
                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .kerning(1)
                Text("Find hospitals, garages, hotels & police nearby")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.5))
            }
            Spacer()
        }
        .padding(16)
        .background(Color.red.opacity(0.05))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.red.opacity(0.2), lineWidth: 1))
    }

    // MARK: - Map
    private var mapSection: some View {
        Map(position: $cameraPosition) {
            // User location
            if let loc = locationManager.userLocation {
                Annotation("You", coordinate: loc) {
                    ZStack {
                        Circle().fill(Color.blue.opacity(0.2))
                            .frame(width: 32, height: 32)
                        Circle().fill(Color.blue)
                            .frame(width: 14, height: 14)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
            }
            // Nearby places
            ForEach(filteredPlaces) { place in
                Annotation(place.name, coordinate: place.coordinate) {
                    Button {
                        selectedPlace = place
                    } label: {
                        ZStack {
                            Circle()
                                .fill(place.category.color.opacity(0.2))
                                .frame(width: 32, height: 32)
                            Image(systemName: place.category.icon)
                                .font(.system(size: 14))
                                .foregroundColor(place.category.color)
                        }
                    }
                }
            }
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All button
                Button {
                    withAnimation { selectedCategory = nil }
                } label: {
                    Text("ALL")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .kerning(1)
                        .foregroundColor(selectedCategory == nil ? .white : Color.AccentColor)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == nil
                            ? Color.AccentColor
                            : Color.AccentColor.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
                }

                ForEach(SOSCategory.allCases, id: \.self) { cat in
                    Button {
                        withAnimation { selectedCategory = cat }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.icon)
                                .font(.system(size: 11))
                            Text(cat.rawValue.uppercased())
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .kerning(0.5)
                        }
                        .foregroundColor(selectedCategory == cat ? .white : cat.color)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == cat
                            ? cat.color
                            : cat.color.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(cat.color.opacity(0.3), lineWidth: 1))
                    }
                }
            }
        }
    }

    // MARK: - Search Button
    private var searchButton: some View {
        Button {
            guard let loc = locationManager.userLocation else { return }
            let clLocation = CLLocation(
                latitude: loc.latitude,
                longitude: loc.longitude)
            placesService.searchAll(near: clLocation)
            hasSearched = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "location.magnifyingglass")
                    .font(.system(size: 18))
                Text("FIND NEARBY HELP")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .kerning(2)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                locationManager.userLocation != nil
                    ? Color.red.opacity(0.8)
                    : Color.AccentColor.opacity(0.2)
            )
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red.opacity(0.4), lineWidth: 1.5))
        }
        .disabled(locationManager.userLocation == nil)
    }

    // MARK: - Places List
    private var placesList: some View {
        VStack(spacing: 10) {
            if filteredPlaces.isEmpty {
                Text("No places found nearby")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.4))
                    .padding(.vertical, 20)
            } else {
                ForEach(filteredPlaces) { place in
                    placeRow(place)
                }
            }
        }
    }

    private func placeRow(_ place: NearbyPlace) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(place.category.color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: place.category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(place.category.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .lineLimit(1)
                Text(place.category.rawValue)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(place.category.color.opacity(0.8))
            }

            Spacer()

            // Open in Maps button
            Button {
                place.mapItem.openInMaps(launchOptions: [
                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                ])
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                    Text("GO")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(place.category.color)
                .cornerRadius(10)
            }
        }
        .padding(14)
        .background(Color.BackgroundColor)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(Color.AccentColor.opacity(0.1), lineWidth: 1))
    }
}
