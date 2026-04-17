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






//import SwiftUI
//
//// MARK: - Main Home View (Tab Bar)
//
//struct HomeView: View {
//    
//    @State private var selectedTab = 0
//    
//    var body: some View {
//        
//        TabView(selection: $selectedTab) {
//            
//            NavigationStack{
//                HomePageView()
//            }
//                .tabItem {
//                    Label("Home", systemImage: "house.fill")
//                }
//                .tag(0)
//            
//            MapView()
//                .tabItem {
//                    Label("Map", systemImage: "map")
//                }
//                .tag(1)
//            
//            CreateTripView()
//                .tabItem {
//                    Label("Create Trip", systemImage: "plus")
//                }
//                .tag(2)
//        }
//    }
//}
//
////////////////////////////////////////////////////////////////
//
//// MARK: - Home Page Screen
//
//struct HomePageView: View {
//    
//    let trips = ["Goa", "Manali", "Kerala", "Dubai", "Paris"]
//    
//    @State private var searchText = ""
//  
//    
//    // 🔍 Filtered Trips
//    var filteredTrips: [String] {
//        if searchText.isEmpty {
//            return trips
//        } else {
//            return trips.filter {
//                $0.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
//    
//    var body: some View {
//        
//      
//            
//            ZStack {
//                Color.BackgroundColor
//                    .ignoresSafeArea()
//                
//                List(filteredTrips, id: \.self) { trip in
//                    
//                    HStack {
//                        Image(systemName: "airplane")
//                            .foregroundColor(.accentColor)
//                        
//                        VStack(alignment: .leading) {
//                            Text(trip)
//                                .font(.headline)
//                            
//                            Text("Tap to view details")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//                .listStyle(.plain)
//            }
//            
//            // 🔍 Search Bar
//            .searchable(text: $searchText, prompt: "Search trips")
//            
//            // 👤 Profile Button (Top Left)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    NavigationLink(destination: ProfileView()) {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .frame(width: 35, height: 35)
//                            .foregroundColor(.accentColor)
//                    }
//                }
//            }
//            
//            .navigationTitle("Home")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//
//
////////////////////////////////////////////////////////////////
//
//// MARK: - Profile View
//
//struct profileView: View {
//    var body: some View {
//        VStack {
//            Text("Profile Screen")
//                .font(.largeTitle)
//        }
//        .navigationTitle("Profile")
//    }
//}
//
////////////////////////////////////////////////////////////////
//
//// Dummy Map View
//
//struct mapView: View {
//    var body: some View {
//        Text("Map Screen")
//    }
//}
//
//// Dummy Create Trip View
//
//struct createTripView: View {
//    var body: some View {
//        Text("Create Trip Screen")
//    }
//}
//
////////////////////////////////////////////////////////////////
//
//#Preview {
//    HomeView()
//}



import SwiftUI

// MARK: - Main Tab View
//struct HomeView: View {
//    
//    @State private var selectedTab = 0
//    @EnvironmentObject var SessionVM: SessionViewModel
//    @Environment(\.managedObjectContext) private var context
//    @EnvironmentObject var profileImageManager: ProfileImageManager
//
//    
//    var body: some View {
//        
//        TabView(selection: $selectedTab) {
//            
//           
//            NavigationStack {
//                HomePageView()
//            }
//            .tabItem { Label("Home", systemImage: "house.fill") }
//            .tag(0)
//            
//            NavigationStack {
//                MapView()
//            }
//            .tabItem { Label("Map", systemImage: "map") }
//            .tag(1)
//            
//            NavigationStack {
//                CreateTripView()
//            }
//            .tabItem { Label("Create Trip", systemImage: "plus") }
//            .tag(2)
//            
//            NavigationStack {
//                ProfileView()
//                    .environmentObject(SessionVM)
//                    .environmentObject(profileImageManager)
//            }
//            .tabItem{
//                Label {
//                    Text("Profile")
//                } icon: {
//                    profileTabIcon
//                }
//            }
//            .tag(3)
//        }
//        .tabViewStyle(.automatic)
//        .tint(Color.AccentColor)
////        .toolbarColorScheme(.dark, for: .tabBar)
////        .toolbarBackground(.black, for: .tabBar)
////        .toolbarBackground(.visible, for: .tabBar)
////        .tint(.white)
//        .onAppear {
//                    // Load profile image when tab bar appears
//                    if let uid = SessionVM.currentUserUID {
//                        profileImageManager.load(uid: uid, context: context)
//                    }
//                }
//            }
//@ViewBuilder
// private var profileTabIcon: some View {
//     if let image = profileImageManager.profileImage {
//         Image(uiImage: image)
//             .resizable()
//             .scaledToFill()
//             .frame(width: 28, height: 28)
//             .clipShape(Circle())
//     } else if let avatar = profileImageManager.profileAvatar {
//         Text(avatar)
//             .font(.system(size: 20))
//     } else {
//         Image(systemName: "person.circle")
//     }
//   }
//}




