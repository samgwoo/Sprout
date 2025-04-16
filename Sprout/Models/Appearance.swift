//
//  Appearance.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/11/25.
//

import Foundation

class Appearance: ObservableObject, Codable {
    var skinColor: Int
    var accessory1: Int?
    var accessory2: Int?
    var accessory3: Int?
    var unlockedSkins: [Int]
    var unlockedAccessories: [Int]
    
    init(skinColor: Int = 0, accessory1: Int? = nil, accessory2: Int? = nil, accessory3: Int? = nil, unlockedSkins: [Int], unlockedAccessories: [Int]) {
        self.skinColor = skinColor
        self.accessory1 = accessory1
        self.accessory2 = accessory2
        self.accessory3 = accessory3
        self.unlockedSkins = unlockedSkins
        self.unlockedAccessories = unlockedAccessories
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case skinColor
        case accessory1
        case accessory2
        case accessory3
        case unlockedSkins
        case unlockedAccessories
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let skinColor = try container.decode(Int.self, forKey: .skinColor)
        let accessory1 = try container.decodeIfPresent(Int.self, forKey: .accessory1)
        let accessory2 = try container.decodeIfPresent(Int.self, forKey: .accessory2)
        let accessory3 = try container.decodeIfPresent(Int.self, forKey: .accessory3)
        let unlockedSkins = try container.decode([Int].self, forKey: .unlockedSkins)
        let unlockedAccessories = try container.decode([Int].self, forKey: .unlockedAccessories)
        
        self.init(skinColor: skinColor, accessory1: accessory1, accessory2: accessory2, accessory3: accessory3, unlockedSkins: unlockedSkins, unlockedAccessories: unlockedAccessories)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(skinColor, forKey: .skinColor)
        try container.encode(accessory1, forKey: .accessory1)
        try container.encode(accessory2, forKey: .accessory2)
        try container.encode(accessory3, forKey: .accessory3)
        try container.encode(unlockedSkins, forKey: .unlockedSkins)
        try container.encode(unlockedAccessories, forKey: .unlockedAccessories)
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "skinColor": skinColor,
            "accessory1": accessory1 as Any,  // Ensures optionals get handled
            "accessory2": accessory2 as Any,
            "accessory3": accessory3 as Any,
            "unlockedSkins": unlockedSkins,
            "unlockedAccessories": unlockedAccessories
        ]
    }
}
