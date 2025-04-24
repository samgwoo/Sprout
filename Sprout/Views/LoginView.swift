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

    @State private var email = ""
    @State private var password = ""
    @State private var path = NavigationPath()

    @State private var showLogo = false
    @State private var showForm = false
    @State private var progress: CGFloat = 0.0 // Progress for the progress bar

    enum Route: Hashable {
        case home
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Static background
                Image("background1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(0.3) // Static and opacity set

                VStack {
                    Spacer() // Push the logo and progress bar to the middle of the screen

                    if showLogo {
                        // Logo Display - Centered in the middle of the screen
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .transition(.scale.combined(with: .opacity))
                            .padding(.bottom, 10)
                    }

                    if !showForm {
                        // Progress bar - Centered below the logo
                        ProgressView(value: progress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            .frame(width: 200)
                            .padding(.top, 20)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 2.5)) {
                                    progress = 1.0
                                }
                            }
                    }

                    Spacer() // Push the form down below the center

                    if showForm {
                        // Login Form (email/password fields) - Will appear after progress bar finishes
                        VStack(spacing: 16) {
                            Text("Login")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .transition(.move(edge: .bottom).combined(with: .opacity))

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
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer() // Ensure the content is centered vertically
                }
                .padding()
            }
            .onAppear {
                // Initially animate the logo in
                withAnimation(.easeOut(duration: 0.6)) {
                    showLogo = true
                }

                // After the logo animates, start the progress bar loading
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeInOut(duration: 2.5)) {
                        progress = 1.0
                    }
                }

                // After the progress bar finishes, show the form
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        showForm = true
                    }
                }
            }
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
