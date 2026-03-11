//import SwiftUI
//import PhotosUI
//
//struct EditProfileView: View {
//    
//    @EnvironmentObject var SessionVM: SessionViewModel
//    @Environment(\.dismiss) private var dismiss
//    
//    // Fields
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var email = ""
//    @State private var phone = ""
//    
//    // Profile pic
//    @State private var selectedImage: UIImage? = nil
//    @State private var selectedAvatar: String? = nil
//    @State private var photosItem: PhotosPickerItem? = nil
//    @State private var showPicOptions = false
//    @State private var showAvatarPicker = false
//    @State private var showCamera = false
//    @State private var showGallery = false
//
//    // Avatar options
//    private let avatars = ["😀","😎","🧑‍🚀","🧙","🦊","🐯","🦁","🐻","🐼","🦋","🌊","🏔️"]
//
//    var body: some View {
//        ZStack {
//            Color.BackgroundColor.ignoresSafeArea()
//            
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 24) {
//                    
//                    // ── Profile Picture ──────────────────
//                    Group {
//                        // Avatar or image
//                        if let image = selectedImage {
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 100, height: 100)
//                                .clipShape(Circle())
//                        } else if let avatar = selectedAvatar {
//                            Text(avatar)
//                                .font(.system(size: 60))
//                                .frame(width: 100, height: 100)
//                                .background(Color.AccentColor.opacity(0.1))
//                                .clipShape(Circle())
//                        } else {
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 100, height: 100)
//                                .foregroundColor(Color.AccentColor)
//                        }
//                    }
//                            .allowsHitTesting(false)
//                            .overlay(alignment: .bottomTrailing){
//                                
//                                // Edit badge
//                                Button {
//                                    showPicOptions = true
//                                } label:{
//                                    
//                                    Image(systemName: "pencil.circle.fill")
//                                        .font(.system(size: 24))
//                                        .foregroundColor(Color.AccentColor)
//                                        .background(Color.BackgroundColor)
//                                        .clipShape(Circle())
//                            }
//                    }
//                    .padding(.top, 100)
//                    
//                    // ── Fields ───────────────────────────
//                    VStack(spacing: 14) {
//                        editField(icon: "person", placeholder: "First Name", text: $firstName)
//                        editField(icon: "person", placeholder: "Last Name", text: $lastName)
//                        editField(icon: "envelope", placeholder: "Email", text: $email)
//                            .keyboardType(.emailAddress)
//                        editField(icon: "phone", placeholder: "Phone Number", text: $phone)
//                            .keyboardType(.phonePad)
//                    }
//                    .padding(.horizontal, 20)
//                    
//                    // ── Save Button ───────────────────────
//                    Button {
//                        saveProfile()
//                        dismiss()
//                    } label: {
//                        Text("SAVE CHANGES")
//                            .font(.system(size: 14, weight: .bold, design: .monospaced))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 16)
//                            .background(Color.AccentColor)
//                            .cornerRadius(14)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 30)
//                }
//            }
//        }
//        //.navigationTitle("Edit Profile")
//        //.navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        
//        
//        // ── Profile Pic Action Sheet ──────────────
//        .confirmationDialog("Change Profile Picture", isPresented: $showPicOptions, titleVisibility: .visible) {
//            Button("Choose Avatar") {
//                showAvatarPicker = true
//            }
//            Button("Camera") {
//                showCamera = true
//            }
//            Button("Gallery") {
//                showGallery = true
//            }
//            Button("Remove Photo", role: .destructive) {
//                    selectedImage = nil
//                    selectedAvatar = nil
//            }
//            Button("Cancel", role: .cancel) { }
//        }
//        
//        // ── Avatar Picker Sheet ───────────────────
//        .sheet(isPresented: $showAvatarPicker) {
//            avatarPickerSheet
//        }
//        
//        // ── Camera ────────────────────────────────
//        .fullScreenCover(isPresented: $showCamera) {
//            CameraPickerView(image: $selectedImage)
//                .ignoresSafeArea()
//        }
//        
//        // ── Gallery ───────────────────────────────
//        .photosPicker(isPresented: $showGallery, selection: $photosItem, matching: .images)
//        .onChange(of: photosItem) { _, newItem in
//            Task {
//                if let data = try? await newItem?.loadTransferable(type: Data.self),
//                   let uiImage = UIImage(data: data) {
//                    selectedImage = uiImage
//                    selectedAvatar = nil
//                }
//            }
//        }
//    }
//    
//    // ── Avatar Picker UI ──────────────────────────
//    private var avatarPickerSheet: some View {
//        ZStack {
//            Color.BackgroundColor.ignoresSafeArea()
//            VStack(spacing: 20) {
//                Text("CHOOSE AVATAR")
//                    .font(.system(size: 13, weight: .bold, design: .monospaced))
//                    .foregroundColor(Color.AccentColor)
//                    .kerning(2)
//                    .padding(.top, 20)
//                
//                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 16) {
//                    ForEach(avatars, id: \.self) { avatar in
//                        Button {
//                            selectedAvatar = avatar
//                            selectedImage = nil
//                            showAvatarPicker = false
//                        } label: {
//                            Text(avatar)
//                                .font(.system(size: 40))
//                                .frame(width: 70, height: 70)
//                                .background(
//                                    selectedAvatar == avatar
//                                    ? Color.AccentColor.opacity(0.2)
//                                    : Color.AccentColor.opacity(0.07)
//                                )
//                                .cornerRadius(14)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 14)
//                                        .stroke(
//                                            selectedAvatar == avatar
//                                            ? Color.AccentColor : Color.clear,
//                                            lineWidth: 2
//                                        )
//                                )
//                        }
//                    }
//                }
//                .padding(.horizontal, 20)
//                Spacer()
//            }
//        }
//        .presentationDetents([.medium, .large])
//    }
//    
//    // ── Field Builder ─────────────────────────────
//    private func editField(icon: String, placeholder: String, text: Binding<String>) -> some View {
//        HStack(spacing: 12) {
//            Image(systemName: icon)
//                .foregroundColor(Color.AccentColor)
//                .frame(width: 20)
//            TextField(placeholder, text: text)
//                .font(.system(size: 14, design: .monospaced))
//                .foregroundColor(Color.AccentColor)
//                .autocorrectionDisabled()
//        }
//        .padding(.horizontal, 14)
//        .padding(.vertical, 14)
//        .background(Color.BackgroundColor)
//        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.AccentColor.opacity(0.4), lineWidth: 1)
//        )
//    }
//    
//    // ── Save Logic ────────────────────────────────
//    private func saveProfile() {
//        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
//        // connect to your CoreData/backend here
//        print("Saving: \(fullName), \(email), \(phone)")
//    }
//}
//
//// ── Camera Picker ─────────────────────────────────
//struct CameraPickerView: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Environment(\.dismiss) private var dismiss
//    
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: CameraPickerView
//        init(_ parent: CameraPickerView) { self.parent = parent }
//        
//        func imagePickerController(_ picker: UIImagePickerController,
//                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
//            }
//            parent.dismiss()
//        }
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.dismiss()
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        EditProfileView()
//    }
//    .environmentObject(SessionViewModel())
//}
//

