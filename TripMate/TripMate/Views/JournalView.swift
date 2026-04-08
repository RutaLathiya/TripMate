//
//  JournalView.swift
//  TripMate
//
//  Created by iMac on 08/04/26.
//

// JournalView.swift
import SwiftUI
import CoreData
import PhotosUI

// MARK: - Journal Repository
class JournalRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func addEntry(text: String, mood: String, photoData: Data?, tripID: NSManagedObjectID) {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else { return }
        let entry = JournalEntity(context: context)
        entry.journalId  = UUID()
        entry.entryDate  = Date()
        entry.text       = text
        entry.mood       = mood
        entry.photoData  = photoData
        entry.trip       = trip
        try? context.save()
    }

    func deleteEntry(_ entry: JournalEntity) {
        context.delete(entry)
        try? context.save()
    }

    func updateEntry(_ entry: JournalEntity, text: String, mood: String, photoData: Data?) {
        entry.text      = text
        entry.mood      = mood
        entry.photoData = photoData
        try? context.save()
    }
}

// MARK: - Mood Model
enum JournalMood: String, CaseIterable {
    case amazing  = "🤩"
    case happy    = "😊"
    case neutral  = "😐"
    case tired    = "😴"
    case sad      = "😢"

    var label: String {
        switch self {
        case .amazing: return "Amazing"
        case .happy:   return "Happy"
        case .neutral: return "Okay"
        case .tired:   return "Tired"
        case .sad:     return "Sad"
        }
    }
}

// MARK: - Add/Edit Journal Sheet
struct JournalEntrySheet: View {
    let tripObjectID: NSManagedObjectID
    var existingEntry: JournalEntity? = nil
    var onSave: () -> Void

    @State private var text: String = ""
    @State private var selectedMood: JournalMood = .happy
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil
    @State private var photoImage: Image? = nil

    @Environment(\.dismiss) private var dismiss
    private let repo = JournalRepository()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.BackgroundColor.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // Date
                        HStack {
                            Text(Date().formatted(date: .long, time: .omitted).uppercased())
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.AccentColor.opacity(0.5))
                                .kerning(2)
                            Spacer()
                        }

                        // Mood Picker
                        moodPicker

                        // Photo Picker
                        photoPicker

                        // Text Editor
                        textEditor

                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle(existingEntry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveEntry() }
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                        .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear { loadExisting() }
        }
    }

    // MARK: - Mood Picker
    private var moodPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("HOW ARE YOU FEELING?")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)

            HStack(spacing: 8) {
                ForEach(JournalMood.allCases, id: \.self) { mood in
                    Button {
                        withAnimation(.spring(response: 0.25)) {
                            selectedMood = mood
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text(mood.rawValue)
                                .font(.system(size: 24))
                            Text(mood.label)
                                .font(.system(size: 8, weight: .bold, design: .monospaced))
                                .foregroundColor(selectedMood == mood
                                    ? Color.AccentColor
                                    : Color.AccentColor.opacity(0.3))
                                .kerning(0.5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedMood == mood
                            ? Color.AccentColor.opacity(0.12)
                            : Color.clear)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedMood == mood
                                ? Color.AccentColor.opacity(0.4)
                                : Color.AccentColor.opacity(0.1),
                                lineWidth: 1.5))
                        .scaleEffect(selectedMood == mood ? 1.05 : 1.0)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1))
    }

    // MARK: - Photo Picker
    private var photoPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PHOTO (OPTIONAL)")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)

            if let image = photoImage {
                ZStack(alignment: .topTrailing) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(12)

                    Button {
                        withAnimation {
                            photoImage = nil
                            photoData  = nil
                            selectedPhoto = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                    .padding(8)
                }
            } else {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16))
                        Text("ADD PHOTO")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .kerning(1.5)
                    }
                    .foregroundColor(Color.AccentColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.AccentColor.opacity(0.06))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.AccentColor.opacity(0.2),
                                style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])))
                }
                .onChange(of: selectedPhoto) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            photoData  = data
                            if let ui = UIImage(data: data) {
                                photoImage = Image(uiImage: ui)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1))
    }

    // MARK: - Text Editor
    private var textEditor: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("WRITE YOUR THOUGHTS...")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)

            TextEditor(text: $text)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .frame(minHeight: 150)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1))
    }

    // MARK: - Helpers
    private func loadExisting() {
        guard let entry = existingEntry else { return }
        text = entry.text ?? ""
        selectedMood = JournalMood(rawValue: entry.mood ?? "") ?? .happy
        if let data = entry.photoData, let ui = UIImage(data: data) {
            photoData  = data
            photoImage = Image(uiImage: ui)
        }
    }

    private func saveEntry() {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        if let entry = existingEntry {
            repo.updateEntry(entry, text: trimmed, mood: selectedMood.rawValue, photoData: photoData)
        } else {
            repo.addEntry(text: trimmed, mood: selectedMood.rawValue, photoData: photoData, tripID: tripObjectID)
        }

        onSave()
        dismiss()
    }
}

