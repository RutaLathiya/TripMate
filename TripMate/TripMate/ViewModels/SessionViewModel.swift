//
//  SessionViewModel.swift
//  TripMate
//
//  Created by iMac on 26/02/26.
//

import SwiftUI
import Combine
import CoreData

//class SessionViewModel: ObservableObject{
//    
//    //@Published var showLogIn = false
//        
//    @Published var isLoggedIn = false{
//        didSet {
//            print("🟡 isLoggedIn changed to: \(isLoggedIn) — instance: \(ObjectIdentifier(self))")
//        }
//    }
//       @Published var showLogIn = false {
//           didSet {
//               print("🟡 showLogIn changed to: \(showLogIn) — instance: \(ObjectIdentifier(self))")
//           }
//       }
//        func login() {
//            //isLoggedIn = true
//            // SessionViewModel.swift
//            func login() {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.isLoggedIn = true
//                }
//            }
//        }
//        
//        func logout() {
//            isLoggedIn = false
//            showLogIn = true
//        }
//}


// SessionViewModel.swift
class SessionViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
            print("🟡 isLoggedIn changed to: \(isLoggedIn)")
        }
    }
    
    @Published var showLogIn: Bool = false {
        didSet {
            print("🟡 showLogIn changed to: \(showLogIn)")
        }
    }
    
    init() {
        // restore login state from UserDefaults
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func login() {
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
        showLogIn = true
    }
}


