////
////  Registration.swift
////  TripMate
////
////  Created by iMac on 27/01/26.
////
//
//
//
//import SwiftUI
//
//struct RegistrationView: View {
//    
//    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.colorScheme) private var colorScheme
//    @EnvironmentObject var SessionVM: SessionViewModel
//    @StateObject private var viewModel = RegistrationViewModel()
//    @State private var showError = false
//    @State private var errorMessage = ""
//    
//    var body: some View {
//            ZStack {
//                // Background
//                Color.BackgroundColor
//                    .ignoresSafeArea()
//                
//                VStack(spacing: 5) {
//                    
//                    // Title
//                    Text("Create Account")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .padding(.bottom, 7)
//                    
//                    // Profile Image Placeholder
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 85, height: 85)
//                        .foregroundColor(Color.brown)
//                        .padding(.bottom, 10)
//                    
//                    // Full Name Field
//                    HStack(spacing: 8) {
////                        Text("Name")
////                            .font(.headline)
////                            .foregroundColor(.gray)
//                        
//                        TextField("First Name", text: $viewModel.firstName)
//                            .padding()
//                            .background(Color.ContainerColor)
//                            //.foregroundColor(.primary)
//                            .cornerRadius(20)
//                            .shadow(color: .gray.opacity(0.2), radius: 5)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
//                                )
//            
//                            TextField("Last Name", text: $viewModel.lastName)
//                                .padding()
//                                .background(Color.ContainerColor)
//                                //.foregroundColor(.primary)
//                                .cornerRadius(20)
//                                .shadow(color: .gray.opacity(0.2), radius: 5)
//                                .overlay(
//                                        RoundedRectangle(cornerRadius: 20)
//                                            .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
//                                )
//
//                    }
//                    .padding(.horizontal, 30)
//                   
//                    // Email Field
//                    VStack(alignment: .leading, spacing: 8) {
////                        Text("Email")
////                            .font(.headline)
////                            .foregroundColor(.gray)
//                        
//                        TextField("Enter your email", text: $viewModel.email)
//                            .keyboardType(.emailAddress)
//                            .autocapitalization(.none)
//                            .padding()
//                            .background(Color("ContainerColor"))
//                            .cornerRadius(20)
//                            .shadow(color: .gray.opacity(0.2), radius: 5)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)                                )
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 10)
//                    
//                    
//                    //PhoneNo. Field
//                    // Email Field
//                    VStack(alignment: .leading, spacing: 8) {
////                        Text("Email")
////                            .font(.headline)
////                            .foregroundColor(.gray)
//                        
//                        TextField("Enter your PhoneNo", text: $viewModel.phoneNo)
//                            .keyboardType(.emailAddress)
//                            .autocapitalization(.none)
//                            .padding()
//                            .background(Color("ContainerColor"))
//                            .cornerRadius(20)
//                            .shadow(color: .gray.opacity(0.2), radius: 5)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
//                                )
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 10)
//                    
//                    // Password Field
//                    VStack(alignment: .leading, spacing: 8) {
////                        Text("Password")
////                            .font(.headline)
////                            .foregroundColor(.gray)
//                        
//                        SecureField("Enter your password", text: $viewModel.password)
//                            .padding()
//                            .background(Color.ContainerColor)
//                            .cornerRadius(20)
//                            .shadow(color: .gray.opacity(0.2), radius: 5)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
//                                )
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 10)
//                    
//                    // Confirm Password Field
//                    VStack(alignment: .leading, spacing: 8) {
////                        Text("Confirm Password")
////                            .font(.headline)
////                            .foregroundColor(.gray)
//                        
//                        SecureField("Confirm your password", text: $viewModel.confirmPassword)
//                            .padding()
//                            .background(Color.ContainerColor)
//                            .cornerRadius(20)
//                            .shadow(color: .gray.opacity(0.2), radius: 5)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
//                                )
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 10)
//                    // Register Button
//                    Button(action: {
//                        if viewModel.save(context: viewContext){
//                            print("✅ Registration successful!")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                //SessionVM.login()
//                                SessionVM.showLogIn = true
//                            }
//                        }else {
//                            // Show error
//                            showError = true
//                            errorMessage = "Registration failed. Email might already exist."
//                        }
//                    })
//                    {
//                        Text("Register")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 55)
//                        .background(Color.brown)
//                        .cornerRadius(20)
//                        .shadow(color: .brown.opacity(0.3), radius: 10)
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 20)
//                    
//                    
//                    VStack(alignment: .leading, spacing: 8){
//                            Text("Try Other Way")
//                            .frame(maxWidth: .infinity, alignment: .center)
//                                .foregroundColor(Color.secondaryText)
//                        Button(action: {},
//                               label: {
//                            Text("Sign Up with Google")
//                                .font(.headline)
//                                .foregroundColor(.black)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 55)
//                                
//                                .background(Color.accentColor.opacity(0.3))
//                                .overlay(
//                                        RoundedRectangle(cornerRadius: 20)
//                                            .stroke(Color.brown, lineWidth: 5)
//                                    )
//                                .shadow(color: .brown.opacity(0.3), radius: 10)
//                        })
//                        .cornerRadius(20)
//                        .padding(.top, 10)
//                        Button(action: {},
//                               label: {
//                            Text("Sign Up with Apple")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 55)
//                                .background(Color.black)
//                                .cornerRadius(20)
//                                .shadow(color: .brown.opacity(0.3), radius: 10)
//                        })
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 10)
//                    // Already have account
//                    HStack {
//                        Text("Already have an account?")
//                            .foregroundColor(Color.secondaryText)
//                        
//                        Button(action: {
//                            SessionVM.showLogIn = true
//                            
//                        }) {
//                            Text("Login")
//                                .foregroundColor(.brown)
//                                .fontWeight(.semibold)
//                            
//                        }
//                        
//                    }
//                    
//                    .padding(.top, 10)
//                    
//                    //Spacer()
//                }
//                .padding(.top, 20)
//            }
//        }
//    }
//
//#Preview {
//    RegistrationView()
//        .environmentObject(SessionViewModel())
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////import SwiftUI
////
////struct Registration: View {
////    @State public var  mail: String = ""
////    @State public var  username: String = ""
////    @State public var  password: String = ""
////    
////    var body: some View {
////        NavigationView{
////            VStack{
////                Text("Registor")
////                    .font(.title)
////                Form{
////                    TextField("Enter Your E-mail Hear", text: $mail)
////                        .frame(maxWidth: .infinity)
////                        .frame(height: 55)
////                        .background(Color.gray)
////                        .padding(.horizontal)
////                    //.cornerRadius(10)
////                    TextField("Enter Your UserName", text: $username)
////                        .frame(maxWidth: .infinity)
////                        .frame(height: 55)
////                        .background(Color.gray)
////                        .padding(.horizontal)
////                    TextField("Enter Your Password", text: $password)
////                        .frame(maxWidth: .infinity)
////                        .frame(height: 55)
////                        .background(Color.gray)
////                        .padding(.horizontal)
////                    TextField("Conform Your Password", text: $password)
////                        .frame(maxWidth: .infinity)
////                        .frame(height: 55)
////                        .background(Color.gray)
////                        .padding(.horizontal)
////                    
////                    Button(
////                        action: {
////                           
////                        },
////                        label: {
////                            Text("registor")
////                                .frame(maxWidth: .infinity)
////                                .frame(height: 35)
////                                .cornerRadius(10)
////                                .background(Color.accentColor)
////                                .foregroundColor(.white)
////                        })
////                }
////            }
////        }
////    }
////}
////
////#Preview {
////    Registration()
////}
//
//
//
//
//
////
////import SwiftUI
////
////struct LoginView: View {
////    @EnvironmentObject var authManager: AuthenticationManager
////    @Environment(\.dismiss) var dismiss
////    
////    @State private var username = ""
////    @State private var password = ""
////    @State private var showAlert = false
////    @State private var alertMessage = ""
////    
////    var body: some View {
////        NavigationStack {
////            ScrollView {
////                VStack(spacing: 30) {
////                    // Header
////                    VStack(spacing: 10) {
////                        Image(systemName: "person.crop.circle.fill")
////                            .font(.system(size: 70))
////                            .foregroundStyle(.blue.gradient)
////                            .padding(.top, 60)
////                        
////                        Text("Welcome Back")
////                            .font(.largeTitle)
////                            .fontWeight(.bold)
////                        
////                        Text("Sign in to continue your journey")
////                            .font(.subheadline)
////                            .foregroundColor(.secondary)
////                    }
////                    .padding(.bottom, 20)
////                    
////                    // Login Form
////                    VStack(spacing: 16) {
////                        CustomTextField(
////                            icon: "person.fill",
////                            placeholder: "Username",
////                            text: $username
////                        )
////                        
////                        CustomSecureField(
////                            icon: "lock.fill",
////                            placeholder: "Password",
////                            text: $password
////                        )
////                        
////                        // Forgot Password
////                        HStack {
////                            Spacer()
////                            Button("Forgot Password?") {
////                                // TODO: Forgot password
////                            }
////                            .font(.subheadline)
////                            .foregroundColor(.blue)
////                        }
////                    }
////                    .padding(.horizontal)
////                    
////                    // Login Button
////                    Button(action: loginUser) {
////                        HStack {
////                            Text("Sign In")
////                                .fontWeight(.semibold)
////                            Image(systemName: "arrow.right")
////                        }
////                        .frame(maxWidth: .infinity)
////                        .padding()
////                        .background(Color.blue.gradient)
////                        .foregroundColor(.white)
////                        .cornerRadius(15)
////                    }
////                    .padding(.horizontal)
////                    .padding(.top, 10)
////                    
////                    Spacer()
////                }
////            }
////            .background(Color(.systemGroupedBackground))
////            .toolbar {
////                ToolbarItem(placement: .navigationBarLeading) {
////                    Button(action: { dismiss() }) {
////                        HStack(spacing: 4) {
////                            Image(systemName: "chevron.left")
////                            Text("Back")
////                        }
////                    }
////                }
////            }
////            .alert("Login", isPresented: $showAlert) {
////                Button("OK", role: .cancel) { }
////            } message: {
////                Text(alertMessage)
////            }
////        }
////    }
////    
////    func loginUser() {
////        guard !username.isEmpty else {
////            alertMessage = "Please enter username"
////            showAlert = true
////            return
////        }
////        
////        guard !password.isEmpty else {
////            alertMessage = "Please enter password"
////            showAlert = true
////            return
////        }
////        
////        let savedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
////        
////        if savedUsername == username {
////            authManager.loginUser()
////            dismiss()
////        } else {
////            alertMessage = "Invalid username or password"
////            showAlert = true
////        }
////    }
////}
////
////#Preview {
////    LoginView()
////        .environmentObject(AuthenticationManager())
////}





