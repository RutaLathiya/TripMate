//
//  ChecklistView.swift
//  TripMate
//
//  Created by iMac on 07/04/26.
//

import SwiftUI
import CoreData

// MARK: - Repository
class ChecklistRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func fetchItems(for tripID: NSManagedObjectID) -> [ChecklistItemEntity] {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity//,
             // let tid = trip.tid
        else { return [] }
        
        let request = ChecklistItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "tripId == %@", trip)
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    func addItem(name: String, tripID: NSManagedObjectID) {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity//,
            //  let tid = trip.tid
        else {
            print("❌ Could not find trip for checklist item")
            return
        }
        
        let item = ChecklistItemEntity(context: context)
        item.itemId   = UUID()
        item.itemName = name
        item.isDone   = false
        item.trip     = trip
        
        do {
            try context.save()
            print("✅ Checklist item saved: \(name)")
        } catch {
            print("❌ Save failed: \(error)")
        }
    }

    func toggleItem(_ item: ChecklistItemEntity) {
        item.isDone.toggle()
        try? context.save()
    }

    func deleteItem(_ item: ChecklistItemEntity) {
        context.delete(item)
        try? context.save()
    }
}

// MARK: - ChecklistView
struct ChecklistView: View {
    let tripName: String
    let tripObjectID: NSManagedObjectID

    @State private var repo = ChecklistRepository()
    //@State private var items: [ChecklistItemEntity] = []
    @State private var newItem = ""
    @FocusState private var fieldFocused: Bool

    @FetchRequest private var items: FetchedResults<ChecklistItemEntity>

    init(tripName: String, tripObjectID: NSManagedObjectID) {
            self.tripName = tripName
            self.tripObjectID = tripObjectID

            // ✅ Fetch only items belonging to this trip
            let context = PersistenceController.shared.context
            let trip = try? context.existingObject(with: tripObjectID) as? TripEntity

            self._items = FetchRequest(
                entity: ChecklistItemEntity.entity(),
                sortDescriptors: [NSSortDescriptor(key: "itemName", ascending: true)],
                predicate: NSPredicate(format: "trip == %@", trip ?? NSNull())
            )
        }

    private var doneCount: Int { items.filter { $0.isDone }.count }
    private var totalCount: Int { items.count }

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // Progress Card
                    progressCard

                    // Input Row
                    inputRow

                    // Default suggestions if empty
                    if items.isEmpty {
                        suggestionsSection
                    }

                    // Items List
                    if !items.isEmpty {
                        VStack(spacing: 10) {
                            ForEach(items, id: \.itemId) { item in
                                checklistRow(item)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Checklist")
        .navigationBarTitleDisplayMode(.inline)
       // .onAppear { loadItems() }
    }

    // MARK: - Progress Card
    private var progressCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(doneCount)/\(totalCount)")
                        .font(.system(size: 32, weight: .heavy, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    Text("ITEMS PACKED")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.5))
                        .kerning(2)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.AccentColor.opacity(0.1), lineWidth: 6)
                        .frame(width: 60, height: 60)
                    Circle()
                        .trim(from: 0, to: totalCount == 0 ? 0 : CGFloat(doneCount) / CGFloat(totalCount))
                        .stroke(Color.AccentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.4), value: doneCount)
                    Text(totalCount == 0 ? "–" : "\(Int(CGFloat(doneCount) / CGFloat(totalCount) * 100))%")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.AccentColor.opacity(0.1))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.AccentColor)
                        .frame(width: totalCount == 0 ? 0 : geo.size.width * CGFloat(doneCount) / CGFloat(totalCount), height: 6)
                        .animation(.spring(response: 0.4), value: doneCount)
                }
            }
            .frame(height: 6)

            if totalCount > 0 && doneCount == totalCount {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                    Text("ALL PACKED! READY TO GO 🎉")
                        .kerning(1)
                }
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.green)
            }
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1))
    }

    // MARK: - Input Row
    private var inputRow: some View {
        HStack(spacing: 10) {
            TextField("Add item...", text: $newItem)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .focused($fieldFocused)
                .submitLabel(.done)
                .onSubmit { addItem() }
                .autocorrectionDisabled()

            Button { addItem() } label: {
                Text("ADD")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .kerning(1)
                    .foregroundColor(Color.AccentColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.AccentColor.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(14)
        .background(Color.BackgroundColor)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(Color.AccentColor.opacity(0.4), lineWidth: 1))
    }

    // MARK: - Suggestions
    private let suggestions = [
        "🪪 Passport / ID", "🔌 Charger & Power Bank", "🩹 First Aid Kit",
        "👕 Clothes", "🧴 Toiletries", "💊 Medicines", "🎒 Backpack", "📷 Camera"
    ]

    private var suggestionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("QUICK ADD")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)

            FlowLayout(spacing: 8) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        repo.addItem(name: suggestion, tripID: tripObjectID)
                        //loadItems()
                    } label: {
                        Text(suggestion)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(Color.AccentColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.AccentColor.opacity(0.08))
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1))
                    }
                }
            }
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.1), lineWidth: 1))
    }

    // MARK: - Checklist Row
    private func checklistRow(_ item: ChecklistItemEntity) -> some View {
        HStack(spacing: 14) {
            Button {
                withAnimation(.spring(response: 0.25)) {
                    repo.toggleItem(item)
                    //loadItems()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(item.isDone ? Color.AccentColor : Color.clear)
                        .frame(width: 26, height: 26)
                        .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(item.isDone ? Color.AccentColor : Color.AccentColor.opacity(0.3), lineWidth: 1.5))
                    if item.isDone {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.BackgroundColor)
                    }
                }
            }

            Text(item.itemName ?? "")
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(item.isDone ? Color.AccentColor.opacity(0.4) : Color.AccentColor)
                .strikethrough(item.isDone, color: Color.AccentColor.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.easeInOut(duration: 0.2), value: item.isDone)

            Button {
                withAnimation {
                    repo.deleteItem(item)
                   // loadItems()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color.AccentColor.opacity(0.3))
                    .frame(width: 28, height: 28)
                    .background(Color.AccentColor.opacity(0.05))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(item.isDone ? Color.AccentColor.opacity(0.04) : Color.BackgroundColor)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color.AccentColor.opacity(item.isDone ? 0.06 : 0.1), lineWidth: 1))
    }

    // MARK: - Helpers
    private func addItem() {
        let trimmed = newItem.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            repo.addItem(name: trimmed, tripID: tripObjectID)
            //loadItems()
        }
        newItem = ""
    }

//    private func loadItems() {
//        items = repo.fetchItems(for: tripObjectID)
//        print("📋 Loaded \(items.count) checklist items")
//    }
}

// MARK: - FlowLayout (wrapping chip layout)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0 }.reduce(0, +)
            + CGFloat(max(rows.count - 1, 0)) * spacing
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += rowHeight + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var currentWidth: CGFloat = 0
        let maxWidth = proposal.width ?? 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentWidth + size.width > maxWidth && !rows[rows.count - 1].isEmpty {
                rows.append([])
                currentWidth = 0
            }
            rows[rows.count - 1].append(subview)
            currentWidth += size.width + spacing
        }
        return rows
    }
}

