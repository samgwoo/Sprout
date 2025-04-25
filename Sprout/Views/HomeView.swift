
//
//  HomeView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM  : AuthViewModel
    @EnvironmentObject var userVM  : UserViewModel
    @EnvironmentObject var healthVM: HealthViewModel

    @State private var workouts: [WorkoutHistoryEntry] = []
    @State private var syncing = false

    private func logoutNow() {
        if let current = userVM.user {
            userVM.updateUserProfile(newUser: current)
        }
        authVM.logout()
    }

    var body: some View {
        NavigationStack {
            TabView {
                Group {
                    if userVM.user == nil {
                        ProgressView()
                    } else {
                        AvatarView()
                            .environmentObject(userVM)
                    }
                }
                .tabItem { Label("Home", systemImage: "house") }

                WorkoutListView(workoutHistory: $workouts)
                    .environmentObject(userVM)
                    .tabItem { Label("Workouts", systemImage: "heart.fill") }

                ShopView()
                    .environmentObject(userVM)
                    .tabItem { Label("Shop", systemImage: "cart") }
            }
            .navigationTitle("Sprout")
            .onAppear {
                workouts = userVM.user?.workoutHistory ?? []
                healthVM.fetchHealthData()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let newHD = healthVM.healthData,
                       let user = userVM.user,
                       user.healthData.last?.timeStamp != newHD.timeStamp {
                        var updatedUser = user
                        updatedUser.healthData.append(newHD)
                        userVM.updateUserProfile(newUser: updatedUser)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: logoutNow) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }

                    Button(action: syncNow) {
                        syncing
                            ? AnyView(ProgressView())
                            : AnyView(Image(systemName: "arrow.clockwise"))
                    }
                    .disabled(syncing)
                }
            }
        }
    }

    private func syncNow() {
        guard var user = userVM.user else { return }
        syncing = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let newHD = healthVM.healthData,
               user.healthData.last != newHD {
                user.healthData.append(newHD)
                userVM.updateUserProfile(newUser: user)
                self.workouts = user.workoutHistory
            }
            self.syncing = false
        }
    }
}

// MARK: – Preview
#Preview {
    let auth = AuthViewModel()
    let userVM: UserViewModel = {
        let vm = UserViewModel(authVM: auth)
        vm.user = User(
            uid: "demo",
            email: "demo@sprout.app",
            appearance: Appearance(
                skinColor: 1,
                accessory1: nil,
                accessory2: nil,
                accessory3: nil,
                unlockedSkins: [],
                unlockedAccessories: []
            ),
            healthData: [],
            workoutHistory: [],
            coins: 2000
        )
        return vm
    }()
    let health = HealthViewModel(authVM: auth, userVM: userVM)

    HomeView()
        .environmentObject(auth)
        .environmentObject(userVM)
        .environmentObject(health)
}
