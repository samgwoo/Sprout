//
//  AvatarView.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 3/6/25.
//

import SwiftUI

struct AvatarView: View {
    @State private var selectedCategory: String = "Skin Tone"
    @State private var selectedSkinTone: Int = 0
    @State private var selectedHairStyle: Int = 0
    @State private var selectedEyeStyle: Int = 0

    let categories = ["Skin Tone", "Hair", "Eyes"]
    let skinTones = ["skin1", "skin2", "skin3"]
    let hairStyles = ["hair1", "hair2", "hair3", "hair4"]
    let eyeStyles = ["eye1", "eye2", "eye3", "eye4"]

    var body: some View {
        VStack(spacing: 30) {
            AvatarPreview(
                skinTone: skinTones[selectedSkinTone],
                hairColor: hairStyles[selectedHairStyle],
                eyeShape: eyeStyles[selectedEyeStyle]
            )
            .frame(height: 250)

            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .foregroundColor(.white)
                            .padding()
                            .background(selectedCategory == category ? Color.green : Color.tealy)
                            .cornerRadius(10)
                    }
                }
            }

            HStack(spacing: 15) {
                if selectedCategory == "Skin Tone" {
                    ForEach(skinTones.indices, id: \.self) { index in
                        Image(skinTones[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .overlay(Circle().stroke(index == selectedSkinTone ? Color.green : Color.clear, lineWidth: 3))
                            .onTapGesture {
                                selectedSkinTone = index
                            }
                    }
                } else if selectedCategory == "Hair" {
                    ForEach(hairStyles.indices, id: \.self) { index in
                        Image(hairStyles[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .overlay(Circle().stroke(index == selectedHairStyle ? Color.green : Color.clear, lineWidth: 3))
                            .onTapGesture {
                                selectedHairStyle = index
                            }
                    }
                } else if selectedCategory == "Eyes" {
                    ForEach(eyeStyles.indices, id: \.self) { index in
                        Image(eyeStyles[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .overlay(Circle().stroke(index == selectedEyeStyle ? Color.green : Color.clear, lineWidth: 3))
                            .onTapGesture {
                                selectedEyeStyle = index
                            }
                    }
                }
            }
            .padding(.bottom)
        }
        .padding()
    }
}


// Avatar Preview
struct AvatarPreview: View {
    var skinTone: String
    var hairColor: String
    var eyeShape: String

    var body: some View {
        VStack {
            Image("avatarBase")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .overlay(
                    Image(skinTone)
                        .resizable()
                        .scaledToFit()
                )
                .overlay(
                    Image(hairColor)
                        .resizable()
                        .scaledToFit()
                        .frame(height:90)
                        .position(x: 130,y: 65)
                )
                .overlay(
                Image(eyeShape)
                    .resizable()
                    .scaledToFit()
                    .frame(height:50)
                    .position(x: 123,y: 85)
                )
        }
    }
}

#Preview {
    AvatarView()
}




