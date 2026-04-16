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
internal import _LocationEssentials

struct TripDetailView: View {
    @ObservedObject var trip: TripEntity
    
    @State private var showEditView = false
    @State private var showRouteView = false
    @State private var savedStops: [StopEntity] = []
    private let stopRepo = StopRepository()
    
    @StateObject private var expenseStore: ExpenseStore
    @StateObject private var tripVM = TripViewModel()
    
    @EnvironmentObject var SessionVM: SessionViewModel
    
    //private let members = ["You", "Rahul", "Priya", "Arun", "mahek", "krishna"]
    
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
       
//    private var tripMemberNames: [String] {
//        let memberRepo = TripMemberRepository()
//        let members = (try? memberRepo.fetchMembers(for: trip.objectID)) ?? []
//        var names = members.compactMap { $0.memberName }
//        // Add current user
//        let userName = SessionVM.currentUser
//        if !userName.isEmpty && !names.contains(userName) {
//            names.insert(userName, at: 0)
//        }
//        return names.isEmpty ? ["You"] : names
//    }
    

    private struct MemberDisplay {
        let name: String
        let profilePicData: Data?
    }

    private var tripMembers: [MemberDisplay] {
        let memberRepo = TripMemberRepository()
        let members = (try? memberRepo.fetchMembers(for: trip.objectID)) ?? []
        
        var result: [MemberDisplay] = []
        
        // Add current logged-in user first
        let userName = SessionVM.currentUser
        if !userName.isEmpty {
            // Fetch current user's profile pic from CoreData by username
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", userName)
            let currentUser = try? PersistenceController.shared.context.fetch(fetchRequest).first
            result.append(MemberDisplay(name: userName, profilePicData: currentUser?.profilePic))
        }
        
        // Add all trip members added by the trip creator
        for member in members {
            guard let name = member.memberName else { continue }
            
            // Try to find a matching UserEntity by name or phone to get their profile pic
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@ OR phoneNo == %@",
                                                  name, member.phoneNo ?? "")
            let matchedUser = try? PersistenceController.shared.context.fetch(fetchRequest).first
            
            result.append(MemberDisplay(name: name, profilePicData: matchedUser?.profilePic))
        }
        
        return result.isEmpty ? [MemberDisplay(name: "You", profilePicData: nil)] : result
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
                        .padding(.top, 24)
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
            //.padding(.trailing)
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
            savedStops = stopRepo.fetchStops(for: trip)
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
                TripRouteView(
                    trip: trip,
                    stops: savedStops.map { stop in
                        TripStop(
                            location: TripModelsView(
                                name: stop.stopName ?? "",
                                coordinate: .init(
                                    latitude: stop.latitude,
                                    longitude: stop.longitude
                                )
                            ),
                            index: 0
                        )
                    }
                )
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
        VStack(alignment: .leading) {
                // Trip name big
                Text(tripName.uppercased())
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.AccentColor)
                    .kerning(2)
                    .padding(.horizontal, 15)
                    .padding(.top, -60)
            
                    Label(startLocation, systemImage: "mappin.circle.fill")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.7))
                        .padding(.horizontal, 17)
                        .padding(.top, -40)
                
                // Members avatars
