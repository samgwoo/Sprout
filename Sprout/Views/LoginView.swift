//
//  LoginView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//

import SwiftUI


struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
        @State private var email = ""
        @State private var password = ""

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

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        viewModel.login(email: email, password: password)
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
                        viewModel.signUp(email: email, password: password)
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .padding()
                .background(
                    NavigationLink(destination: HomeView(), isActive: .constant(viewModel.userSession != nil)) {
                        EmptyView()
                    }
                    .hidden()
                )
            }
        }
    }
#Preview {
    LoginView()
}
