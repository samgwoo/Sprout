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
    
    func toDictionary() -> [String: Any] {
        return [
            "skinColor": skinColor,
            "accessory1": accessory1 as Any,  // Ensuring optional values are handled correctly
            "accessory2": accessory2 as Any,
            "accessory3": accessory3 as Any,
            "unlockedSkins": unlockedSkins,
            "unlockedAccessories": unlockedAccessories
        ]
    }
    
}