//                HStack(spacing: -8) {
//                    ForEach(members.prefix(4), id: \.self) { member in
//                        ZStack {
//                            Circle()
//                                .fill(Color.AccentColor)
//                                .frame(width: 28, height: 28)
//                                .overlay(Circle().stroke(Color.BackgroundColor, lineWidth: 2))
//                            Text(String(member.prefix(1)).uppercased())
//                                .font(.system(size: 11, weight: .bold))
//                                .foregroundColor(.white)
//                        }
//                    }
//                    Text("+\(members.count) members")
//                        .font(.system(size: 10, design: .monospaced))
//                        .foregroundColor(Color.AccentColor.opacity(0.6))
//                        .padding(.leading, 14)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.horizontal, 15)
//            .padding(.top, -30)
//
            // AFTER (replace with this):
            HStack(spacing: -8) {
                ForEach(tripMembers.prefix(4), id: \.name) { member in
                // Inside your TripDetailView
//                ForEach(trip.membersArray, id: \.objectID) { member in
//                    TripMemberRowView(
//                        member: member,
//                        isOwner: false
//                    )
                
                
                    ZStack {
                        Circle()
                            .fill(Color.AccentColor)
                            .frame(width: 28, height: 28)
                            .overlay(Circle().stroke(Color.BackgroundColor, lineWidth: 2))
                        
                        if let data = member.profilePicData,
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                        } else {
                            Text(String(member.name.prefix(1)).uppercased())
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                if tripMembers.count > 4 {
                    Text("+\(tripMembers.count - 4) member\(tripMembers.count - 4 == 1 ? "" : "s")")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                        .padding(.leading, 14)
                }
            }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                        .padding(.top, -25)

            
            Divider()
                .opacity(0.9)
                .padding(.horizontal, 20)
                .padding(.top, 10)
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
                tripMembers: tripMembers.map { $0.name }, 
                paymentStore: PaymentStore()
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
            
            // Row: Fuel + Checklist
            HStack(spacing: 14) {
                NavigationLink(destination: FuelCalculatorView(tripName: tripName, tripObjectID: trip.objectID)) {
                    featureCard(
                        icon: "fuelpump.fill",
                        title: "Fuel Log",
                        subtitle: "Track mileage",
                        accent: Color(red: 0.9, green: 0.3, blue: 0.3),
                        fullWidth: false
                    )
                }
                NavigationLink(destination: ChecklistView(tripName: tripName, tripObjectID: trip.objectID)) {
                    featureCard(
                        icon: "checklist",
                        title: "Check list",
                        subtitle: "Pack items",
                        accent: Color(red: 0.6, green: 0.3, blue: 0.8),
                        fullWidth: false
                    )
                }
            }
            
            // Row: Journal + SOS
            HStack(spacing: 14) {
                NavigationLink(destination: JournalView(
                    tripName: tripName,
                    tripObjectID: trip.objectID
                )) {
                    featureCard(
                        icon: "book.fill",
                        title: "Journal",
                        subtitle: "Write memories",
                        accent: Color(red: 0.8, green: 0.5, blue: 0.2),
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
            
            NavigationLink(destination: StopsListView(trip: trip)) {
                featureCard(
                    icon: "mappin.and.ellipse",
                    title: "Stops",
                    subtitle: savedStops.isEmpty
                        ? "No stops yet"
                        : "\(savedStops.count) stop\(savedStops.count == 1 ? "" : "s") planned",
                    accent: Color(red: 0.3, green: 0.7, blue: 0.8),
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                 //   .kerning(0.4)

                Text(subtitle)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Color.AccentColor.opacity(0.3))
        }
        .padding(11)
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
            .environment(\.managedObjectContext, context)
            .environmentObject(SessionViewModel())
    }
}




// MARK: - Stub Views (replace when built)
//struct JournalView: View {
//    let tripName: String
//    var body: some View {
//        ZStack { Color.BackgroundColor.ignoresSafeArea() }
//        .navigationTitle("Journal")
//    }
//}

//struct ChecklistView: View {
//    let tripName: String
//    var body: some View {
//        ZStack { Color.BackgroundColor.ignoresSafeArea() }
//        .navigationTitle("Checklist")
//    }
//}


struct FuelCalculatorView: View {
    let tripName: String
    let tripObjectID: NSManagedObjectID

    private let repo = FuelLogRepository()

    @State private var logs: [FuelLogEntity] = []
    @State private var showAddSheet = false

    // Add form fields
    @State private var liters      = ""
    @State private var price       = ""
    @State private var location    = ""
    @State private var odometer    = ""
    @State private var date        = Date()

    // MARK: - Computed
    private var totalFuelCost: Double {
        logs.reduce(0) { $0 + $1.totalCost }
    }
    private var totalLiters: Double {
        logs.reduce(0) { $0 + $1.liters }
    }
    private var mileage: Double? {
        guard logs.count >= 2 else { return nil }
        let sorted = logs.sorted { $0.odometer < $1.odometer }
        let kmDriven = sorted.last!.odometer - sorted.first!.odometer
        guard totalLiters > 0, kmDriven > 0 else { return nil }
        return kmDriven / totalLiters
    }

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── Summary Cards ──────────────────────────────
                    HStack(spacing: 12) {
                        summaryCard(
                            title: "TOTAL COST",
                            value: "₹\(String(format: "%.0f", totalFuelCost))",
                            icon: "indianrupeesign.circle.fill",
                            accent: Color(red: 0.9, green: 0.3, blue: 0.3)
                        )
                        summaryCard(
                            title: "TOTAL FUEL",
                            value: "\(String(format: "%.1f", totalLiters))L",
                            icon: "fuelpump.fill",
                            accent: Color(red: 0.3, green: 0.6, blue: 0.9)
                        )
                        summaryCard(
                            title: "MILEAGE",
                            value: mileage != nil
                                ? "\(String(format: "%.1f", mileage!)) km/L"
                                : "N/A",
                            icon: "speedometer",
                            accent: Color(red: 0.3, green: 0.75, blue: 0.4)
                        )
                    }

                    // ── Mileage note ───────────────────────────────
                    if logs.count < 2 {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 12))
                                .foregroundColor(Color.AccentColor.opacity(0.5))
                            Text("Add at least 2 fuel logs with odometer readings to calculate mileage")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.5))
                        }
                        .padding(12)
                        .background(Color.AccentColor.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
                    }

                    // ── Add Button ─────────────────────────────────
                    Button { showAddSheet = true } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle").font(.system(size: 18))
                            Text("LOG FUEL STOP")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .kerning(2)
                        }
                        .foregroundColor(Color.AccentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.AccentColor.opacity(0.05))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.AccentColor.opacity(0.3),
                                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])))
                    }

                    // ── Logs List ──────────────────────────────────
                    if logs.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "fuelpump.slash")
                                .font(.system(size: 44))
                                .foregroundColor(Color.AccentColor.opacity(0.3))
                            Text("NO FUEL LOGS YET")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.4))
                                .kerning(2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(logs, id: \.fuelId) { log in
                            fuelLogRow(log)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Fuel Log")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadLogs() }
        .sheet(isPresented: $showAddSheet) { addSheet }
    }

    // MARK: - Summary Card
    private func summaryCard(title: String, value: String,
                              icon: String, accent: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(accent)
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text(title)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.AccentColor.opacity(0.07))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1))
    }

    // MARK: - Fuel Log Row
    private func fuelLogRow(_ log: FuelLogEntity) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.9, green: 0.3, blue: 0.3).opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "fuelpump.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(log.location ?? "Unknown location")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                HStack(spacing: 10) {
                    Text("\(String(format: "%.1f", log.liters))L")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                    Text("@ ₹\(String(format: "%.1f", log.pricePerLiter))/L")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                    if log.odometer > 0 {
                        Text("\(String(format: "%.0f", log.odometer)) km")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(Color.AccentColor.opacity(0.6))
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("₹\(String(format: "%.0f", log.totalCost))")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                if let date = log.date {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                }
            }

            Button {
                repo.deleteLog(log)
                loadLogs()
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundColor(.red.opacity(0.6))
                    .frame(width: 30, height: 30)
                    .background(Color.red.opacity(0.08))
                    .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Color.BackgroundColor)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1))
    }

    // MARK: - Add Sheet
    private var addSheet: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("LOG FUEL STOP")
                        .font(.system(size: 16, weight: .heavy, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                        .kerning(2)
                        .padding(.top, 24)

                    inputField(label: "LITERS FILLED", placeholder: "e.g. 35.5", text: $liters, keyboard: .decimalPad)
                    inputField(label: "PRICE PER LITER (₹)", placeholder: "e.g. 96.5", text: $price, keyboard: .decimalPad)
                    inputField(label: "ODOMETER (km)", placeholder: "e.g. 12450", text: $odometer, keyboard: .decimalPad)
                    inputField(label: "LOCATION", placeholder: "e.g. HP Petrol Pump, Surat", text: $location, keyboard: .default)

                    DatePicker("DATE", selection: $date, displayedComponents: .date)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                        .padding(14)
                        .background(Color.AccentColor.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1))

                    // Cost preview
                    let l = Double(liters) ?? 0
                    let p = Double(price) ?? 0
                    if l > 0 && p > 0 {
                        HStack {
                            Text("TOTAL COST")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.6))
                            Spacer()
                            Text("₹\(String(format: "%.2f", l * p))")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor)
                        }
                        .padding(14)
                        .background(Color.AccentColor.opacity(0.08))
                        .cornerRadius(12)
                    }

                    Button {
                        guard let l = Double(liters), l > 0,
                              let p = Double(price), p > 0 else { return }
                        let odo = Double(odometer) ?? 0
                        repo.addLog(
                            tripID: tripObjectID,
                            liters: l,
                            pricePerLiter: p,
                            location: location.isEmpty ? "Unknown" : location,
                            odometer: odo,
                            date: date
                        )
                        loadLogs()
                        clearForm()
                        showAddSheet = false
                    } label: {
                        Text("SAVE FUEL LOG")
                            .font(.system(size: 15, weight: .heavy, design: .rounded))
                            .kerning(2)
                            .foregroundColor(Color.AccentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.AccentColor.opacity(0.1))
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.AccentColor.opacity(0.4), lineWidth: 1.5))
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Input Field
    private func inputField(label: String, placeholder: String,
                             text: Binding<String>,
                             keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.6))
                .kerning(2)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .padding(14)
                .background(Color.AccentColor.opacity(0.05))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1))
        }
    }

    // MARK: - Helpers
    private func loadLogs() {
        guard let trip = try? PersistenceController.shared.container.viewContext
            .existingObject(with: tripObjectID) as? TripEntity else { return }
        logs = repo.fetchLogs(for: trip)
    }

    private func clearForm() {
        liters = ""; price = ""; location = ""; odometer = ""; date = Date()
    }
}

