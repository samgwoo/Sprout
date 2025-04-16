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
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
                }
                .padding(.horizontal)
                
                Button(action: {
                    authViewModel.signUp(email: email, password: password)
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            // Overlay a NavigationLink that's active when userSession becomes non-nil.
            .overlay(
                NavigationLink(
                    destination: HomeView()
                        .environmentObject(authViewModel)
                        .environmentObject(healthViewModel),
                    isActive: Binding<Bool>(
                        get: { authViewModel.userSession != nil },
                        set: { _ in }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide mock environment objects for previewing.
        let authVM = AuthViewModel()
        let healthVM = HealthViewModel(authViewModel: authVM)
        LoginView()
            .environmentObject(authVM)
            .environmentObject(healthVM)
    }
}
