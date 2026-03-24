//
//  TripMateApp.swift
//  TripMate
//
//  Created by iMac on 26/01/26.
//

import SwiftUI
import CoreData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      Auth.auth().settings?.isAppVerificationDisabledForTesting = true
    return true
  }
    // ✅ Forward APNs token to Firebase
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }

    // ✅ Forward notifications to Firebase Auth
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        completionHandler(.newData)
    }

    // ✅ Handle reCAPTCHA redirect
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        if Auth.auth().canHandle(url) { return true }
        return false
    }

}

@main
struct TripMateApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    @StateObject var SessionVM = SessionViewModel()
    @StateObject var profileImageManager = ProfileImageManager()
   
    var body: some Scene {
        WindowGroup {
//            RegistrationView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environmentObject(SessionViewModel())
            
            if SessionVM.isLoggedIn {
                            HomeView()
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .environmentObject(SessionVM)   // 👈 same sessionVM everywhere
                                .environmentObject(profileImageManager)
            } else if SessionVM.showLogIn {
                            LogIn()
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .environmentObject(SessionVM)   // 👈 same sessionVM everywhere
                                .environmentObject(profileImageManager)
            } else {
                RegistrationView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(SessionVM)
                    .environmentObject(profileImageManager)
            }
        }
    }
}
