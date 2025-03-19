//
//  CharacterView.swift
//  Sprout
//
//  Created by Eric McCoy (student LM) on 3/18/25.
//

import SwiftUI

struct CharacterView: View {
    @State private var selectedCategory: String = "Hair"
    @State private var selectedSkinTone: Int = 3
    @State private var selectedHairColor: Int = 2
    @State private var selectedEyeColor: Int = 1
    
    

    let categories = ["Skin Tone", "Hair", "Eyes"]
    let skinTones = ["1x", "2x", "3x"]
    let hairColors = ["hair1", "hair2", "hair3", "hair4"]
    let eyeShape = ["eye1", "eye2", "eye3", "eye4"]

    var body: some View {
        VStack {
            AvatarPreview(skinTone: selectedSkinTone, hairColor: selectedHairColor, eyeShape: selectedEyeColor)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .padding()
                            .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.3))
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedCategory = category
                            }
                    }
                }
            }
            .padding()

            
            
            
            // Customization Part
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 10) {
                    
                    if selectedCategory == "Skin Tone" {
                        ForEach(skinTones.indices, id: \.self) { index in
                            Image("skin\(index + 1)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedSkinTone = index + 1
                                }
                        }
                    } else if selectedCategory == "Hair" {
                        ForEach(hairColors.indices, id: \.self) { index in
                            Image("hair\(index + 1)") // Ensuring correct image reference
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedHairColor = index + 1
                                }
                        }
                    }
                    
                    else if selectedCategory == "Eyes" {
                        ForEach(hairColors.indices, id: \.self) { index in
                            Image("eye\(index + 1)") // Ensuring correct image reference
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedEyeColor = index + 1
                                }
                        }
                    }
                    
                    
                }
            }
            .padding()
        }
    }







// Avatar Preview
struct AvatarPreview: View {
    var skinTone: Int
    var hairColor: Int
    var eyeShape: Int

    var body: some View {
        VStack {
            Image("avatarBase")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .overlay(
                    Image("skin\(skinTone)")
                        .resizable()
                        .scaledToFit()
                )
                .overlay(
                    Image("hair\(hairColor)")
                        .resizable()
                        .scaledToFit()
                        .frame(height:90)
                        .position(x: 130,y: 65)
                )
                .overlay(
                Image("eye\(eyeShape)")
                    .resizable()
                    .scaledToFit()
                    .frame(height:50)
                    .position(x: 123,y: 85)
                )
        }
    }
}


#Preview {
    CharacterView()
}
