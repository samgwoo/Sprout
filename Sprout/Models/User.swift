//
//  User.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/11/25.
//

import Foundation
import FirebaseFirestore

class User: Codable, ObservableObject {
    let uid: String  // Unique identifier from Firebase Auth
    var email: String
    var appearance: Appearance
    var healthData: HealthData
    var workoutHistory: [WorkoutHistoryEntry]
    var coins: Int

    init(uid: String, email: String, appearance: Appearance = Appearance(), healthData: HealthData = HealthData(), workoutHistory: [WorkoutHistoryEntry] = [], coins: Int = 0) {
        self.uid = uid
        self.email = email
        self.appearance = appearance
        self.healthData = healthData
        self.workoutHistory = workoutHistory
        self.coins = coins
    }

    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "appearance": appearance.toDictionary(),
            "healthData": healthData.toDictionary(),
            "coins": coins
        ]
    }
}

