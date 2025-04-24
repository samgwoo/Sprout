//
//  WorkoutHistoryEntry.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 3/6/25.
//

import SwiftUI
import FirebaseFirestore

struct WorkoutHistoryEntry: Identifiable, Codable {
    var id: UUID
    var date: Date
    var workout: [Exercise]

    init(date: Date, workout: [Exercise]) {
        self.id      = UUID()
        self.date    = date
        self.workout = workout
    }

    enum CodingKeys: String, CodingKey {
        case id, date, workout
    }

    func toDictionary() -> [String:Any] {
            return [
                "id": id.uuidString,
                "date": Timestamp(date: date),
                "workout": workout.map { $0.toDictionary() }
            ]
        }

    init(from decoder: Decoder) throws {
        let c    = try decoder.container(keyedBy: CodingKeys.self)
        id       = try c.decode(UUID.self,    forKey: .id)
        date     = try c.decode(Date.self,    forKey: .date)
        workout  = try c.decode([Exercise].self, forKey: .workout)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id,      forKey: .id)
        try c.encode(date,    forKey: .date)
        try c.encode(workout, forKey: .workout)
    }
    private func maxWeight(matching keywords: [String]) -> Int {
        workout
          .filter { ex in keywords.contains { ex.name.lowercased().contains($0) } }
          .flatMap { $0.sets.map(\.weight) }
          .max() ?? 0
      }

      // helper to bin into 0/1/2
      private func level(from weight: Int, weak: Int, medium: Int) -> Int {
        switch weight {
        case ..<weak:       return 0
        case weak..<medium: return 1
        default:            return 2
        }
      }

      // pushStrength: bench/press/push thresholds
      var pushStrength: Int {
        let w = maxWeight(matching: ["press","bench","push"])
        return level(from: w, weak: 100, medium: 155)
      }

      // pullStrength: row/pull/deadlift thresholds
      var pullStrength: Int {
        let w = maxWeight(matching: ["row","pull","deadlift"])
        return level(from: w, weak: 120, medium: 205)
      }

      // legStrength: squat/lunge/deadlift thresholds
      var legStrength: Int {
        let w = maxWeight(matching: ["squat","lunge","deadlift"])
        return level(from: w, weak: 135, medium: 225)
      }
    }

