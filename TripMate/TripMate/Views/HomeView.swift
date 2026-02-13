//
//  HomeView.swift
//  TripMate
//
//  Created by iMac on 06/02/26.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
 
        
    var body: some View {

                TabView(selection: $selectedTab){
                    
                    HomePageView()
                        .tabItem{
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    
                    MapView()
                        .tabItem{
                            Label("Map", systemImage: "map")
                        }
                        .tag(1)
                    
                    CreateTripView()
                        .tabItem{
                            Label("Create Trip", systemImage: "plus")
                        }
                        .tag(2)
                    
                }
            }
        }
struct HomePageView: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack{
            ZStack{
                Color.BackgroundColor
                    .ignoresSafeArea()
                Text("Welcome to The TripMate Home Page")
                
                    .searchable(text: $searchText, prompt: "Search trips")
                    .frame(maxWidth: .infinity)
                
                    .toolbar {
                        
                        // Profile Image on LEFT
                        ToolbarItem(placement: .navigationBarLeading) {
                            
                            NavigationLink(destination: ProfileView()) {
                                
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                
            }
        }
    }
}
#Preview {
    HomeView()
}
 