//struct SOSView: View {
//    let tripName: String
//    var body: some View {
//        ZStack { Color.BackgroundColor.ignoresSafeArea() }
//        .navigationTitle("SOS")
//    }
//}

struct StopsListView: View {
    let trip: TripEntity
    @State private var stops: [StopEntity] = []
    private let repo = StopRepository()

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            if stops.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "mappin.slash")
                        .font(.system(size: 44))
                        .foregroundColor(Color.AccentColor.opacity(0.3))
                    Text("NO STOPS YET")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                        .kerning(2)
                    Text("Stops are added when creating a trip")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.3))
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(stops.enumerated()), id: \.element.stopId) { idx, stop in
                            HStack(spacing: 14) {
                                // Index badge
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.AccentColor.opacity(0.15))
                                        .frame(width: 36, height: 36)
                                    Text("\(idx + 1)")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(Color.AccentColor)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(stop.stopName ?? "Unknown")
                                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                        .foregroundColor(Color.AccentColor)

                                    Text(String(format: "%.4f, %.4f",
                                                stop.latitude, stop.longitude))
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundColor(Color.AccentColor.opacity(0.5))

                                    if let note = stop.note, !note.isEmpty {
                                        Text(note)
                                            .font(.system(size: 11, design: .monospaced))
                                            .foregroundColor(Color.AccentColor.opacity(0.6))
                                    }
                                }

                                Spacer()

                                Button {
                                    repo.deleteStop(stop)
                                    stops = repo.fetchStops(for: trip)
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.system(size: 13))
                                        .foregroundColor(.red.opacity(0.7))
                                        .frame(width: 32, height: 32)
                                        .background(Color.red.opacity(0.08))
                                        .cornerRadius(8)
                                }
                            }
                            .padding(14)
                            .background(Color.BackgroundColor)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("Stops")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { stops = repo.fetchStops(for: trip) }
    }
}

