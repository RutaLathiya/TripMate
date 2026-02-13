//
//  MapView.swift
//  TripMate
//
//  Created by iMac on 10/02/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 0,
                    longitude: 0
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 180,//140
                    longitudeDelta: 360//0.05//360
                )
            )
        )
    var body: some View {
        //Text("this is the map")
        Map(position: $position)
            .ignoresSafeArea()
          //.mapStyle(.standard)
         //.mapStyle(.imagery)
         .mapStyle(.hybrid)
    }
}
#Preview {
    MapView()
}

