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
    @StateObject private var userViewModel: UserViewModel

    init() {
        FirebaseApp.configure()
        let authVM = AuthViewModel()
        _authViewModel = StateObject(wrappedValue: authVM)
        _healthViewModel = StateObject(wrappedValue: HealthViewModel(authViewModel: authVM))
        _userViewModel   = StateObject(wrappedValue: UserViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(healthViewModel)
                .environmentObject(userViewModel)
        }
    }
}

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            if authViewModel.userSession == nil {
                LoginView()
            } else {
                HomeView()
                    .onAppear {
                        if let uid = authViewModel.userSession?.uid {
                            userViewModel.fetchUserProfile(uid: uid) { exists in
                                if !exists, let email = authViewModel.userSession?.email {
                                    userViewModel.createDefaultUserProfile(uid: uid, email: email)
                                }
                            }
                        }
                    }
            }
        }
    }
}
