//
//  MapComponents.swift
//  TripMate
//
//  Created by iMac on 06/03/26.
//


import SwiftUI
import MapKit

// MARK: - Map Control Button
// used for location, zoom in, zoom out buttons
struct MapControlButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
        }
    }
}

// MARK: - Map Style Button
// used for Standard / Hybrid / Satellite buttons
struct MapStyleButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .black : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color.white.opacity(0.15) : Color.clear)
            .cornerRadius(20)
        }
    }
}
