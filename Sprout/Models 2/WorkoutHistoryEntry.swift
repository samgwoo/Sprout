//
//  WorkoutHistoryEntry.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 3/6/25.
//

import SwiftUI

struct WorkoutHistoryEntry: Identifiable {
    var id = UUID()
    var date: Date
    var workout: Workout
}
