//
//  UserViewModel.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 4/14/25.
//

import SwiftUI
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    func fetchUserProfile(uid: String) {
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            if let snapshot = snapshot, snapshot.exists, let data = snapshot.data() {
                do {
                    // Convert dictionary data to JSON, then decode into a User object.
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let decodedUser = try JSONDecoder().decode(User.self, from: jsonData)
                    DispatchQueue.main.async {
                        self?.user = decodedUser
                        print("User profile fetched: \(decodedUser)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "User profile does not exist."
                }
            }
        }
    }
    
    /// Update the user profile in Firestore using the User's dictionary.
    func updateUserProfile(newUser: User) {
        let userRef = db.collection("users").document(newUser.uid)
        let data = newUser.toDictionary()
        userRef.setData(data) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            } else {
                DispatchQueue.main.async {
                    self?.user = newUser
                    print("User profile updated successfully!")
                }
            }
        }
    }
    
    func createDefaultUserProfile(uid: String, email: String) {
        let defaultAppearance = Appearance(skinColor: 0, accessory1: nil, accessory2: nil, accessory3: nil, unlockedSkins: [], unlockedAccessories: [])
        let defaultHealthData = HealthData()
        let defaultUser = User(uid: uid, email: email, appearance: defaultAppearance, healthData: defaultHealthData, coins: 0)
        let userRef = db.collection("users").document(uid)
        userRef.setData(defaultUser.toDictionary()) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            } else {
                DispatchQueue.main.async {
                    self?.user = defaultUser
                    print("Default user profile created!")
                }
            }
        }
    }
}
