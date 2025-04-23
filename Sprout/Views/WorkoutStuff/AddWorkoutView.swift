//
//  AddWorkoutView.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 2/21/25.
//

import SwiftUI

struct AddWorkoutView: View {
    @State private var name = ""
    @State private var selectedSplit = 1
    @State private var sets = ""
    var onSave: (Workout) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Workout Details")) {
                TextField("Workout Name", text: $name)
                Picker("Split", selection: $selectedSplit) {
                    Text("Push").tag(1)
                    Text("Pull").tag(2)
                    Text("Legs").tag(3)
                }
              
                TextField("Number of Sets", text: $sets)
                    .keyboardType(.numberPad)
            }
            Section {
                Button("Save") {
                guard let setCount = Int(sets), setCount > 0 else {

                        return
                    }
                    let category: String
                    switch selectedSplit {
                    case 1: category = "Push"
                    case 2: category = "Pull"
                    case 3: category = "Legs"
                    default: category = "Push"
                    }
                    
                    let newWorkout = Workout(
                        name: name,
                        cat: category,
                        set: setCount,
                        rep: Array(repeating: 0, count: setCount),
                        weight: Array(repeating: 0, count: setCount)
                    )
                    onSave(newWorkout)
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(width: 300, height: 300)
    }
}

