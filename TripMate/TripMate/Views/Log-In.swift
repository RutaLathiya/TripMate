//
//  Log-In.swift
//  TripMate
//
//  Created by iMac on 28/01/26.
//

import SwiftUI

struct LogIn: View {
    @StateObject private var viewModel = LogInViewModel()
    var body: some View {
        ZStack{
            Color.accent.opacity(0.5)
                .ignoresSafeArea()
            VStack{
                Text("Log-In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.brown)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading
                       , spacing: 8){
                    
                }
            }
        }
    }
}

#Preview {
    LogIn()
}
