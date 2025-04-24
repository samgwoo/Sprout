//
//  HomeView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var workouts : [WorkoutHistoryEntry] = []

        var body: some View {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                WorkoutListView(workoutHistory: $workouts)
                    .environmentObject(userViewModel)
                    .tabItem {
                        Label("Health", systemImage: "heart.fill")
                    }

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
            .onAppear {
                    if let userWorkouts = userViewModel.user?.workoutHistory {
                        self.workouts = userWorkouts
                    }
                }
        }
    
    }

struct DashboardView: View {
    var body: some View {
        ZStack{
            Image("background1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .opacity(0.3) // Static and opacity set

            VStack {
                Text("Welcome to Sprout! 🌱")
                    .font(.title)
                    .padding()
            }
        }
    }
}

struct HealthDataView: View {
    var body: some View {
        Text("Health Data Coming Soon!")
            .font(.title2)
            .padding()
    }
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Your Profile")
                .font(.title)
                .padding()

            Button(action: {
                authViewModel.logout()
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}



#Preview {
    let authVM = AuthViewModel()

    HomeView()
        .environmentObject(authVM)
        .environmentObject(UserViewModel())
        .environmentObject(HealthViewModel(authViewModel: authVM))

}
