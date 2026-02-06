//
//  Registration.swift
//  TripMate
//
//  Created by iMac on 27/01/26.
//



import SwiftUI

struct RegistrationView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var navigateToLogin: Bool = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background
                Color.theme.accent.opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Title
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    // Profile Image Placeholder
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.brown)
                        .padding(.bottom, 20)
                    
                    // Full Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        TextField("Enter your full name", text: $viewModel.name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    .padding(.horizontal, 30)
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        TextField("Enter your email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    .padding(.horizontal, 30)
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        SecureField("Enter your password", text: $viewModel.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    .padding(.horizontal, 30)
                    
                    // Confirm Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        SecureField("Confirm your password", text: $viewModel.confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    .padding(.horizontal, 30)
                    
                    // Register Button
                    Button(action: {
                        if viewModel.save(context: viewContext){
                            print("✅ Registration successful!")
                            navigateToLogin = true
                        }else {
                            // Show error
                            showError = true
                            errorMessage = "Registration failed. Email might already exist."
                        }
                    })
                    {
                        Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.brown)
                        .cornerRadius(10)
                        .shadow(color: .brown.opacity(0.3), radius: 10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    // Already have account
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(Color.secondaryText)
                        
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            Text("Login")
                                .foregroundColor(.brown)
                                .fontWeight(.semibold)
                            
                        }
                        .navigationDestination(isPresented: $navigateToLogin) {
                            LogIn()
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    RegistrationView()
}















//import SwiftUI
//
//struct Registration: View {
//    @State public var  mail: String = ""
//    @State public var  username: String = ""
//    @State public var  password: String = ""
//    
//    var body: some View {
//        NavigationView{
//            VStack{
//                Text("Registor")
//                    .font(.title)
//                Form{
//                    TextField("Enter Your E-mail Hear", text: $mail)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 55)
//                        .background(Color.gray)
//                        .padding(.horizontal)
//                    //.cornerRadius(10)
//                    TextField("Enter Your UserName", text: $username)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 55)
//                        .background(Color.gray)
//                        .padding(.horizontal)
//                    TextField("Enter Your Password", text: $password)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 55)
//                        .background(Color.gray)
//                        .padding(.horizontal)
//                    TextField("Conform Your Password", text: $password)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 55)
//                        .background(Color.gray)
//                        .padding(.horizontal)
//                    
//                    Button(
//                        action: {
//                           
//                        },
//                        label: {
//                            Text("registor")
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 35)
//                                .cornerRadius(10)
//                                .background(Color.accentColor)
//                                .foregroundColor(.white)
//                        })
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    Registration()
//}





//
//import SwiftUI
//
//struct LoginView: View {
//    @EnvironmentObject var authManager: AuthenticationManager
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var username = ""
//    @State private var password = ""
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 30) {
//                    // Header
//                    VStack(spacing: 10) {
//                        Image(systemName: "person.crop.circle.fill")
//                            .font(.system(size: 70))
//                            .foregroundStyle(.blue.gradient)
//                            .padding(.top, 60)
//                        
//                        Text("Welcome Back")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                        
//                        Text("Sign in to continue your journey")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.bottom, 20)
//                    
//                    // Login Form
//                    VStack(spacing: 16) {
//                        CustomTextField(
//                            icon: "person.fill",
//                            placeholder: "Username",
//                            text: $username
//                        )
//                        
//                        CustomSecureField(
//                            icon: "lock.fill",
//                            placeholder: "Password",
//                            text: $password
//                        )
//                        
//                        // Forgot Password
//                        HStack {
//                            Spacer()
//                            Button("Forgot Password?") {
//                                // TODO: Forgot password
//                            }
//                            .font(.subheadline)
//                            .foregroundColor(.blue)
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    // Login Button
//                    Button(action: loginUser) {
//                        HStack {
//                            Text("Sign In")
//                                .fontWeight(.semibold)
//                            Image(systemName: "arrow.right")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue.gradient)
//                        .foregroundColor(.white)
//                        .cornerRadius(15)
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 10)
//                    
//                    Spacer()
//                }
//            }
//            .background(Color(.systemGroupedBackground))
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { dismiss() }) {
//                        HStack(spacing: 4) {
//                            Image(systemName: "chevron.left")
//                            Text("Back")
//                        }
//                    }
//                }
//            }
//            .alert("Login", isPresented: $showAlert) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                Text(alertMessage)
//            }
//        }
//    }
//    
//    func loginUser() {
//        guard !username.isEmpty else {
//            alertMessage = "Please enter username"
//            showAlert = true
//            return
//        }
//        
//        guard !password.isEmpty else {
//            alertMessage = "Please enter password"
//            showAlert = true
//            return
//        }
//        
//        let savedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
//        
//        if savedUsername == username {
//            authManager.loginUser()
//            dismiss()
//        } else {
//            alertMessage = "Invalid username or password"
//            showAlert = true
//        }
//    }
//}
//
//#Preview {
//    LoginView()
//        .environmentObject(AuthenticationManager())
//}