import SwiftUI

struct RegistrationView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var SessionVM: SessionViewModel
    @StateObject private var viewModel = RegistrationViewModel()

    // ✅ OTP state
    @StateObject private var authVM = AuthViewModel()
    @State private var showOTPSheet = false

    @State private var showError    = false
    @State private var errorMessage = ""
    

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            VStack(spacing: 5) {

                // Title
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 7)

                // Profile Image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85, height: 85)
                    .foregroundColor(Color.brown)
                    .padding(.bottom, 10)

                // First & Last Name
                HStack(spacing: 8) {
                    TextField("First Name", text: $viewModel.firstName)
                        .padding()
                        .background(Color.ContainerColor)
                        .cornerRadius(20)
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
                        )

                    TextField("Last Name", text: $viewModel.lastName)
                        .padding()
                        .background(Color.ContainerColor)
                        .cornerRadius(20)
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
                        )
                }
                .padding(.horizontal, 30)

                // Email
                TextField("Enter your email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color("ContainerColor"))
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
                    )
                    .padding(.horizontal, 30)
                    .padding(.top, 10)

                // ✅ Phone Number + VERIFY button inline
                HStack(spacing: 8) {
                    TextField("Enter your Phone No", text: $viewModel.phoneNo)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color("ContainerColor"))
                        .cornerRadius(20)
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    authVM.isPhoneVerified
                                        ? Color.green.opacity(0.6)
                                        : (colorScheme == .dark ? Color.BorderColor : Color.clear),
                                    lineWidth: authVM.isPhoneVerified ? 2 : 5
                                )
                        )

                    // ✅ VERIFY button — shows green tick when verified
                    Button {
                        // Sync phone from registration form to authVM
                        authVM.phoneNumber = viewModel.phoneNo
                        authVM.countryCode = "+91"
                        DispatchQueue.main.async {
                            showOTPSheet = true
                            Task { await authVM.sendOTP() }
                        }
                    } label: {
                        Group {
                            if authVM.isPhoneVerified {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                            } else if authVM.isLoading {
                                ProgressView()
                                    .tint(.brown)
                                    .frame(width: 20, height: 20)
                            } else {
                                Text("VERIFY")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 14)
                                    .background(viewModel.phoneNo.count >= 10 ? Color.brown : Color.gray.opacity(0.4))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .disabled(viewModel.phoneNo.count < 10 || authVM.isPhoneVerified || authVM.isLoading)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)

                // ✅ Small status text under phone field
                if authVM.isPhoneVerified {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.green)
                        Text("Phone number verified")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 34)
                }

                // Password
                SecureField("Enter your password", text: $viewModel.password)
                    .padding()
                    .background(Color.ContainerColor)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
                    )
                    .padding(.horizontal, 30)
                    .padding(.top, 10)

                // Confirm Password
                SecureField("Confirm your password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.ContainerColor)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
                    )
                    .padding(.horizontal, 30)
                    .padding(.top, 10)

                // Register Button
                Button(action: {
                    // ✅ Optional: block registration if phone not verified
                    guard authVM.isPhoneVerified else {
                        errorMessage = "Please verify your phone number first."
                        showError = true
                        return
                    }
                    if viewModel.save(context: viewContext) {
                        print("✅ Registration successful!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            SessionVM.showLogIn = true
                        }
                    } else {
                        showError = true
                        errorMessage = "Registration failed. Email might already exist."
                    }
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.brown)
                        .cornerRadius(20)
                        .shadow(color: .brown.opacity(0.3), radius: 10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)

                // Other sign up options
                VStack(alignment: .leading, spacing: 8) {
                    Text("Try Other Way")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color.secondaryText)

                    Button(action: {}) {
                        Text("Sign Up with Google")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.accentColor.opacity(0.3))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.brown, lineWidth: 5))
                            .shadow(color: .brown.opacity(0.3), radius: 10)
                    }
                    .cornerRadius(20)
                    .padding(.top, 10)

                    Button(action: {}) {
                        Text("Sign Up with Apple")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.black)
                            .cornerRadius(20)
                            .shadow(color: .brown.opacity(0.3), radius: 10)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)

                // Already have account
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(Color.secondaryText)
                    Button(action: { SessionVM.showLogIn = true }) {
                        Text("Login")
                            .foregroundColor(.brown)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.top, 10)
            }
            .padding(.top, 20)
        }
        // ✅ OTP Sheet — appears over registration screen
