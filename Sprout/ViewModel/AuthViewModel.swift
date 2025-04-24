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
    @Published var userSession: FirebaseAuth.User? // Raw FirebaseAuth session
    @Published var errorMessage: String?
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self?.userSession = user
                }
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                if let user = result?.user {
                    self?.userSession = user
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
}
