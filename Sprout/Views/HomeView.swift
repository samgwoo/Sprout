//
//  HomeView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
        @StateObject private var viewModel = AuthViewModel()

        var body: some View {
            VStack {
                Text("Welcome to Sprout! 🌱")
                    .font(.title)
                    .padding()

                Button(action: {
                    viewModel.logout()
                    presentationMode.wrappedValue.dismiss()
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
    HomeView()
}
