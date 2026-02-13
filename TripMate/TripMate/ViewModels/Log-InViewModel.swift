//
//  Log-InViewModel.swift
//  TripMate
//
//  Created by iMac on 28/01/26.
//

import SwiftUI
import Combine
import CoreData

//class LogInViewModel: ObservableObject{
//    
//    @Published var email: String = ""
//    @Published var password: String = ""
//    
//    let register: RegistrationViewModel
//    
//    init(register: RegistrationViewModel){
//        self.register = register
//    }
//    
//    func login(){
//        print("username = \(email)")
//        print("password = \(password)")
//        validate()
//    }
//    func validate() {
//        print("REGISTERED EMAIL:", register.email)
//        print("REGISTERED PASSWORD:", register.password)
//
//        if register.email != email
//            || register.password != password {
//            print("Username or password is wrong")
//        } else {
//            print("Login successful")
//        }
//    }
//}




class LogInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    
    var isValid: Bool {
        email.contains("@") && !password.isEmpty
    }
    
    // ✅ Login function - validates against Core Data
    func login(context: NSManagedObjectContext) -> Bool {
        guard isValid else {
            errorMessage = "Please enter valid email and password"
            return false
        }
        
        // Fetch user from database
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let user = results.first as? NSManagedObject {
                // Get stored password
                let storedPassword = user.value(forKey: "password") as? String
                
                // Validate password
                if storedPassword == password {
                    print("✅ Login successful!")
                    isAuthenticated = true
                    return true
                } else {
                    print("❌ Incorrect password")
                    errorMessage = "Incorrect password"
                    return false
                }
            } else {
                print("❌ User not found")
                errorMessage = "Email not registered"
                return false
            }
            
        } catch {
            print("❌ Error fetching user:", error.localizedDescription)
            errorMessage = "Login failed. Please try again."
            return false
        }
    }
    
    // ✅ Clear form
    func clearForm() {
        email = ""
        password = ""
        errorMessage = ""
    }
}