//        .sheet(isPresented: $showOTPSheet) {
//            OTPSheetView(authVM: authVM, onVerified: {
//                showOTPSheet = false
//            })
//        }
        
        .sheet(isPresented: $showOTPSheet) {
            OTPSheetView(
                authVM: authVM,
                onVerified: { showOTPSheet = false }
            )
        }
        
        // Error alert
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        } message: {
            Text(errorMessage)
        }
        // Firebase auth error alert
        .alert("Verification Error", isPresented: Binding(
            get: { authVM.errorMessage != nil },
            set: { if !$0 { authVM.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { authVM.errorMessage = nil }
        } message: {
            Text(authVM.errorMessage ?? "")
        }
    }
}

// MARK: - OTP Sheet (shown over registration screen)
// MARK: - OTP Sheet (6 visual boxes, works on iPad)
struct OTPSheetView: View {

    @ObservedObject var authVM: AuthViewModel
    var onVerified: () -> Void
    @FocusState private var isOTPFocused: Bool

    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()

            VStack(spacing: 28) {

                // Handle bar
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 16)

                // Header
                VStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.brown)
                    Text("Verify Phone")
                        .font(.title2).fontWeight(.bold)
                    //Text("Enter the 6-digit code sent to\n\(authVM.countryCode)\(authVM.phoneNumber)")
                    VStack(spacing: 4) {
                        Text("Enter the 6-digit code sent to")
                        Text("\(authVM.countryCode)\(authVM.phoneNumber)")
                            .fontWeight(.semibold)
                            .foregroundColor(.brown)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                }

                // ✅ 6 visual boxes over one hidden real TextField
                ZStack {
                    // Real TextField — invisible but receives input
                    TextField("", text: $authVM.otpCode)
                        .keyboardType(.numberPad)
                        .focused($isOTPFocused)
                        .foregroundColor(.clear)
                        .tint(.clear)
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                        .onChange(of: authVM.otpCode) {
                            // Only allow digits, max 6
                            let filtered = authVM.otpCode.filter { $0.isNumber }
                            if authVM.otpCode != filtered {
                                authVM.otpCode = filtered
                            }
                            if authVM.otpCode.count > 6 {
                                authVM.otpCode = String(authVM.otpCode.prefix(6))
                            }
                        }

                    // 6 Visual boxes
                    HStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            let digit = index < authVM.otpCode.count
                                ? String(authVM.otpCode[authVM.otpCode.index(authVM.otpCode.startIndex, offsetBy: index)])
                                : ""
                            let isCurrent = index == authVM.otpCode.count

                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.ContainerColor)
                                    .frame(width: 46, height: 56)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                isCurrent && isOTPFocused
                                                    ? Color.brown
                                                    : (!digit.isEmpty ? Color.brown.opacity(0.5) : Color.gray.opacity(0.3)),
                                                lineWidth: isCurrent && isOTPFocused ? 2 : 1.5
                                            )
                                    )

                                if digit.isEmpty && isCurrent && isOTPFocused {
                                    // Blinking cursor
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(Color.brown)
                                        .frame(width: 2, height: 24)
                                } else {
                                    Text(digit)
                                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                                        .foregroundColor(.brown)
                                }
                            }
                        }
                    }
                }
                // Tap anywhere on boxes to open keyboard
                .onTapGesture { isOTPFocused = true }
                .onAppear { isOTPFocused = true }

                // Verify button
                Button {
                    Task {
                        await authVM.verifyOTP()
                        if authVM.isPhoneVerified {
                            onVerified()
                        }
                    }
                } label: {
                    ZStack {
                        if authVM.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("VERIFY")
                                .font(.headline).foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity).frame(height: 52)
                    .background(authVM.canVerifyOTP ? Color.brown : Color.gray.opacity(0.3))
                    .cornerRadius(20)
                }
                .disabled(!authVM.canVerifyOTP || authVM.isLoading)
                .padding(.horizontal, 30)

                // Resend
                Button {
                    authVM.otpCode = ""
                    Task { await authVM.resendOTP() }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise").font(.system(size: 12))
                        Text("Resend OTP").font(.subheadline)
                    }
                    .foregroundColor(.brown.opacity(0.7))
                }

                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    RegistrationView()
        .environmentObject(SessionViewModel())
}
