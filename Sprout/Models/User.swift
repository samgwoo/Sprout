//
//  User.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/11/25.
//

import Foundation
import Combine
import FirebaseFirestore

class User: Codable, ObservableObject {
    let uid: String  // Unique identifier from Firebase Auth
    var email: String
    @Published var appearance: Appearance
    @Published var healthData: [HealthData]
    @Published var workoutHistory: [WorkoutHistoryEntry]
    @Published var coins: Int

    enum CodingKeys: String, CodingKey {
            case uid, email, appearance, healthData, workoutHistory, coins
        }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            uid               = try container.decode(String.self, forKey: .uid)
            email             = try container.decode(String.self, forKey: .email)
            appearance        = try container.decode(Appearance.self, forKey: .appearance)
            healthData        = try container.decode([HealthData].self, forKey: .healthData)
            workoutHistory    = try container.decode([WorkoutHistoryEntry].self, forKey: .workoutHistory)
            coins             = try container.decode(Int.self, forKey: .coins)
        }
    
    init(uid: String, email: String, appearance: Appearance = Appearance(), healthData: [HealthData] = [HealthData()], workoutHistory: [WorkoutHistoryEntry] = [], coins: Int = 700) {
        self.uid = uid
        self.email = email
        self.appearance = appearance
        self.healthData = healthData
        self.workoutHistory = workoutHistory
        self.coins = coins
    }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(uid,            forKey: .uid)
            try container.encode(email,          forKey: .email)
            try container.encode(appearance,     forKey: .appearance)
            try container.encode(healthData,     forKey: .healthData)
            try container.encode(workoutHistory, forKey: .workoutHistory)
            try container.encode(coins,          forKey: .coins)
        }

    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "appearance": appearance.toDictionary(),
            "healthData": healthData.map {$0.toDictionary() },
            "workoutHistory": workoutHistory.map { $0.toDictionary() },
            "coins": coins
        ]
    }
}

