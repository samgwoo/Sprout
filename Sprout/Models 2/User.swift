//
//  User.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/11/25.
//

import Foundation
import FirebaseFirestore

class User: Codable {
    let uid: String  // Unique identifier from Firebase Auth
    var email: String
    var friends: [String]  // List of user UIDs (friend list)
    var appearance: Appearance
    var healthData: HealthData
    var coins: Int

    init(uid: String, email: String, friends: [String] = [], appearance: Appearance, healthData: HealthData, coins: Int) {
        self.uid = uid
        self.email = email
        self.friends = friends
        self.appearance = appearance
        self.healthData = healthData
        self.coins = coins
    }

    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "friends": friends,
            "appearance": appearance.toDictionary(),
            "healthData": healthData.toDictionary(),
            "coins": String(coins)
        ]
    }
}

