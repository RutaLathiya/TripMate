//
//  StopsTabView.swift
//  TripMate
//
//  Created by iMac on 09/04/26.
//

import SwiftUI

struct StopsTabView: View {
    let trip: TripEntity
    @State private var stops: [StopEntity] = []
    private let repo = StopRepository()

    var body: some View {
        VStack {
            if stops.isEmpty {
                Text("No stops added")
                    .foregroundColor(.secondary)
            } else {
                ForEach(stops, id: \.stopId) { stop in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stop.stopName ?? "")
                                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                            Text(String(format: "%.3f, %.3f", stop.latitude, stop.longitude))
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.5))
                        }
                        Spacer()
                        Button {
                            repo.deleteStop(stop)
                            loadStops()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                    .padding(14)
                    .background(Color.BackgroundColor)
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
                }
            }
        }
        .onAppear { loadStops() }
    }

    private func loadStops() {
        stops = repo.fetchStops(for: trip)
    }
}
