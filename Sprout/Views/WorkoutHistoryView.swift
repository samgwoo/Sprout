//
//  WorkoutView2.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 2/24/25.
//


import SwiftUI

struct WorkoutHistoryView: View {
   @State var historyEntries: [WorkoutHistoryEntry]
    
   
    @State private var selectedHistoryEntry: WorkoutHistoryEntry?
    @State private var showingDetailPopup = false

    var body: some View {
        NavigationView {
            List(historyEntries) { entry in
                Button(action: {
                    selectedHistoryEntry = entry
                    withAnimation {
                        showingDetailPopup = true
                    }
                }) {
                    Text(entry.date, style: .date)
                        .padding()
                        .foregroundColor(.green)
                        .padding(-10)
                }
            }
            .navigationTitle("Workout History")
            .overlay(
                Group {
                    if showingDetailPopup, let entry = selectedHistoryEntry {
                 
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation { showingDetailPopup = false }
                            }
              
                        WorkoutHistoryDetailPopup(historyEntry: entry) {
                            withAnimation { showingDetailPopup = false }
                        }
                        .padding()
                    }
                }
            )
        }
    }
}

#Preview {
    WorkoutHistoryView(
        historyEntries: [WorkoutHistoryEntry(
            date: Date(),
            workout: Workout(name: "Bench Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155])
        )]
    )
}

