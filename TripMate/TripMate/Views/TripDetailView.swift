//
//  TripDetailView.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//
//
//import SwiftUI
//
//struct TripDetailView: View {
//    let tripName: String
//    
//    // expense store per trip
//       @StateObject private var expenseStore = ExpenseStore()
//       
//       // sample members — later replace with real trip members from CoreData
//       private let members = ["You", "Rahul", "Priya", "Arun"]
//    
//    var body: some View {
//        ZStack {
//            Color.BackgroundColor.ignoresSafeArea()
//            
//            VStack(spacing: 20) {
//                Text("Details for \(tripName)")
//                    .font(.largeTitle)
//                
//                // Weather button
//                NavigationLink(destination: WeatherView(cityName: tripName)) {
//                    HStack {
//                        Image(systemName: "cloud.sun.fill")
//                            .foregroundColor(Color.AccentColor)
//                        Text("Check Weather")
//                            .font(.system(size: 14, design: .monospaced))
//                            .foregroundColor(Color.AccentColor)
//                    }
//                    .padding(14)
//                    .background(Color.AccentColor.opacity(0.1))
//                    .cornerRadius(12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1)
//                    )
//                }
//                
//                
//                // Expenses button
//                                NavigationLink(destination: ExpenseView(
//                                    store: expenseStore,
//                                    tripName: tripName,
//                                    tripMembers: members
//                                )) {
//                                    HStack {
//                                        Image(systemName: "indianrupeesign.circle.fill")
//                                            .foregroundColor(Color.AccentColor)
//                                        Text("Expenses & Splitting")
//                                            .font(.system(size: 14, design: .monospaced))
//                                            .foregroundColor(Color.AccentColor)
//                                        Spacer()
//                                        if expenseStore.expenses.count > 0 {
//                                            Text("₹\(String(format: "%.0f", expenseStore.totalAmount))")
//                                                .font(.system(size: 12, weight: .bold, design: .monospaced))
//                                                .foregroundColor(Color.AccentColor.opacity(0.6))
//                                        }
//                                    }
//                                    .frame(maxWidth: .infinity)
//                                    .padding(14)
//                                    .background(Color.AccentColor.opacity(0.1))
//                                    .cornerRadius(12)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 12)
//                                            .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1)
//                                    )
//                                }
//                                
//                                Spacer()
//                
//                
//            }
//            
//            .padding(.horizontal, 20)
//                        .padding(.top, 20)
//            
//        }
//        .navigationTitle(tripName)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//#Preview {
//    TripDetailView(tripName: "Goa")
//}


import SwiftUI
import CoreData

struct TripDetailView: View {
    @ObservedObject var trip: TripEntity
    
    @State private var showEditView = false
    @State private var showRouteView = false
    @State private var tripStops: [TripStop] = []
    
    @StateObject private var expenseStore: ExpenseStore
    @StateObject private var tripVM = TripViewModel()
    
    @EnvironmentObject var SessionVM: SessionViewModel
    
    private let members = ["You", "Rahul", "Priya", "Arun", "mahek", "krishna"]
    
    // sample trip data — replace with CoreData later
    private var tripName: String { trip.title ?? "Trip" }
    private var startLocation: String { trip.destination ?? "" }

    private var dateRange: String {
           let fmt = DateFormatter()
           fmt.dateFormat = "MMM dd, yyyy"
           let s = trip.startDate.map { fmt.string(from: $0) } ?? "Not started"
           let e = trip.endDate.map   { fmt.string(from: $0) } ?? "Not ended"
           return "\(s) → \(e)"
       }
    
    // ✅ Trip status
       private var isStarted: Bool { trip.startDate != nil }
       private var isEnded: Bool   { trip.endDate != nil }
       
    private var tripMemberNames: [String] {
        let memberRepo = TripMemberRepository()
        let members = (try? memberRepo.fetchMembers(for: trip.objectID)) ?? []
        var names = members.compactMap { $0.memberName }
        // Add current user
        let userName = SessionVM.currentUser
        if !userName.isEmpty && !names.contains(userName) {
            names.insert(userName, at: 0)
        }
        return names.isEmpty ? ["You"] : names
    }
    
    init(trip: TripEntity) {
        self.trip = trip
        _expenseStore = StateObject(wrappedValue: ExpenseStore(tripObjectID: trip.objectID))
    }
    
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    heroSection
                    
