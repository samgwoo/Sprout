//
//  WorkoutHistoryEntry.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 3/6/25.
//

import SwiftUI
import FirebaseFirestore

struct WorkoutHistoryEntry: Identifiable, Codable, Equatable {
    var id: UUID
    var date: Date
    var split: String
    var workout: [Exercise]

    init(date: Date, split: String, workout: [Exercise] = []) {
        self.id      = UUID()
        self.date    = date
        self.split   = split
        self.workout = workout
    }

    enum CodingKeys: String, CodingKey {
        case id, date, split, workout
    }

    func toDictionary() -> [String: Any] {
        return [
            "id":          id.uuidString,
            "date":        Timestamp(date: date),
            "split":       split,
            "workout":     workout.map { $0.toDictionary() }
        ]
    }

    init(from decoder: Decoder) throws {
        let c       = try decoder.container(keyedBy: CodingKeys.self)
        id          = try c.decode(UUID.self,       forKey: .id)
        date        = try c.decode(Date.self,       forKey: .date)
        split       = try c.decode(String.self,     forKey: .split)
        workout     = try c.decode([Exercise].self, forKey: .workout)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id,       forKey: .id)
        try c.encode(date,     forKey: .date)
        try c.encode(split,    forKey: .split)
        try c.encode(workout,  forKey: .workout)
    }

    private func maxWeight(matching keywords: [String]) -> Int {
        workout
            .filter { ex in keywords.contains { ex.name.lowercased().contains($0) } }
            .flatMap { $0.sets.map(\.weight) }
            .max() ?? 0
    }

    private func level(from weight: Int, weak: Int, medium: Int) -> Int {
        switch weight {
        case ..<weak:       return 0
        case weak..<medium: return 1
        default:            return 2
        }
    }

    var pushStrength: Int {
        level(from: maxWeight(matching: ["press","bench","push"]), weak: 100, medium: 155)
    }

    var pullStrength: Int {
        level(from: maxWeight(matching: ["row","pull","deadlift"]), weak: 120, medium: 205)
    }

    var legStrength: Int {
        level(from: maxWeight(matching: ["squat","lunge","deadlift"]), weak: 135, medium: 225)
    }
}

