//
//  RegistrationViewModel.swift
//  TripMate
//
//  Created by iMac on 28/01/26.
//

import SwiftUI
import Combine
import CoreData

class RegistrationViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var phoneNo: String = ""
    
    
    var name: String {
            "\(firstName) \(lastName)"
                .trimmingCharacters(in: .whitespaces)
        }
    
    
    var isValid: Bool {
        !name.isEmpty &&
        email.contains("@") &&
        password.count >= 6 &&
        phoneNo.count == 10
    }
    
    func userExists(email: String, context: NSManagedObjectContext) -> Bool{
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fr.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let count = try context.count(for: fr)
            return count > 0
        } catch {
            print("❌ Error checking if user exists:", error.localizedDescription)
            return false
        }
    }
    
    func save(context: NSManagedObjectContext) -> Bool {
        guard isValid else {
            print("❌ Form is not valid")
            return false
        }
        
        if userExists(email: email, context: context) {
            print("⚠️ User with email \(email) already exists")
            return false
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        let user = NSManagedObject(entity: entity, insertInto: context)
        
        user.setValue(UUID(), forKey: "uid")
        user.setValue(name, forKey: "name")
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")
        user.setValue(phoneNo, forKey: "phoneNo")
        
        do {
            try context.save()
            print("✅ User saved successfully")
            clearForm()
            return true
        } catch {
            print("❌ Failed to save user:", error.localizedDescription)
            return false
        }
    }
    
    func clearForm(){
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
    
    func register(context: NSManagedObjectContext) -> Bool{
        
        print("Full Name: \(name)")
        print("Email: \(email)")
        print("Password: \(password)")
        print("Confirm Password: \(confirmPassword)")
        
        return save(context: context)
        
    }
}