                    tripActionButtons
                                           .padding(.horizontal, 20)
                                           .padding(.top, 16)
                    cardsGrid
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 120)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showEditView = true
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color.AccentColor)
                    }
                }
            }
            .navigationDestination(isPresented: $showEditView) {
                EditTripView(trip: trip)
                    .environmentObject(SessionVM)
            }
            
        }
//        .navigationTitle(tripName)
//        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            // Load stops if you have StopEntity
            // For now pass empty stops
            tripStops = []
        }
    }
    
    private var tripActionButtons: some View {
        HStack(spacing: 12) {

            // Start Trip Button
            Button {
                tripVM.startTrip(trip)
                showRouteView = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isStarted ? "checkmark.circle.fill" : "play.circle.fill")
                        .font(.system(size: 16))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isStarted ? "STARTED" : "START TRIP")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .kerning(1)
                        if isStarted, let date = trip.startDate {
                            Text(DateFormatter.shortDate.string(from: date))
                                .font(.system(size: 9, design: .monospaced))
                                .opacity(0.7)
                        }
                    }
                }
                .foregroundColor(isStarted ? .white : Color.AccentColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    isStarted
                        ? Color.green.opacity(0.8)
                        : Color.AccentColor.opacity(0.1)
                )
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isStarted ? Color.green : Color.AccentColor.opacity(0.3),
                            lineWidth: 1.5
                        )
                )
            }
            .disabled(isStarted) // ✅ can't start twice
            .navigationDestination(isPresented: $showRouteView) {
                TripRouteView(trip: trip, stops: tripStops)
            }
            // End Trip Button
            Button {
                tripVM.endTrip(trip)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isEnded ? "checkmark.circle.fill" : "stop.circle.fill")
                        .font(.system(size: 16))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isEnded ? "ENDED" : "END TRIP")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .kerning(1)
                        if isEnded, let date = trip.endDate {
                            Text(DateFormatter.shortDate.string(from: date))
                                .font(.system(size: 9, design: .monospaced))
                                .opacity(0.7)
                        }
                    }
                }
                .foregroundColor(isEnded ? .white : Color.AccentColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    isEnded
                        ? Color.red.opacity(0.7)
                        : Color.AccentColor.opacity(0.1)
                )
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isEnded ? Color.red : Color.AccentColor.opacity(0.3),
                            lineWidth: 1.5
                        )
                )
            }
            .disabled(!isStarted || isEnded) // ✅ can only end after starting
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            // gradient background
            LinearGradient(
                colors: [
                    Color.AccentColor.opacity(0.35),
                    Color.AccentColor.opacity(0.1),
                    Color.BackgroundColor
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 180)
            
            VStack(alignment: .leading, spacing: 10) {
                // Trip name big
                Text(tripName.uppercased())
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.AccentColor)
                    .kerning(2)
                
                // Date + location row
                HStack(spacing: 16) {
//                    Label("\(startDate) → \(endDate)", systemImage: "calendar")
//                        .font(.system(size: 11, design: .monospaced))
//                        .foregroundColor(Color.AccentColor.opacity(0.7))
                    
                    Label(startLocation, systemImage: "mappin.circle.fill")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.7))
                }
                
                // Members avatars
                HStack(spacing: -8) {
                    ForEach(members.prefix(4), id: \.self) { member in
                        ZStack {
                            Circle()
                                .fill(Color.AccentColor)
                                .frame(width: 28, height: 28)
                                .overlay(Circle().stroke(Color.BackgroundColor, lineWidth: 2))
                            Text(String(member.prefix(1)).uppercased())
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    Text("+\(members.count) members")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                        .padding(.leading, 14)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Cards Grid
    private var cardsGrid: some View {
        VStack(spacing: 14) {
            // Weather — full width
            NavigationLink(destination: WeatherView(
                cityName: trip.destination ?? "",
                latitude: trip.endLatitude,
                longitude: trip.endLongitude
            )) {
                featureCard(
                    icon: "cloud.sun.fill",
                    title: "Weather",
                    subtitle: "Forecast & alerts",
                    accent: Color(red: 0.2, green: 0.6, blue: 1.0),
                    fullWidth: true
                )
            }
            
            // Expenses — full width
            NavigationLink(destination: ExpenseView(
                store: expenseStore,
                tripName: tripName,
                tripMembers: tripMemberNames, paymentStore: PaymentStore()
            )) {
                featureCard(
                    icon: "indianrupeesign.circle.fill",
                    title: "Expenses",
                    subtitle: expenseStore.expenses.isEmpty
                        ? "Split bills"
                        : "₹\(String(format: "%.0f", expenseStore.totalAmount)) spent",
                    accent: Color(red: 0.3, green: 0.75, blue: 0.4),
                    fullWidth: true
                )
            }
            
            // Row: Journal + Checklist
            HStack(spacing: 14) {
                NavigationLink(destination: JournalView(tripName: tripName)) {
                    featureCard(
                        icon: "book.fill",
                        title: "Journal",
                        subtitle: "Daily notes",
                        accent: Color(red: 0.8, green: 0.5, blue: 0.2),
                        fullWidth: false
                    )
                }
                NavigationLink(destination: ChecklistView(tripName: tripName, tripObjectID: trip.objectID)) {
                    featureCard(
                        icon: "checklist",
                        title: "Checklist",
                        subtitle: "Pack items",
                        accent: Color(red: 0.6, green: 0.3, blue: 0.8),
                        fullWidth: false
                    )
                }
            }
            
            // Row: Fuel + SOS
            HStack(spacing: 14) {
                NavigationLink(destination: FuelCalculatorView(tripName: tripName)) {
                    featureCard(
                        icon: "fuelpump.fill",
                        title: "Fuel Log",
                        subtitle: "Track mileage",
                        accent: Color(red: 0.9, green: 0.3, blue: 0.3),
                        fullWidth: false
                    )
                }
                NavigationLink(destination: SOSView(tripName: tripName)) {
                    featureCard(
                        icon: "sos.circle.fill",
                        title: "SOS",
                        subtitle: "Emergency help",
                        accent: Color(red: 1.0, green: 0.2, blue: 0.2),
                        fullWidth: false
                    )
                }
                
            }
            // Add to cardsGrid in TripDetailView
            Button {
                showRouteView = true
            } label: {
                featureCard(
                    icon: "map.fill",
                    title: "Route",
                    subtitle: "View trip route",
                    accent: Color(red: 0.2, green: 0.5, blue: 0.9),
                    fullWidth: true
                )
            }
            // Settle Up — full width, right after Expenses card
            NavigationLink(destination: SettlementSummaryView(
                expenseStore: expenseStore,
                currentUserName: SessionVM.currentUser
            )) {
                featureCard(
                    icon: "arrow.left.arrow.right.circle.fill",
                    title: "Settle Up",
                    subtitle: expenseStore.expenses.isEmpty
                        ? "Split & pay"
                        : "\(expenseStore.settlements().count) settlement(s)",
                    accent: Color(red: 0.9, green: 0.6, blue: 0.1),
                    fullWidth: true
                )
            }
        }
    }
    
    // MARK: - Feature Card
    private func featureCard(
        icon: String,
        title: String,
        subtitle: String,
        accent: Color,
        fullWidth: Bool
    ) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(accent.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(accent)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                Text(subtitle)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color.AccentColor.opacity(0.3))
        }
        .padding(16)
        .frame(maxWidth: fullWidth ? .infinity : .infinity)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.AccentColor.opacity(0.06), radius: 8, y: 3)
    }
}

