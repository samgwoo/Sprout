//
//  HomeView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @EnvironmentObject var authVM  : AuthViewModel          // kept for future use
    @EnvironmentObject var userVM  : UserViewModel
    @EnvironmentObject var healthVM: HealthViewModel
    
    @State private var workouts: [WorkoutHistoryEntry] = []
    @State private var syncing = false
    
    var body: some View {
        NavigationStack {
            TabView {
                // ── Avatar tab ────────────────────────────────
                Group {
                    if let user = userVM.user {
                        AvatarView().environmentObject(user)
                    } else {
                        ProgressView()
                    }
                }
                .tabItem { Label("Home", systemImage: "house") }
                
                // ── Workouts tab ──────────────────────────────
                WorkoutListView(workoutHistory: $workouts)
                    .environmentObject(userVM)
                    .tabItem { Label("Workouts", systemImage: "heart.fill") }
                
                // ── Shop tab ─────────────────────────────────
                ShopView()
                    .environmentObject(userVM)
                    .tabItem { Label("Shop", systemImage: "cart") }
            }
            .navigationTitle("Sprout")
            .onAppear {
                // pull workouts once at launch
                workouts = userVM.user?.workoutHistory ?? []
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        syncNow()
                    } label: {
                        syncing ?
                            AnyView(ProgressView()) :
                            AnyView(Image(systemName: "arrow.clockwise"))
                    }
                    .disabled(syncing)
                }
// <<<<<<< emmmily
//         }
    
//     }

// struct DashboardView: View {
//     var body: some View {
//         ZStack{
//             Image("background1")
//                 .resizable()
//                 .aspectRatio(contentMode: .fill)
//                 .ignoresSafeArea()
//                 .opacity(0.3) // Static and opacity set

//             VStack {
//                 Text("Welcome to Sprout! 🌱")
//                     .font(.title)
//                     .padding()
// =======
// >>>>>>> main
            }
        }
    }
    
    /// Gets fresh HealthKit, merges it into the user object, then pushes via `userVM.updateUserProfile`.
    private func syncNow() {
        guard var user = userVM.user else { return }
        syncing = true
        
        // 1 ── fetch HealthKit
        healthVM.fetchHealthData()
        
        // 2 ── wait 1 s for HealthKit callback, merge, push, update UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            if let newHD = healthVM.healthData {
                user.healthData = newHD
                userVM.updateUserProfile(newUser: user)     // this pushes to Firestore
                self.workouts = user.workoutHistory         // keep the local array in sync
            }
            self.syncing = false
        }
    }
}

// MARK: – Preview
#Preview {
    let auth   = AuthViewModel()
    let userVM = UserViewModel()
    let health = HealthViewModel(authViewModel: auth)
    
    userVM.user = User(
        uid: "demo",
        email: "demo@sprout.app",
        appearance: Appearance(skinColor: 1),
        healthData: HealthData(sleepHours: 7),
        workoutHistory: [],
        coins: 200
    )
    
    return HomeView()
        .environmentObject(auth)
        .environmentObject(userVM)
        .environmentObject(health)
}
