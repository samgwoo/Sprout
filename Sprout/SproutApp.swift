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
    
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var healthViewModel: HealthViewModel

    init() {
        FirebaseApp.configure()
        let authVM = AuthViewModel()
        _authViewModel = StateObject(wrappedValue: authVM)
        _healthViewModel = StateObject(wrappedValue: HealthViewModel(authViewModel: authVM))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(healthViewModel)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            
            Group {
                if authViewModel.userSession == nil {
                    LoginView()
                } else {
                    HomeView()
                }
            }
        }
    }
}
