//
//  Log-In.swift
//  TripMate
//
//  Created by iMac on 28/01/26.
//

//import SwiftUI
//
//struct LogIn: View {
//    @StateObject private var viewModel = LogInViewModel()
//    var body: some View {
//        ZStack{
//            Color.accent.opacity(0.5)
//                .ignoresSafeArea()
//            VStack{
//                Text("Log-In")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding(.bottom, 20)
//                
//                Image(systemName: "person.circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(Color.brown)
//                    .padding(.bottom, 20)
//                
//                VStack(alignment: .leading
//                       , spacing: 8){
//                    
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    LogIn()
//}



//
//  LogInView.swift
//  TripMate
//
//  Created by iMac on 28/01/26.
//

import SwiftUI

struct LogIn: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = LogInViewModel()
    @State private var navigateToRegistration: Bool = false
    @State private var navigateToHome: Bool = false
    @State private var showError = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background
                    .ignoresSafeArea()
                VStack{
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .bold()
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.brown)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading
                           , spacing: 8){
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        TextField("Enter your email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.ContainerColor)
                            .cornerRadius(20)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
                                )
                    }
                           .padding(.horizontal,30)
                    VStack(alignment: .leading
                           , spacing: 8){
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        SecureField("Enter your Password", text: $viewModel.password)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.ContainerColor)
                            .cornerRadius(20)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(colorScheme == .dark ? Color.BorderColor : Color.clear, lineWidth: 5)
                                )
                    }
                           .padding(.horizontal,30)
                    
                    
                    if !viewModel.errorMessage.isEmpty {
                                        Text(viewModel.errorMessage)
                                            .foregroundColor(.red)
                                            .font(.caption)
                                            .padding(.horizontal, 30)
                                    }
                    
                    Button(action: {
                       if viewModel.login(context: viewContext){
                            navigateToHome = true
                        } else {
                            showError = true
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.brown)
                            .cornerRadius(20)
                            .shadow(color: .brown.opacity(0.3), radius: 10)
                    }
                    .disabled(!viewModel.isValid)
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    // Already have account
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color.secondaryText)
                        
//                                            Button(action: {
//                                               NavigationLink("register", destination: RegistrationView())
//                                            }) {
//                                                Text("Register")
//                                                    .foregroundColor(.brown)
//                                                    .fontWeight(.semibold)
//                                            }
                        Button(action: {
                            navigateToRegistration = true
                        }) {
                            Text("Register")
                                .foregroundColor(.brown)
                                .fontWeight(.semibold)
                        }
                        .navigationDestination(isPresented: $navigateToRegistration) {
                            RegistrationView()
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .navigationDestination(isPresented: $navigateToHome) {
                                HomeView()
                            }
                .padding(.top, 50)
            }
        }
    }
}
#Preview {
    LogIn()
}
