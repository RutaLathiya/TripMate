//
//  Registration.swift
//  TripMate
//
//  Created by iMac on 27/01/26.
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

/*
 
 struct RegistrationView: View {
 
     // MARK: - Dependencies
        @Environment(\.managedObjectContext) private var viewContext
        @Environment(\.colorScheme) private var colorScheme
        @EnvironmentObject var SessionVM: SessionViewModel
 
        // MARK: - ViewModels
        @StateObject private var viewModel   = RegistrationViewModel()
        @StateObject private var authVM      = AuthViewModel()
        @StateObject private var emailOTPVM  = EmailOTPViewModel()
        @StateObject private var googleRepo  = GoogleSignInViewModel()
 
        // MARK: - Local State
        @State private var showPhoneOTPSheet = false
        @State private var showError         = false
        @State private var errorMessage      = ""
 
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
 
                 // ✅ Email + VERIFY button-
                 HStack(spacing: 8) {
                     TextField("Enter your email", text: $viewModel.email)
                         .keyboardType(.emailAddress)
                         .autocapitalization(.none)
                         .padding()
                         .background(Color("ContainerColor"))
                         .cornerRadius(20)
                         .shadow(color: .gray.opacity(0.2), radius: 5)
                         .overlay(RoundedRectangle(cornerRadius: 20)
                             .stroke(
                                 emailOTPVM.isEmailVerified
                                 ? Color.green.opacity(0.6)
                                 : (colorScheme == .dark ? Color.BorderColor : Color.clear),
                                 lineWidth: emailOTPVM.isEmailVerified ? 2 : 5
                             ))
                         .disabled(googleRepo.isSignedIn) // disable if Google signed in
 
                     // Email VERIFY button
                     Button {
                         Task { await emailOTPVM.sendOTP(to: viewModel.email) }
                     } label: {
                         Group {
                             if emailOTPVM.isEmailVerified || googleRepo.isSignedIn {
                                 Image(systemName: "checkmark.circle.fill")
                                     .font(.system(size: 20))
                                     .foregroundColor(.green)
                             } else if emailOTPVM.isLoading {
                                 ProgressView().tint(.brown).frame(width: 20, height: 20)
                             } else {
                                 Text("VERIFY")
                                     .font(.system(size: 12, weight: .bold))
                                     .foregroundColor(.white)
                                     .padding(.horizontal, 14)
                                     .padding(.vertical, 14)
                                     .background(viewModel.email.contains("@")
                                                 ? Color.brown : Color.gray.opacity(0.4))
                                     .cornerRadius(20)
                             }
                         }
                     }
                     .disabled(
                         !viewModel.email.contains("@") ||
                         emailOTPVM.isEmailVerified ||
                         emailOTPVM.isLoading ||
                         googleRepo.isSignedIn
                     )
                 }
                 .padding(.horizontal, 30)
                 .padding(.top, 10)
 
                 // Email verified status
                 if emailOTPVM.isEmailVerified {
                     verifiedLabel("Email verified")
                 } else if googleRepo.isSignedIn {
                     verifiedLabel("Email verified via Google")
                 }
 
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
                             showPhoneOTPSheet = true
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
 
                     Button {
                         Task { await googleRepo.signIn(viewModel: viewModel) }
                     } label: {
                         HStack(spacing: 10) {
                             Image(systemName: "globe")
                                 .font(.system(size: 18))
                                 .foregroundColor(.brown)
                             Text(googleRepo.isSignedIn ? "✅ Signed in with Google" : "Sign Up with Google")
                                 .font(.headline)
                                 .foregroundColor(googleRepo.isSignedIn ? .green : .black)
                         }
                         .frame(maxWidth: .infinity).frame(height: 55)
                         .background(Color.accentColor.opacity(0.3))
                         .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.brown, lineWidth: 5))
                         .shadow(color: .brown.opacity(0.3), radius: 10)
                     }
                     .cornerRadius(20)
                     .padding(.top, 10)
                     .disabled(googleRepo.isSignedIn)
 
                     // Sign Up with Apple — disabled (needs paid account)
                     Button(action: {}) {
                         Text("Sign Up with Apple")
                             .font(.headline).foregroundColor(.white.opacity)
                             .frame(maxWidth: .infinity).frame(height: 55)
                             .background(Color.black.opacity)
                             .cornerRadius(20)
                     }
                     .disabled(true)
                 }
                 .padding(.horizontal, 30)
                 .padding(.top, 10)
 
                 HStack {
                     Text("Already have an account?").foregroundColor(Color.secondaryText)
                     Button(action: { SessionVM.showLogIn = true }) {
                         Text("Login").foregroundColor(.brown).fontWeight(.semibold)
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
 
         //        .sheet(isPresented: $showOTPSheet) {
         //            OTPSheetView(
         //                authVM: authVM,
         //                onVerified: { showOTPSheet = false }
         //            )
         //        }
 
 
         //        // Firebase auth error alert
         //        .alert("Verification Error", isPresented: Binding(
         //            get: { authVM.errorMessage != nil },
         //            set: { if !$0 { authVM.errorMessage = nil } }
         //        )) {
         //            Button("OK", role: .cancel) { authVM.errorMessage = nil }
         //        } message: {
         //            Text(authVM.errorMessage ?? "")
         //        }
 
         // ✅ Phone OTP Sheet
         .sheet(isPresented: $showPhoneOTPSheet) {
             OTPSheetView(authVM: authVM, onVerified: {
                 showPhoneOTPSheet = false })
         }
 
         // ✅ Email OTP Sheet
         .sheet(isPresented: $emailOTPVM.showOTPSheet) {
             EmailOTPSheetView(emailOTPVM: emailOTPVM)
         }
 
         // Error alerts
         .alert("Error", isPresented: $showError) {
             Button("OK", role: .cancel) { showError = false }
         } message: { Text(errorMessage) }
 
             .alert("Phone Error", isPresented: Binding(
                 get: { authVM.errorMessage != nil },
                 set: { if !$0 { authVM.errorMessage = nil } }
             )) {
                 Button("OK", role: .cancel) { authVM.errorMessage = nil }
             } message: { Text(authVM.errorMessage ?? "") }
 
             .alert("Email Error", isPresented: Binding(
                 get: { emailOTPVM.errorMessage != nil },
                 set: { if !$0 { emailOTPVM.errorMessage = nil } }
             )) {
                 Button("OK", role: .cancel) { emailOTPVM.errorMessage = nil }
             } message: { Text(emailOTPVM.errorMessage ?? "") }
 
             .alert("Google Error", isPresented: Binding(
                 get: { googleRepo.errorMessage != nil },
                 set: { if !$0 { googleRepo.errorMessage = nil } }
             )) {
                 Button("OK", role: .cancel) { googleRepo.errorMessage = nil }
             } message: { Text(googleRepo.errorMessage ?? "") }
     }
 }
     // MARK: - Verified Label
 private func verifiedLabel(_ text: String) -> some View {
     HStack(spacing: 4) {
         Image(systemName: "checkmark.circle.fill")
             .font(.system(size: 11))
             .foregroundColor(.green)
         Text(text)
             .font(.system(size: 11, design: .monospaced))
             .foregroundColor(.green)
     }
     .frame(maxWidth: .infinity, alignment: .leading)
     .padding(.horizontal, 34)
     }
 
 
 #Preview {
     RegistrationView()
         .environmentObject(SessionViewModel())
 }
 
   RegistrationView.swift
   TripMate
 

 */