import SwiftUI
import PhotosUI
import CoreData

struct EditProfileView: View {
    
    @EnvironmentObject var SessionVM: SessionViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var profileImageManager: ProfileImageManager
    
    // Fields
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    
    // Profile pic
    @State private var selectedImage: UIImage? = nil
    @State private var selectedAvatar: String? = nil
    @State private var photosItem: PhotosPickerItem? = nil
    @State private var showPicOptions = false
    @State private var showAvatarPicker = false
    @State private var showCamera = false
    @State private var showGallery = false

    private let avatars = ["😀","😎","🧑‍🚀","🧙","🦊","🐯","🦁","🐻","🐼","🦋","🌊","🏔️"]

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // ── Profile Picture ──────────────────
                    Group {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else if let avatar = selectedAvatar {
                            Text(avatar)
                                .font(.system(size: 60))
                                .frame(width: 100, height: 100)
                                .background(Color.AccentColor.opacity(0.1))
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.AccentColor)
                        }
                    }
                    .allowsHitTesting(false)
                    .overlay(alignment: .bottomTrailing) {
                        Button { showPicOptions = true } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color.AccentColor)
                                .background(Color.BackgroundColor)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 20)
                    
                    // ── Fields ───────────────────────────
                    VStack(spacing: 14) {
                        editField(icon: "person", placeholder: "First Name", text: $firstName)
                        editField(icon: "person", placeholder: "Last Name", text: $lastName)
                        editField(icon: "envelope", placeholder: "Email", text: $email)
                            .keyboardType(.emailAddress)
                        editField(icon: "phone", placeholder: "Phone Number", text: $phone)
                            .keyboardType(.phonePad)
                    }
                    .padding(.horizontal, 20)
                    
                    // ── Save Button ───────────────────────
                    Button {
                        saveProfile()
                        dismiss()
                    } label: {
                        Text("SAVE CHANGES")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.AccentColor)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                    }
                    .foregroundColor(Color.AccentColor)
                }
            }
        }
        .onAppear { loadProfile() }  // 👈 load existing data on open
        .confirmationDialog("Change Profile Picture", isPresented: $showPicOptions, titleVisibility: .visible) {
            Button("Choose Avatar") { showAvatarPicker = true }
            Button("Camera") { showCamera = true }
            Button("Gallery") { showGallery = true }
            Button("Remove Photo", role: .destructive) {
                selectedImage = nil
                selectedAvatar = nil
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showAvatarPicker) { avatarPickerSheet }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPickerView(image: $selectedImage).ignoresSafeArea()
        }
        .photosPicker(isPresented: $showGallery, selection: $photosItem, matching: .images)
        .onChange(of: photosItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    selectedAvatar = nil
                }
            }
        }
    }
    
    // MARK: - Load Profile from CoreData
    private func loadProfile() {
        guard let uid = SessionVM.currentUserUID else { return }
        
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid == %@", uid as any CVarArg as CVarArg)
        
        if let user = try? context.fetch(request).first {
            let parts = (user.name ?? "").components(separatedBy: " ")
            firstName = parts.first ?? ""
            lastName = parts.dropFirst().joined(separator: " ")
            email = user.email ?? ""
            phone = user.phoneNo ?? ""
            
            // Load profile pic
            if let picData = user.profilePic {
                if let avatarString = String(data: picData, encoding: .utf8),
                               avatarString.count <= 4 {  // emojis are short
                                selectedAvatar = avatarString  // 👈 restore emoji
                                selectedImage = nil
                            } else {
                                // Otherwise load as image
                                selectedImage = UIImage(data: picData)
                                selectedAvatar = nil
                            }
            }
        }
    }
    
    // MARK: - Save Profile to CoreData
    private func saveProfile() {
        guard let uid = SessionVM.currentUserUID else { return }
        
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid == %@", uid as CVarArg)
        
        if let user = try? context.fetch(request).first {
            // Save name
            let fullName = "\(firstName) \(lastName)"
                .trimmingCharacters(in: .whitespaces)
            user.name = fullName
            user.email = email
            user.phoneNo = phone
            
            // Save profile pic
            if let image = selectedImage {
                // compress to save space
                user.profilePic = image.jpegData(compressionQuality: 0.7)
            } else if selectedAvatar == nil {
                user.profilePic = nil  // removed
            }
            
            // Save avatar as name prefix if selected
            if let avatar = selectedAvatar {
                user.profilePic = avatar.data(using: .utf8)
            }
            
            do {
                try context.save()
                if let uid = SessionVM.currentUserUID {
                       profileImageManager.load(uid: uid, context: context)
                   }
                print("✅ Profile saved successfully")
            } catch {
                print("❌ Failed to save profile: \(error)")
            }
        }
    }
    
    // MARK: - Avatar Sheet
    private var avatarPickerSheet: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("CHOOSE AVATAR")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .kerning(2)
                    .padding(.top, 20)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 16) {
                    ForEach(avatars, id: \.self) { avatar in
                        Button {
                            selectedAvatar = avatar
                            selectedImage = nil
                            showAvatarPicker = false
                        } label: {
                            Text(avatar)
                                .font(.system(size: 40))
                                .frame(width: 70, height: 70)
                                .background(
                                    selectedAvatar == avatar
                                    ? Color.AccentColor.opacity(0.2)
                                    : Color.AccentColor.opacity(0.07)
                                )
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            selectedAvatar == avatar
                                            ? Color.AccentColor : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    // MARK: - Field Builder
    private func editField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.AccentColor)
                .frame(width: 20)
            TextField(placeholder, text: text)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color.BackgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.AccentColor.opacity(0.4), lineWidth: 1)
        )
    }
}
#Preview {
    EditProfileView()
}
// MARK: - Camera Picker
struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView
        init(_ parent: CameraPickerView) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
