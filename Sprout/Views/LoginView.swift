//
//  LoginView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var healthViewModel: HealthViewModel

    @State private var email    = ""
    @State private var password = ""
    @State private var path     = NavigationPath()

    enum Route: Hashable {
        case home
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                Button(action: {
                    authViewModel.login(email: email, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                Button("Sign Up") {
                    authViewModel.signUp(email: email, password: password)
                }
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top, 8)

                Spacer()
            }
            .padding()

            .navigationDestination(isPresented: .constant(authViewModel.userSession != nil)) {
                    HomeView()
                        .environmentObject(authViewModel)
                        .environmentObject(healthViewModel)
                }
            }
        }
    }


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let authVM = AuthViewModel()
        let healthVM = HealthViewModel(authViewModel: authVM)
        LoginView()
            .environmentObject(authVM)
            .environmentObject(healthVM)
    }
}