struct RegistrationView: View {

    // MARK: - Dependencies
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var SessionVM: SessionViewModel

    // MARK: - ViewModels
    @StateObject private var vm          = RegistrationViewModel()
    @StateObject private var authVM      = AuthViewModel()
    @StateObject private var emailOTPVM  = EmailOTPViewModel()
    @StateObject private var googleVM    = GoogleSignInViewModel()

    // MARK: - Local State
    @State private var showPhoneOTPSheet = false
    @State private var showError         = false
    @State private var errorMessage      = ""

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    headerSection
                    nameFields
                    emailField
                    phoneField
                    passwordFields
                    registerButton
                    otherOptionsSection
                    alreadyHaveAccount
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showPhoneOTPSheet) {
            OTPSheetView(authVM: authVM, onVerified: { showPhoneOTPSheet = false })
        }
        .sheet(isPresented: $emailOTPVM.showOTPSheet) {
            EmailOTPSheetView(emailOTPVM: emailOTPVM)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        } message: { Text(errorMessage) }
        
        .alert("Phone Error", isPresented: Binding(
            get: { authVM.errorMessage != nil },
            set: { if !$0 { authVM.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { authVM.errorMessage = nil }
        } message: { Text(authVM.errorMessage ?? "") }
        
        .alert("Email Error", isPresented: Binding(
            get: { emailOTPVM.errorMessage != nil },
            set: { if !$0 { emailOTPVM.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { emailOTPVM.errorMessage = nil }
        } message: { Text(emailOTPVM.errorMessage ?? "") }
        
        .alert("Google Error", isPresented: Binding(
            get: { googleVM.errorMessage != nil },
            set: { if !$0 { googleVM.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { googleVM.errorMessage = nil }
        } message: { Text(googleVM.errorMessage ?? "") }
    }
}

// MARK: - Subviews
private extension RegistrationView {

    // MARK: Header
    var headerSection: some View {
        VStack(spacing: 10) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 7)

            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 85, height: 85)
                .foregroundColor(Color.brown)
                .padding(.bottom, 10)
        }
    }

    // MARK: Name Fields
    var nameFields: some View {
        HStack(spacing: 8) {
            TextField("First Name", text: $vm.firstName)
                .styledField(colorScheme: colorScheme)

            TextField("Last Name", text: $vm.lastName)
                .styledField(colorScheme: colorScheme)
        }
        .padding(.horizontal, 30)
    }

    // MARK: Email Field + VERIFY
    var emailField: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                TextField("Enter your email", text: $vm.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .styledField(
                        colorScheme: colorScheme,
                        isVerified: emailOTPVM.isEmailVerified || googleVM.isSignedIn
                    )
                    .disabled(googleVM.isSignedIn)

                verifyButton(
                    isVerified: emailOTPVM.isEmailVerified || googleVM.isSignedIn,
                    isLoading: emailOTPVM.isLoading,
                    isEnabled: vm.email.contains("@") &&
                               !emailOTPVM.isEmailVerified &&
                               !emailOTPVM.isLoading &&
                               !googleVM.isSignedIn
                ) {
                    Task { await emailOTPVM.sendOTP(to: vm.email) }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)

            if emailOTPVM.isEmailVerified {
                verifiedLabel("Email verified")
            } else if googleVM.isSignedIn {
                verifiedLabel("Email verified via Google")
            }
        }
    }

    // MARK: Phone Field + VERIFY
    var phoneField: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                TextField("Enter your Phone No", text: $vm.phoneNo)
                    .keyboardType(.phonePad)
                    .styledField(
                        colorScheme: colorScheme,
                        isVerified: authVM.isPhoneVerified
                    )

                verifyButton(
                    isVerified: authVM.isPhoneVerified,
                    isLoading: authVM.isLoading,
                    isEnabled: vm.phoneNo.count >= 10 &&
                               !authVM.isPhoneVerified &&
                               !authVM.isLoading
                ) {
                    authVM.phoneNumber = vm.phoneNo
                    authVM.countryCode = "+91"
                    DispatchQueue.main.async {
                        showPhoneOTPSheet = true
                        Task { await authVM.sendOTP() }
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)

            if authVM.isPhoneVerified {
                verifiedLabel("Phone number verified")
            }
        }
    }

    // MARK: Password Fields
    var passwordFields: some View {
        VStack(spacing: 10) {
            SecureField("Enter your password", text: $vm.password)
                .styledField(colorScheme: colorScheme)
                .padding(.horizontal, 30)
                .padding(.top, 10)

            SecureField("Confirm your password", text: $vm.confirmPassword)
                .styledField(colorScheme: colorScheme)
                .padding(.horizontal, 30)
                .padding(.top, 10)
        }
    }

    // MARK: Register Button
    var registerButton: some View {
        Button {
            guard emailOTPVM.isEmailVerified || googleVM.isSignedIn else {
                errorMessage = "Please verify your email first."
                showError = true
                return
            }
            guard authVM.isPhoneVerified else {
                errorMessage = "Please verify your phone number first."
                showError = true
                return
            }
            if vm.save(context: viewContext) {
                print("✅ Registration successful!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    SessionVM.showLogIn = true
                }
              }
//              else {
//                showError = true
//                errorMessage = "Registration failed. Email might already exist."
//            }
        } label: {
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
    }

    // MARK: Other Options
    var otherOptionsSection: some View {
        VStack(spacing: 8) {
            Text("Try Other Way")
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(Color.secondaryText)

            Button {
                Task { await googleVM.signIn(viewModel: vm) }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "globe").font(.system(size: 18)).foregroundColor(.brown)
                    Text(googleVM.isSignedIn ? "✅ Signed in with Google" : "Sign Up with Google")
                        .font(.headline)
                        .foregroundColor(googleVM.isSignedIn ? .green : .black)
                }
                .frame(maxWidth: .infinity).frame(height: 55)
                .background(Color.accentColor.opacity(0.3))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.brown, lineWidth: 5))
                .shadow(color: .brown.opacity(0.3), radius: 10)
            }
            .cornerRadius(20)
            .padding(.top, 10)
            .disabled(googleVM.isSignedIn)

            Button(action: {}) {
                Text("Sign Up with Apple")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity).frame(height: 55)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            .disabled(true)
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
    }

    // MARK: Already Have Account
    var alreadyHaveAccount: some View {
        HStack {
            Text("Already have an account?").foregroundColor(Color.secondaryText)
            Button { SessionVM.showLogIn = true } label: {
                Text("Login").foregroundColor(.brown).fontWeight(.semibold)
            }
        }
        .padding(.top, 10)
    }

    // MARK: - Reusable VERIFY Button
    func verifyButton(
        isVerified: Bool,
        isLoading: Bool,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            if isVerified {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            } else if isLoading {
                ProgressView().tint(.brown).frame(width: 20, height: 20)
            } else {
                Text("VERIFY")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                    .background(isEnabled ? Color.brown : Color.gray.opacity(0.4))
                    .cornerRadius(20)
            }
        }
        .disabled(!isEnabled || isVerified || isLoading)
    }

    // MARK: - Verified Label
    func verifiedLabel(_ text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 11))
                .foregroundColor(.green)
            Text(text)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 34)
    }
}

// MARK: - TextField Style Helper
private extension View {
    func styledField(colorScheme: ColorScheme, isVerified: Bool = false) -> some View {
        self
            .padding()
            .background(Color.ContainerColor)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.2), radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isVerified
                            ? Color.green.opacity(0.6)
                            : (colorScheme == .dark ? Color.BorderColor : Color.clear),
                        lineWidth: isVerified ? 2 : 5
                    )
            )
    }
}

// MARK: - Preview
#Preview {
    RegistrationView()
        .environmentObject(SessionViewModel())
}
