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

        var body: some View {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                HealthDataView()
                    .tabItem {
                        Label("Health", systemImage: "heart.fill")
                    }

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
        }
    }

struct DashboardView: View {
    var body: some View {
        VStack {
            Text("Welcome to Sprout! 🌱")
                .font(.title)
                .padding()
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
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Your Profile")
                .font(.title)
                .padding()

            Button(action: {
                viewModel.logout()
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
    HomeView().environmentObject(AuthViewModel())
}
