//
//  UserViewModel.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 4/14/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class UserViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private let authVM: AuthViewModel

    init(authVM: AuthViewModel) {
            self.authVM = authVM
        }
    
    private var uid: String? { authVM.userSession?.uid }

    
    func fetchUserProfile(completion: ((Bool) -> Void)? = nil) {
            guard let uid else { completion?(false); return }
            let ref = db.collection("users").document(uid)
            ref.getDocument { [weak self] snap, err in
                if let err { self?.errorMessage = err.localizedDescription; completion?(false); return }
                do {
                    if let snap, snap.exists {
                        self?.user = try snap.data(as: User.self)
                        completion?(true)
                    } else {
                        self?.errorMessage = "User profile does not exist."
                        completion?(false)
                    }
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                    completion?(false)
                }
            }
        }

    
    func updateUserProfile(newUser: User) {
            guard let uid else { return }
            let ref = db.collection("users").document(uid)
            ref.setData(newUser.toDictionary()) { [weak self] err in
                if let err { self?.errorMessage = err.localizedDescription }
                else { self?.user = newUser }
            }
        }
    
    func createDefaultUserProfile(email: String) {
            guard let uid else { return }
            let defaultUser = User(
                uid: uid,
                email: email,
                appearance: Appearance(skinColor: 0),
                healthData: [],
                workoutHistory: [],
                coins: 700
            )
            updateUserProfile(newUser: defaultUser)
        }
    
    func buySkin(at index: Int, price: Int) {
            guard var current = user,
                  !current.appearance.unlockedSkins.contains(index),
                  current.coins >= price else { return }
            current.coins -= price
            current.appearance.unlockedSkins.append(index)
            user = current
            updateUserProfile(newUser: current)
        }
    
    func buyAccessory(at index: Int, price: Int) {
            guard var current = user,
                  !current.appearance.unlockedAccessories.contains(index),
                  current.coins >= price else { return }
            current.coins -= price
            current.appearance.unlockedAccessories.append(index)
            user = current
            updateUserProfile(newUser: current)
        }
    
    func appendHealthData(_ newData: HealthData) {
            guard var current = user else { return }
            current.healthData.append(newData)
            user = current
            updateUserProfile(newUser: current)
        }
    
}
