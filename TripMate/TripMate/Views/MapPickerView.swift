//
//  MapPickerView.swift
//  TripMate
//
//  Created by iMac on 10/03/26.
//

// MapPickerModal.swift
// TripMate
// Bottom sheet modal for picking a location from map + search

import SwiftUI
import MapKit

struct MapPickerView: View {
    let title: String
    var onSelect: (TripModelsView) -> Void
    var onClose: () -> Void

    @State private var searchText = ""
    @State private var selected: TripModelsView? = nil
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 22.3, longitude: 73.0),
            span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
        )
    )

    private let suggestions: [TripModelsView] = [
        TripModelsView(name: "Mumbai, Maharashtra", coordinate: .init(latitude: 19.076, longitude: 72.877)),
        TripModelsView(name: "Delhi, India",         coordinate: .init(latitude: 28.613, longitude: 77.209)),
        TripModelsView(name: "Surat, Gujarat",       coordinate: .init(latitude: 21.170, longitude: 72.831)),
        TripModelsView(name: "Ahmedabad, Gujarat",   coordinate: .init(latitude: 23.022, longitude: 72.571)),
        TripModelsView(name: "Vadodara, Gujarat",    coordinate: .init(latitude: 22.307, longitude: 73.181)),
        TripModelsView(name: "Rajkot, Gujarat",      coordinate: .init(latitude: 22.303, longitude: 70.802)),
        TripModelsView(name: "Pune, Maharashtra",    coordinate: .init(latitude: 18.520, longitude: 73.856)),
        TripModelsView(name: "Jaipur, Rajasthan",    coordinate: .init(latitude: 26.912, longitude: 75.787)),
    ]

    private var filtered: [TripModelsView] {
        searchText.isEmpty
            ? suggestions
            : suggestions.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.black.opacity(0.001)
                //.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 0) {
                Spacer()
                sheetContent
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Sheet Content

    private var sheetContent: some View {
        VStack(spacing: 0) {
            handleBar
            mapPreview
            searchBar
            suggestionsList
            actionButtons
        }
        .background(
            //Color(red: 0.059, green: 0.098, blue: 0.137)
            Color.BackgroundColor
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .ignoresSafeArea(edges: .bottom)
        )
        .padding(.bottom, 49)
    }

    // MARK: - Handle Bar

    private var handleBar: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.AccentColor.opacity(0.15))
            .frame(width: 40, height: 5)
            .padding(.top, 14)
            .padding(.bottom, 20)
    }

    // MARK: - Map Preview

    private var mapPreview: some View {
        ZStack(alignment: .topLeading) {
            Map(position: $cameraPosition) {
                if let loc = selected {
                    Marker(loc.name, coordinate: loc.coordinate)
                        .tint(Color.AccentColor.opacity(0.5))
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                       // very subtle warm tint — lets map show through clearly
                       RoundedRectangle(cornerRadius: 20)
                           .fill(Color.BackgroundColor.opacity(0.08))
                           .allowsHitTesting(false)
                   )
            
            .overlay(
                        // Shiny border
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.9),
                                             Color.white.opacity(0.3),
                                             Color.AccentColor.opacity(0.1)
                                            ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
            
            
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.white.opacity(0.4), lineWidth: 1)
//                .frame(height: 200)
//            
            
            // Title badge
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    ZStack{
                        Color.white.opacity(0.55)
                        Color.BackgroundColor.opacity(0.3)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                         RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.7), lineWidth: 0.8)
                        )
                .shadow(color: Color.black.opacity(0.06), radius: 4, y: 2)
                .padding(12)

            if selected == nil {
                Text("TAP A LOCATION BELOW")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.black.opacity(0.06))
                    .background(Color.AccentColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: 200)
        .shadow(color: Color.AccentColor.opacity(0.15), radius: 12,x: 0, y: 6)
        .padding(.horizontal, 20)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.AccentColor)
                .font(.system(size: 15))
            TextField("Search city or place...", text: $searchText)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.AccentColor)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.BackgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.AccentColor.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Suggestions List

    private var suggestionsList: some View {
        ScrollView {
            VStack(spacing: 6) {
                ForEach(filtered) { loc in
                    suggestionRow(loc)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .frame(maxHeight: 200)
    }

    private func suggestionRow(_ loc: TripModelsView) -> some View {
        let isSelected = selected?.id == loc.id
        return Button {
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
                    .foregroundColor(isSelected ? Color.AccentColor : Color.AccentColor.opacity(0.5))
                    .font(.system(size: 18))
                Text(loc.name)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(isSelected ? Color.AccentColor : Color.AccentColor.opacity(0.6))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.AccentColor)
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(isSelected ? Color.AccentColor.opacity(0.1) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.AccentColor.opacity(0.35) : Color.clear, lineWidth: 1)
            )
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 12) {
            // Cancel
            Button {
                onClose()
            } label: {
                Text("CANCEL")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.BackgroundColor.opacity(0.5))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.AccentColor.opacity(0.4), lineWidth: 1)
                    )
            }

            // Confirm
            Button {
                if let s = selected { onSelect(s) }
            } label: {
                Text("CONFIRM LOCATION")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(selected != nil ? .black : Color.AccentColor.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(confirmBG)
                    .cornerRadius(14)
            }
            .disabled(selected == nil)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 36)
    }

    @ViewBuilder
    private var confirmBG: some View {
        if selected != nil {
            LinearGradient(
                colors: [Color.AccentColor, Color.AccentColor.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            Color.AccentColor.opacity(0.5)
        }
    }
}
