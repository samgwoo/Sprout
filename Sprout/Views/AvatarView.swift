//
//  AvatarView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/6/25.
//

import SwiftUI

struct AvatarView: View {
    @EnvironmentObject var user: User

    // Asset names
    private let skinTones        = ["skin1", "skin2", "skin3"]
    private let accessoryAssets  = ["hat1", "glasses1", "necklace1"]

    // Pick a border color based on heart rate
    private var borderColor: Color {
        let hr = user.healthData.heartRate
        switch hr {
        case ..<60:    return .blue    // resting
        case 60..<100: return .green   // normal
        default:       return .red     // elevated
        }
    }

    var body: some View {
        AvatarPreview(
            skinImage:     skinTones[safe: user.appearance.skinColor] ?? skinTones[0],
            accessories:   selectedAccessories()
        )
        .frame(height: 250)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 4)
        )
    }

    // Helper to pull out the chosen accessory image names
    private func selectedAccessories() -> [String] {
        [user.appearance.accessory1,
         user.appearance.accessory2,
         user.appearance.accessory3]
        .compactMap { $0 }                             // drop nils
        .compactMap { accessoryAssets[safe: $0] }     // map to names, drop OOB
    }
}

struct AvatarPreview: View {
    let skinImage:    String
    let accessories:  [String]

    var body: some View {
        Image("avatarBase")
            .resizable()
            .scaledToFit()
            // skin tone
            .overlay(
                Image(skinImage)
                    .resizable()
                    .scaledToFit()
            )
            // accessories
            .overlay(
                ForEach(accessories.indices, id: \.self) { i in
                    Image(accessories[i])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .offset(accessoryOffset(for: i))
                }
            )
    }

    // adjust each accessory’s position
    private func accessoryOffset(for index: Int) -> CGSize {
        switch index {
        case 0: return CGSize(width: 0,   height: -80)  // e.g. hat
        case 1: return CGSize(width: 0,   height: 20)   // e.g. glasses
        case 2: return CGSize(width: 0,   height: 80)   // e.g. necklace
        default:return .zero
        }
    }
}

// Safe‐indexing extension to avoid OOB crashes
private extension Array {
    subscript(safe idx: Int) -> Element? {
        indices.contains(idx) ? self[idx] : nil
    }
}




