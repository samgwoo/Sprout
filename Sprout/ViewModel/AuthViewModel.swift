//
//  AuthViewModel.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/5/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? // Stores the logged-in user
    @Published var errorMessage: String? // Stores authentication errors
    
    private var db = Firestore.firestore()
    
    init() {
        self.userSession = Auth.auth().currentUser // Check if user is already logged in
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.userSession = result?.user
                    self.fetchUserProfile()
                }
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.userSession = result?.user
                    self.createUserProfile()
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    private func createUserProfile() {
            guard let user = userSession else { return }
            let userRef = db.collection("users").document(user.uid)

            let userData: [String: Any] = [
                "email": user.email ?? "",
                "appearance": ["skinColor": 0, "accessory1": nil, "accessory2": nil, "accessory3": nil], // default appearance
                "healthData": ["stepCount": 0, "heartRate": 75.0] // default health data
            ]

            userRef.setData(userData) { error in
                if let error = error {
                    print("Error creating user profile: \(error.localizedDescription)")
                } else {
                    print("User profile successfully created!")
                }
            }
        }

        private func fetchUserProfile() {
            guard let user = userSession else { return }
            let userRef = db.collection("users").document(user.uid)

            userRef.getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching user profile: \(error.localizedDescription)")
                } else if let snapshot = snapshot, snapshot.exists {
                    // Deserialize the user profile data and update the UI
                    let data = snapshot.data()
                    print("User profile fetched: \(data ?? [:])")
                    // You can now pass the profile data to your views or models
                }
            }
        }

}
