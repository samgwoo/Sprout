//
//  SproutApp.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 2/13/25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

    return true
  }
}

@main
struct SproutApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var healthViewModel: HealthViewModel

    init() {
        let authVM = AuthViewModel()
        _authViewModel = StateObject(wrappedValue: authVM)
        _healthViewModel = StateObject(wrappedValue: HealthViewModel(authViewModel: authVM))
    }
    
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.userSession == nil {
                LoginView()
                    .environmentObject(authViewModel)
                    .environmentObject(healthViewModel)
            } else {
                HomeView()
                    .environmentObject(authViewModel)
                    .environmentObject(healthViewModel)
            }
        }
    }
}
