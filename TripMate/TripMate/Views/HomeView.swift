//
//  HomeView.swift
//  TripMate
//
//  Created by iMac on 06/02/26.
//
//
//import SwiftUI
//
//struct HomeView: View {
//    @State private var selectedTab = 0
// 
//        
//    var body: some View {
//
//                TabView(selection: $selectedTab){
//                    
//                    HomePageView()
//                        .tabItem{
//                            Label("Home", systemImage: "house.fill")
//                        }
//                        .tag(0)
//                    
//                    MapView()
//                        .tabItem{
//                            Label("Map", systemImage: "map")
//                        }
//                        .tag(1)
//                    
//                    CreateTripView()
//                        .tabItem{
//                            Label("Create Trip", systemImage: "plus")
//                        }
//                        .tag(2)
//                    
//                }
//            }
//        }
//struct HomePageView: View {
//    let trips = ["Goa", "Manali", "Kerala"]
//    @State private var searchText = ""
//    var body: some View {
//        NavigationStack{
//            ZStack{
//                Color.BackgroundColor
//                    .ignoresSafeArea()
//                Text("Welcome to The TripMate Home Page")
//                
//                    .searchable(text: $searchText, prompt: "Search trips")
//                    .frame(maxWidth: .infinity)
//                
//                    .toolbar {
//                        
//                        // Profile Image on LEFT
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            
//                            NavigationLink(destination: ProfileView()) {
//                                
//                                Image(systemName: "person.circle.fill")
//                                    .resizable()
//                                    .frame(width: 35, height: 35)
//                                    .foregroundColor(.accentColor)
//                            }
//                        }
//                        List(trips) { trip in
//                            HStack {
//                                Image(systemName: "airplane")
//                                    .foregroundColor(.accentColor)
//                                
//                                VStack(alignment: .leading) {
//                                    Text(trip.name ?? "")
//                                        .font(.headline)
//                                    
//                                    Text("Tap to view details")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                    }
//                
//            }
//        }
//    }
//}
//#Preview {
//    HomeView()
//}
// 

import SwiftUI

// MARK: - Main Home View (Tab Bar)

struct HomeView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            
            CreateTripView()
                .tabItem {
                    Label("Create Trip", systemImage: "plus")
                }
                .tag(2)
        }
    }
}

//////////////////////////////////////////////////////////////

// MARK: - Home Page Screen

struct HomePageView: View {
    
    let trips = ["Goa", "Manali", "Kerala", "Dubai", "Paris"]
    
    @State private var searchText = ""
  
    
    // 🔍 Filtered Trips
    var filteredTrips: [String] {
        if searchText.isEmpty {
            return trips
        } else {
            return trips.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color.BackgroundColor
                    .ignoresSafeArea()
                
                List(filteredTrips, id: \.self) { trip in
                    
                    HStack {
                        Image(systemName: "airplane")
                            .foregroundColor(.accentColor)
                        
                        VStack(alignment: .leading) {
                            Text(trip)
                                .font(.headline)
                            
                            Text("Tap to view details")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.plain)
            }
            
            // 🔍 Search Bar
            .searchable(text: $searchText, prompt: "Search trips")
            
            // 👤 Profile Button (Top Left)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//////////////////////////////////////////////////////////////

// MARK: - Profile View

struct profileView: View {
    var body: some View {
        VStack {
            Text("Profile Screen")
                .font(.largeTitle)
        }
        .navigationTitle("Profile")
    }
}

//////////////////////////////////////////////////////////////

// Dummy Map View

struct mapView: View {
    var body: some View {
        Text("Map Screen")
    }
}

// Dummy Create Trip View

struct createTripView: View {
    var body: some View {
        Text("Create Trip Screen")
    }
}

//////////////////////////////////////////////////////////////

#Preview {
    HomeView()
}
