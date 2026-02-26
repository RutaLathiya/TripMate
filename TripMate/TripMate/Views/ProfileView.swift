//
//  ProfileView.swift
//  TripMate
//
//  Created by iMac on 12/02/26.
//
//
//import SwiftUI
//
//struct ProfileView: View {
//    @State private var items = ["logout" , "settings"]
//    var body: some View {
//        NavigationStack{
//            ZStack{
//                Color.BackgroundColor
//                    .ignoresSafeArea()
//                //Text("this is the profile view")
//                VStack{
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(Color.brown)
//                        .padding(.bottom, 20)
//                    
////                        List {
////                                    Text("My Account")
////                                    Text("settings")
////                                    Text("logout")
////                                }
////                        .listStyle(.plain)
////                        .background(Color.BackgroundColor)
//                    
//                    NavigationStack {
//                                
//                                List {
//                                    ForEach(itmes) { item in
//                                        TripCardView(trip: trip)
//                                            .listRowBackground(Color.clear)
//                                    }
//                                }
//                                .scrollContentBackground(.hidden)
//                                .background(Color.BackgroundColor)
//                                .navigationTitle("All Trips")
//                            }
//                    
//                }
//                
//            }
//        }
//    }
//}
//#Preview {
//    ProfileView()
//}

import SwiftUI

struct ProfileCardView: View {
    
    let title: String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: iconName(for: title))
                .foregroundColor(.accentColor)
                .frame(width: 25)
            
            Text(title.capitalized)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.CardColor)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    // icon logic
    private func iconName(for item: String) -> String {
        switch item.lowercased() {
        case "logout":
            return "arrow.backward.circle"
        case "settings":
            return "gearshape"
        case "my profile":
            return "person"
        default:
            return "person.circle"
        }
    }
}

struct ProfileView: View {
    
    @State private var items = ["settings", "logout", "my profile"]
    @State private var showLogoutAlert = false
    @EnvironmentObject var SessionVM: SessionViewModel
    
    var body: some View {
                    
            ZStack {
                Color.BackgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    // Profile Image
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
                        .padding(.top, 30)
                    
                    // Profile Options
                    ScrollView {
                        VStack(spacing: 15) {
                            
                            ForEach(items, id: \.self) { item in
                                ProfileCardView(title: item)
                                    .onTapGesture {
                                        if item == "logout"{
                                            showLogoutAlert = true
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
            }
//            .navigationTitle("Profile")
//            .navigationBarTitleDisplayMode(.large)
            .alert("Confirm Logout", isPresented: $showLogoutAlert) {
                
                Button("Cancel", role: .cancel) { }
                
                Button("Logout", role: .destructive) {
                    SessionVM.logout()
                    performLogout()
                    print("🔴 Logout button tapped")
                        print("🔴 isLoggedIn before: \(SessionVM.isLoggedIn)")
                        print("🔴 showLogIn before: \(SessionVM.showLogIn)")
                        
                        print("🔴 isLoggedIn after: \(SessionVM.isLoggedIn)")
                        print("🔴 showLogIn after: \(SessionVM.showLogIn)")
                }
                
            } message: {
                Text("Are you sure you want to logout?")
            }
           
    }
    func performLogout() {
            print("User logged out")
        }
}

#Preview {
    ProfileView()
        .environmentObject(SessionViewModel()) 
       
}
