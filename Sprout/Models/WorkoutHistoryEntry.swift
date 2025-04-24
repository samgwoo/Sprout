//
//  WorkoutHistoryEntry.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 3/6/25.
//

import SwiftUI

struct WorkoutHistoryEntry: Identifiable, Codable {
    var id: UUID
    var date: Date
    var workout: Workout

    init(date: Date, workout: Workout) {
        self.id      = UUID()
        self.date    = date
        self.workout = workout
    }

    enum CodingKeys: String, CodingKey {
        case id, date, workout
    }

    // The compiler can actually synthesize these for you *now* that `Workout` is codable,
    // but here’s the manual version for clarity:

    init(from decoder: Decoder) throws {
        let c    = try decoder.container(keyedBy: CodingKeys.self)
        id       = try c.decode(UUID.self,    forKey: .id)
        date     = try c.decode(Date.self,    forKey: .date)
        workout  = try c.decode(Workout.self, forKey: .workout)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id,      forKey: .id)
        try c.encode(date,    forKey: .date)
        try c.encode(workout, forKey: .workout)
    }
}
