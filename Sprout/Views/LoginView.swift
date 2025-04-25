//
//  LoginView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var healthViewModel: HealthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var path = NavigationPath()

    @State private var showLogo = false
    @State private var showForm = false
    @State private var progress: CGFloat = 0.0

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("background1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(0.3)

                VStack {
                    Spacer()

                    if showLogo {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .transition(.scale.combined(with: .opacity))
                            .padding(.bottom, 10)
                    }

                    if !showForm {
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

                    Spacer()

                    if showForm {
                        VStack(spacing: 16) {
                            Text("Login")
                                .font(Constants.headerFont)
                                .fontWeight(.bold)
                                .transition(.move(edge: .bottom).combined(with: .opacity))

                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(.horizontal)
                                .font(Constants.addressFont)

                            SecureField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                .font(Constants.addressFont)

                            if let error = authViewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.horizontal)
                            }

                            Button {
                                authViewModel.login(email: email, password: password)
                            } label: {
                                Text("Login")
                                    .font(Constants.searchFont)
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
                            .font(Constants.searchFont)
                            .foregroundColor(.blue)
                            .padding(.top, 8)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer()
                }
                .padding()
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) { showLogo = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeInOut(duration: 2.5)) { progress = 1.0 }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                    withAnimation(.easeOut(duration: 0.6)) { showForm = true }
                }
            }
            .navigationDestination(isPresented: .constant(authViewModel.userSession != nil)) {
                HomeView()
                    .environmentObject(authViewModel)
                    .environmentObject(userViewModel)
                    .environmentObject(healthViewModel)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let authVM = AuthViewModel()
        let userVM = UserViewModel(authVM: authVM)
        let healthVM = HealthViewModel(authVM: authVM, userVM: userVM)

        LoginView()
            .environmentObject(authVM)
            .environmentObject(userVM)
            .environmentObject(healthVM)
    }
}
