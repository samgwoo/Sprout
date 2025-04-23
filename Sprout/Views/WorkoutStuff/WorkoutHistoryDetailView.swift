//
//  WorkoutHistoryDetailView.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 3/6/25.
//

import SwiftUI

struct WorkoutHistoryDetailView: View {
    var historyEntry: WorkoutHistoryEntry
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            
            HStack{
                Text(historyEntry.workout.name)
                    .foregroundColor(.green)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            Divider()
            
            Text(historyEntry.date, style: .date)
          
            Divider()
  
            
          
            VStack {
    ForEach(0..<historyEntry.workout.set, id: \.self) { index in
    HStack {
        Text("Set \(index + 1): ")
            .bold()
        
        Text("Reps: \(historyEntry.workout.rep[index])")
        Text("Weight: \(historyEntry.workout.weight[index])")
                    }
                }
            }
            .padding()
            
            Spacer()
            Button {
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Close")
                    .foregroundColor(.green)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    WorkoutHistoryDetailView(
        historyEntry: WorkoutHistoryEntry(
            date: Date(),
            workout: Workout(name: "Bench Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155])
        )
    )
}

#Preview {
    WorkoutHistoryDetailView(
            historyEntry: WorkoutHistoryEntry(
                date: Date(),
                workout: Workout(name: "Bench Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155])
            )
        )
}
