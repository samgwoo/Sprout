import Foundation
import SwiftUI

class Exercise: ObservableObject, Identifiable, Codable {
    // MARK: - Properties
    let id: UUID
    let name: String
    let cat: String
    @Published var sets: [LiftSet]

    // Designated initializer
    init(
        id: UUID = UUID(),
        name: String,
        cat: String,
        sets: [LiftSet]
    ) {
        self.id = id
        self.name = name
        self.cat = cat
        self.sets = sets
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name, cat, sets
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let cat = try container.decode(String.self, forKey: .cat)
        let sets = try container.decode([LiftSet].self, forKey: .sets)
        self.init(id: id, name: name, cat: cat, sets: sets)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(cat, forKey: .cat)
        try container.encode(sets, forKey: .sets)
    }

    // Convert to dictionary for Firestore or similar
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "cat": cat,
            "sets": sets.map { [
                "id": $0.id.uuidString,
                "weight": $0.weight,
                "reps": $0.reps
            ] }
        ]
    }

}


struct LiftSet: Identifiable, Codable {
    let id: UUID
    var weight: Int
    var reps: Int

    init(
        id: UUID = UUID(),
        weight: Int,
        reps: Int
    ) {
        self.id = id
        self.weight = weight
        self.reps = reps
    }
}
extension LiftSet: Equatable {}

extension Exercise: Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool { lhs.id == rhs.id }
}