// MARK: - DateFormatter Helper
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd MMM, HH:mm"
        return f
    }()
}

//#Preview {
//    NavigationStack {
//        TripDetailView(trip: TripEntity())
//    }
//}

#Preview {
    let context = PersistenceController.shared.context
    let trip = TripEntity(context: context)
    trip.title = "Goa Trip"
    trip.destination = "Goa, India"
    return NavigationStack {
        TripDetailView(trip: trip)
    }
}


// MARK: - Stub Views (replace when built)
struct JournalView: View {
    let tripName: String
    var body: some View {
        ZStack { Color.BackgroundColor.ignoresSafeArea() }
        .navigationTitle("Journal")
    }
}

//struct ChecklistView: View {
//    let tripName: String
//    var body: some View {
//        ZStack { Color.BackgroundColor.ignoresSafeArea() }
//        .navigationTitle("Checklist")
//    }
//}

struct FuelCalculatorView: View {
    let tripName: String
    var body: some View {
        ZStack { Color.BackgroundColor.ignoresSafeArea() }
        .navigationTitle("Fuel Log")
    }
}

struct SOSView: View {
    let tripName: String
    var body: some View {
        ZStack { Color.BackgroundColor.ignoresSafeArea() }
        .navigationTitle("SOS")
    }
}



