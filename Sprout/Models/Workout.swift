//
//  Workout.swift
//  Sprout
//
//  Created by Neal Ahuja (student LM) on 4/7/25.
//

import SwiftUI

class Workout: ObservableObject, Identifiable {
    let id = UUID()
    let name: String
    let cat: String
    var set: Int
    @Published var rep: [Int]
    @Published var weight: [Int]


    init(name: String, cat: String, set: Int, rep: [Int], weight: [Int]) {
        self.name = name
        self.cat = cat
        self.set = set
        self.rep = rep
        self.weight = weight
    }
}

