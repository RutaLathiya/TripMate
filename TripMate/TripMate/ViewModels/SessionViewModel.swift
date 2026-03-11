//
//  SessionViewModel.swift
//  TripMate
//
//  Created by iMac on 26/02/26.
//

import SwiftUI
import Combine
import CoreData

class SessionViewModel: ObservableObject{
    
    //@Published var showLogIn = false
        
    @Published var isLoggedIn = false
//    {
//        didSet {
//            print("🟡 isLoggedIn changed to: \(isLoggedIn) — instance: \(ObjectIdentifier(self))")
//        }
//    }
       @Published var showLogIn = false
//       {
//           didSet {
//               print("🟡 showLogIn changed to: \(showLogIn) — instance: \(ObjectIdentifier(self))")
//           }
//       }
    
    @Published var currentUser: String = ""
        //func login() {
            //isLoggedIn = true
            // SessionViewModel.swift
    
    @Published var currentUserUID: UUID? = nil
    // Add this in SessionViewModel
    
    
    
    func login(userName: String = "", uid: UUID? = nil) {
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isLoggedIn = true
                    currentUser = userName
                    self.currentUserUID = uid  // 👈 store the uid
                    print("✅ Logged in as: \(userName), uid: \(String(describing: uid))")
                //}
            }
        //}
        
        func logout() {
            isLoggedIn = false
            showLogIn = true
            currentUser = ""
            currentUserUID = nil
        }
}


//// SessionViewModel.swift
//class SessionViewModel: ObservableObject {
//    
//    @Published var isLoggedIn: Bool {
////        didSet {
////            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
////            print("🟡 isLoggedIn changed to: \(isLoggedIn)")
////        }
////    }
//
//        didSet {
//              print("🟡 isLoggedIn changed to: \(isLoggedIn)")
//              // Print the call stack to find WHO is changing it
//              Thread.callStackSymbols.forEach { print($0) }
//          }
//      }
//        
//    @Published var showLogIn: Bool = false {
//        didSet {
//            print("🟡 showLogIn changed to: \(showLogIn)")
//        }
//    }
//   // @Published var showLogoutAlert = false
//    init() {
//        // restore login state from UserDefaults
//        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
//    
//    func login() {
//        //showLogoutAlert = false
//        isLoggedIn = true
//    }
//    
//    func logout() {
//        //showLogoutAlert = false
//        isLoggedIn = false
//        showLogIn = true
//    }
//}
//
//
