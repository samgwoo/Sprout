//
//  WorkoutView.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 2/19/25.
//

import SwiftUI

struct WorkoutView: View {
    @ObservedObject var w: Workout
    @State private var showingHistoryView = false
    @State private var selectedHistoryEntry: WorkoutHistoryEntry?
    @State private var showingHistoryDetail = false
    @Binding var workoutHistory: [WorkoutHistoryEntry]

    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Text(w.cat)
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                }
                Spacer()

                HStack {
                    Button {
                        if w.set > 1 {
                            w.set -= 1
                            w.weight[w.weight.count - 1] = 0
                        }
                    } label: {
                        Image(systemName: "minus")
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal)

                    Spacer()
                    Text(w.name.uppercased())
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()

                    Button {
                        if w.set < 7 {
                            w.set += 1
                            w.rep.append(0)
                            w.weight.append(0)
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                }

                Rectangle()
                    .fill(Color.green)
                    .frame(height: 5)
                    .padding(.horizontal)

                HStack {
                    Spacer()
                    Text("Weight")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Reps")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                    Spacer()
                }

                ForEach(0..<w.set, id: \.self) { i in
                    HStack {
                        Spacer()
                        if w.weight[i] != -5 {
                            TextField(
                                "0",
                                text: Binding(
                                    get: { "\(w.weight[i])" },
                                    set: { if let val = Int($0) { w.weight[i] = val } }
                                )
                            )
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 50)
                            .foregroundColor(.gray)
                        }
                        Spacer()
                        TextField(
                            "0",
                            text: Binding(
                                get: { "\(w.rep[i])" },
                                set: { if let val = Int($0) { w.rep[i] = val } }
                            )
                        )
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                        .foregroundColor(.gray)
                        Spacer()
                    }
                }

                Spacer()
            }

            Button {
                showingHistoryView = true
            } label: {
                VStack {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.green)
                    Text("History")
                        .font(.caption)
                        .bold()
                        .padding(4)
                        .foregroundColor(.green)
                }
            }
        }
        .sheet(isPresented: $showingHistoryView) {
            WorkoutHistoryView(historyEntries: workoutHistory)
        }
    }
}

#Preview {
    WorkoutView(
        w: Workout(name: "Bench", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155]),
        workoutHistory: .constant([])
    )
}
