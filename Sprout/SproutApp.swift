//
//  SproutApp.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 2/13/25.
//

import SwiftUI
import FirebaseCore


@main
struct SproutApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var healthViewModel: HealthViewModel

    init() {
        FirebaseApp.configure()
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
