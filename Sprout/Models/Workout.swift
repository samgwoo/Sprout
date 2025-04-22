//
//  Workout.swift
//  Sprout
//
//  Created by Neal Ahuja (student LM) on 4/7/25.
//

import Foundation
import SwiftUI

class Workout: ObservableObject, Identifiable, Codable {
    // MARK: - Properties
    let id: UUID
    let name: String
    let cat: String
    @Published var set: Int
    @Published var rep: [Int]
    @Published var weight: [Int]

    // Designated initializer now accepts an `id`
    init(
        id: UUID = UUID(),
        name: String,
        cat: String,
        set: Int,
        rep: [Int],
        weight: [Int]
    ) {
        self.id     = id
        self.name   = name
        self.cat    = cat
        self.set    = set
        self.rep    = rep
        self.weight = weight
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id, name, cat, set, rep, weight
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id     = try container.decode(UUID.self,    forKey: .id)
        let name   = try container.decode(String.self,  forKey: .name)
        let cat    = try container.decode(String.self,  forKey: .cat)
        let set    = try container.decode(Int.self,     forKey: .set)
        let rep    = try container.decode([Int].self,   forKey: .rep)
        let weight = try container.decode([Int].self,   forKey: .weight)
        self.init(
            id:     id,
            name:   name,
            cat:    cat,
            set:    set,
            rep:    rep,
            weight: weight
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id,     forKey: .id)
        try container.encode(name,   forKey: .name)
        try container.encode(cat,    forKey: .cat)
        try container.encode(set,    forKey: .set)
        try container.encode(rep,    forKey: .rep)
        try container.encode(weight, forKey: .weight)
    }
}