// MARK: - Main Tab View with Custom Tab Bar
struct HomeView: View {
    
    @StateObject private var expenseStore = ExpenseStore()
    @State private var selectedTab = 0
    @EnvironmentObject var SessionVM: SessionViewModel
    @EnvironmentObject var profileImageManager: ProfileImageManager
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        ZStack(alignment: .bottom) {
            
            // ── Page Content ─────────────────────────
            currentTabView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.padding(.bottom, 80) // space for tab bar
            .ignoresSafeArea(edges: .bottom)
            .safeAreaInset(edge: .bottom){
                Color.clear.frame(height: 100)
            }
            
            // ── Custom Tab Bar ────────────────────────
            customTabBar
                .background(Color.clear)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if let uid = SessionVM.currentUserUID {
                profileImageManager.load(uid: uid, context: context)
                profileImageManager.loadAvatar(seed: SessionVM.currentUser)
            }
        }
    }
    
    // MARK: - Custom Tab Bar
    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabBarButton(index: 0, icon: "house.fill", label: "Home")
            tabBarButton(index: 1, icon: "map", label: "Map")
            tabBarButton(index: 2, icon: "plus", label: "Create Trip")
            profileTabButton  // special button for profile
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 28) // safe area padding
        .background(
            ZStack {
                // glass base
                Color.white.opacity(0.1)
                Color.BackgroundColor.opacity(0.32)
            }
                .frame(height: 65)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        )
        .overlay(
            // top border line
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.AccentColor.opacity(0.4), lineWidth: 2)
                .frame(height: 65)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, -6)
    }
    
    @ViewBuilder
    private var currentTabView: some View {
        switch selectedTab {
        case 0:
            NavigationStack { HomePageView() }
        case 1:
            NavigationStack { MapView() }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 100)
                }
        case 2:
            NavigationStack { CreateTripView() }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 120)
                }
//        case 3:
//            NavigationStack {
//                SettlementSummaryView(
//                    expenseStore: ExpenseStore(),
//                    currentUserName: SessionVM.currentUserName ?? "You"
//                )
//            }
        case 3:
            NavigationStack {
                ProfileView()
                    .environmentObject(SessionVM)
                    .environmentObject(profileImageManager)
            }
        default:
            NavigationStack { HomePageView() }
        }
    }
    
    // MARK: - Regular Tab Button
    private func tabBarButton(index: Int, icon: String, label: String) -> some View {
        let isActive = selectedTab == index
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 0) {
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: isActive ? .bold : .regular))
                    .foregroundColor(isActive ? Color.AccentColor : Color.AccentColor.opacity(0.4))
                    .frame(width: 28, height: 28)
                    .scaleEffect(isActive ? 1.15 : 1.0)
                    .animation(.spring(response: 0.3), value: isActive)
                
                Text(label)
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(isActive ? Color.AccentColor : Color.AccentColor.opacity(0.4))
                
                // active indicator dot
//                Circle()
//                    .fill(Color.AccentColor)
//                    .frame(width: 4, height: 4)
//                    .opacity(isActive ? 1 : 0)
//                    .animation(.spring(response: 0.3), value: isActive)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
        }
        .padding(.top, 15)
    }
    
    // MARK: - Profile Tab Button (with pic support)
    private var profileTabButton: some View {
        let isActive = selectedTab == 3
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = 3
            }
        } label: {
            VStack(spacing: 0) {
                Spacer()
                // profile pic or default icon
                ZStack {
                    if let image = profileImageManager.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(
                                    isActive ? Color.AccentColor : Color.AccentColor.opacity(0.3),
                                    lineWidth: isActive ? 1 : 0.5
                                )
                            )
                    } else if let avatar = profileImageManager.avatarImage {
                        // ✅ Pre-fetched DiceBear
                        Image(uiImage: avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(
                                    isActive ? Color.AccentColor : Color.AccentColor.opacity(0.3),
                                    lineWidth: isActive ? 1 : 0.5
                                )
                            )
                    } else {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(isActive ? Color.AccentColor : Color.AccentColor.opacity(0.4))
                    }
                }

