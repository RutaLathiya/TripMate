//
//  Log-InViewModel.swift
//  TripMate
//
//  Created by iMac on 28/01/26.
//

import SwiftUI
import Combine

class LogInViewModel: ObservableObject{
    @Published var username: String = ""
    @Published var password: String = ""
    
    func login(){
        print("username = \(username)")
        print("password = \(password)")
    }
}
