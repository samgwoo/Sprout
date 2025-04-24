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
    
    func fetchUserProfile(uid: String, completion: ((Bool) -> Void)? = nil) {
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    completion?(false)
                }
                return
            }
            
            do {
                if let snapshot = snapshot, snapshot.exists {
                    let decodedUser = try snapshot.data(as: User.self)
                    DispatchQueue.main.async {
                        self?.user = decodedUser
                        print("✅ User profile fetched successfully")
                        completion?(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "User profile does not exist."
                        completion?(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                    completion?(false)
                }
            }
        }
    }

    
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
