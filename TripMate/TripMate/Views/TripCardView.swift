//
//  TripCardView.swift
//  TripMate
//
//  Created by iMac on 25/03/26.
//

import SwiftUI
import CoreData

struct TripCardView: View {

    @ObservedObject var trip: TripEntity

    private var dateRange: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd MMM yyyy"
        let start = trip.startDate.map { fmt.string(from: $0) } ?? "—"
        let end   = trip.endDate.map   { fmt.string(from: $0) } ?? "—"
        return "\(start)  →  \(end)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Banner
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color.AccentColor.opacity(0.8),
                             Color.AccentColor.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 90)
                
                Image(systemName: "car.2")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.15))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                
                Text(trip.title ?? "Untitled")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding(12)
                    .padding(.bottom, 30)
                
                Spacer()
                
                
                HStack {
                    MemberAvatarStack(members: trip.membersArray,
                                      size: 28,
                                      maxVisible: 3
                    )
                    .padding(12)
                    .padding(.top, 10)
                }
            }
            // Details
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(Color.AccentColor)
                    Text(trip.destination ?? "Unknown destination")
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                }

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                    Text(dateRange)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.6))
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.ContainerColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.AccentColor.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}


#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let trip = TripEntity(context: context)
    trip.title = "Goa Trip 🌴"
    trip.destination = "Goa"
    trip.startDate = Date()
    trip.endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
    
    return TripCardView(trip: trip)
        .environment(\.managedObjectContext, context)
        .background(Color.BackgroundColor)
}
