//
//  WorkoutHistoryDetailPopup.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 3/12/25.
//

import SwiftUI

struct WorkoutHistoryDetailPopup: View {
    var historyEntry: WorkoutHistoryEntry
    var dismissAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
  
            HStack {
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
            Button("Close") {
                dismissAction()
            }
            .foregroundColor(.green)
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}

#Preview {
    WorkoutHistoryDetailPopup(historyEntry: WorkoutHistoryEntry(
        date: Date(), workout: Workout(name: "Bench Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155])    )) {
    }
}
