//
//  WorkoutView2.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 2/24/25.
//

import SwiftUI

struct WorkoutListView: View {
    @Binding var workoutHistory: [WorkoutHistoryEntry]
    @State private var showingAddWorkout = false
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Workouts")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.green)
                        Spacer()
                        Button(action: {
                            showingAddWorkout = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    List($workoutHistory, id: \.id) { $entry in
                        HStack {
                            Text(entry.workout.cat.uppercased())
                                .font(.caption)
                                .bold()
                                .foregroundColor(.black)
                                .padding(5)
                                .background(Color.green)
                                .cornerRadius(7)
                                .padding(-5)

                            Spacer()

                            NavigationLink(destination: WorkoutView(w: entry.workout, workoutHistory: $workoutHistory)) {
                                Text(entry.workout.name)
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }

                            Spacer()
                        }
                    }
                }

                if showingAddWorkout {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showingAddWorkout = false
                            }
                        }

                    VStack {
                        AddWorkoutView { newWorkout in
                            let newEntry = WorkoutHistoryEntry(date: Date(), workout: newWorkout)
                            workoutHistory.append(newEntry)
                            
                            if var user = userViewModel.user {
                                user.workoutHistory = workoutHistory
                                userViewModel.updateUserProfile(newUser: user)
                            }

                            withAnimation {
                                showingAddWorkout = false
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .transition(.move(edge: .top))
                    }
                    .zIndex(1)
                }
            }
        }
    }
}


#Preview {
    WorkoutListView(
        workoutHistory: Binding.constant([
            WorkoutHistoryEntry(date: Date(), workout: Workout(name: "Bench Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155])),
            WorkoutHistoryEntry(date: Date(), workout: Workout(name: "Shoulder Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [95, 105, 115]))
        ])
    )
}