//                    else {
//                        Image(systemName: "person.circle.fill")
//                            .font(.system(size: 24, weight: isActive ? .bold : .regular))
//                            .foregroundColor(isActive ? Color.AccentColor : Color.AccentColor.opacity(0.4))
//                    }
                
                .frame(width: 28, height: 28)
                .scaleEffect(isActive ? 1.1 : 1.0)
               // .animation(.spring(response: 0.3), value: isActive)
                //.padding(.top, 3)
                //Spacer()
                Text("Profile")
                    .font(.system(size: 8, weight: .medium, design: .monospaced))
                    .foregroundColor(isActive ? Color.AccentColor : Color.AccentColor.opacity(0.4))
                    .padding(.bottom, 3)
                
                // active indicator dot
//                Circle()
//                    .fill(Color.AccentColor)
//                    .frame(width: 4, height: 4)
//                    .opacity(isActive ? 1 : 0)
//                    .animation(.spring(response: 0.3), value: isActive)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
        }
    }
    
}




//////////////////////////////////////////////////////////////

// MARK: - Home Page Screen
struct HomePageView: View {

    @StateObject private var tripVM = TripViewModel()
    @EnvironmentObject var SessionVM: SessionViewModel
    @State private var searchText = ""
    @State private var selectedTripForEdit: TripEntity? = nil

    var filteredTrips: [TripEntity] {
        if searchText.isEmpty { return tripVM.trips }
        return tripVM.trips.filter {
            ($0.title ?? "").localizedCaseInsensitiveContains(searchText) ||
            ($0.destination ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            if tripVM.trips.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "airplane.circle")
                        .font(.system(size: 60))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                    Text("No trips yet!")
                        .font(.title2).fontWeight(.semibold)
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                    Text("Tap 'Create Trip' to plan your first adventure")
                        .font(.subheadline)
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List {
                        ForEach(filteredTrips, id: \.tid) { trip in
                            ZStack {
                                NavigationLink(value: trip) { EmptyView() }
                                    .opacity(0)
                                TripCardView(trip: trip)
                            }
                            //.buttonStyle(.plain)
                            //.labelsHidden()
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.BackgroundColor)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 6)
                            // swipe to edit
                            .swipeActions(edge: .leading, allowsFullSwipe: false){
                                NavigationLink{
                                    EditTripView(trip: trip)
                                        .environmentObject(SessionVM)
                                } label : {
                                    Label("Edit" ,systemImage: "square.and.pencil")
                                }
                                .tint(Color.AccentColor )
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if SessionVM.currentUserObjectID != nil {
                                        tripVM.deleteTrip(trip)
                                    }
                                } label: {
                                    Label("Detele", systemImage: "trash")
                                }
                            }
                        }
                    //.padding(.top, 10)
                    //.padding(.bottom, 120)
                }
                          .listStyle(.plain)
                          .background(Color.BackgroundColor)
                          .scrollContentBackground(.hidden)
                          .contentMargins(.bottom, 120, for: .scrollContent)
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search trips")
        .navigationDestination(for: TripEntity.self) { trip in
            TripDetailView(trip: trip)
                .environmentObject(SessionVM)
        }
        .navigationDestination(isPresented: Binding(
            get: {selectedTripForEdit != nil },
            set: {if !$0 {selectedTripForEdit = nil } }
        )) {
            if let trip = selectedTripForEdit {
                EditTripView(trip: trip)
                    .environmentObject(SessionVM)
            }
        }
        .onAppear {
            if let objID = SessionVM.currentUserObjectID {
                Task { await tripVM.fetchTrips(userObjectID: objID) }
            }
        }
    }
}




#Preview {
    HomeView()
        .environmentObject(SessionViewModel())
        .environmentObject(ProfileImageManager())
}