// MARK: - Journal Entry Row
private struct JournalRowView: View {
    let entry: JournalEntity
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack {
                Text(entry.mood ?? "😊")
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.entryDate?.formatted(date: .long, time: .omitted) ?? "")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                    Text(entry.entryDate?.formatted(date: .omitted, time: .shortened) ?? "")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                }

                Spacer()

                // Edit & Delete
                HStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                            .foregroundColor(Color.AccentColor)
                            .frame(width: 30, height: 30)
                            .background(Color.AccentColor.opacity(0.08))
                            .cornerRadius(8)
                    }
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                            .frame(width: 30, height: 30)
                            .background(Color(red: 1, green: 0.27, blue: 0.27).opacity(0.08))
                            .cornerRadius(8)
                    }
                }
            }

            // Photo
            if let data = entry.photoData, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .clipped()
                    .cornerRadius(10)
            }

            // Text
            Text(entry.text ?? "")
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.8))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1))
        .shadow(color: Color.AccentColor.opacity(0.05), radius: 6, y: 2)
    }
}

// MARK: - Main Journal View
struct JournalView: View {
    let tripName: String
    let tripObjectID: NSManagedObjectID

    @FetchRequest private var entries: FetchedResults<JournalEntity>
    @State private var showAddSheet    = false
    @State private var entryToEdit: JournalEntity? = nil
    @State private var entryToDelete: JournalEntity? = nil
    @State private var showDeleteAlert = false

    private let repo = JournalRepository()

    init(tripName: String, tripObjectID: NSManagedObjectID) {
        self.tripName      = tripName
        self.tripObjectID  = tripObjectID
        let context = PersistenceController.shared.context
        let trip = try? context.existingObject(with: tripObjectID) as? TripEntity
        self._entries = FetchRequest(
            entity: JournalEntity.entity(),
            sortDescriptors: [NSSortDescriptor(key: "entryDate", ascending: false)],
            predicate: NSPredicate(format: "trip == %@", trip ?? NSNull())
        )
    }

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            if entries.isEmpty {
                emptyState
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Stats
                        statsRow

                        ForEach(entries, id: \.journalId) { entry in
                            JournalRowView(entry: entry) {
                                entryToEdit = entry
                            } onDelete: {
                                entryToDelete = entry
                                showDeleteAlert = true
                            }
                            .transition(.scale.combined(with: .opacity))
                        }

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }

            // FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.BackgroundColor)
                            .frame(width: 56, height: 56)
                            .background(Color.AccentColor)
                            .clipShape(Circle())
                            .shadow(color: Color.AccentColor.opacity(0.4), radius: 10, y: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddSheet) {
            JournalEntrySheet(tripObjectID: tripObjectID) {
                showAddSheet = false
            }
        }
        .sheet(item: $entryToEdit) { entry in
            JournalEntrySheet(
                tripObjectID: tripObjectID,
                existingEntry: entry
            ) {
                entryToEdit = nil
            }
        }
        .alert("Delete Entry?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    repo.deleteEntry(entry)
                    entryToDelete = nil
                }
            }
            Button("Cancel", role: .cancel) { entryToDelete = nil }
        } message: {
            Text("This entry will be permanently deleted.")
        }
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 0) {
            statCell(value: "\(entries.count)", label: "ENTRIES")

            Rectangle()
                .fill(Color.AccentColor.opacity(0.1))
                .frame(width: 1, height: 36)

            // Most used mood
            let moodCounts = Dictionary(grouping: entries, by: { $0.mood ?? "" })
            let topMood = moodCounts.max(by: { $0.value.count < $1.value.count })?.key ?? "😊"
            statCell(value: topMood, label: "TOP MOOD")

            Rectangle()
                .fill(Color.AccentColor.opacity(0.1))
                .frame(width: 1, height: 36)

            let withPhotos = entries.filter { $0.photoData != nil }.count
            statCell(value: "\(withPhotos)", label: "PHOTOS")
        }
        .padding(.vertical, 16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.AccentColor.opacity(0.12), lineWidth: 1))
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .heavy, design: .monospaced))
                .foregroundColor(Color.AccentColor)
            Text(label)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.4))
                .kerning(1.5)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("📓")
                .font(.system(size: 60))
            Text("NO ENTRIES YET")
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .kerning(2)
            Text("Tap + to write your first journal entry")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.4))
                .multilineTextAlignment(.center)

            Button {
                showAddSheet = true
            } label: {
                Text("WRITE FIRST ENTRY")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .kerning(1.5)
                    .foregroundColor(Color.AccentColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.AccentColor.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
            }
        }
        .padding()
    }
}

