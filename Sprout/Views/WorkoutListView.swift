//
//  WorkoutView2.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 2/24/25.
//

import SwiftUI

struct WorkoutListView: View {
    
    @Binding var workouts: [Workout]
    @State private var showingAddWorkout = false
    @State private var workoutHistory: [WorkoutHistoryEntry] = []
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    HStack{
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
                    
                    List($workouts, id: \.id) { $workout in
                        
                        HStack {
                            
                            Text(workout.cat.uppercased())
                                .font(.caption)
                                .bold()
                                .foregroundColor(.black)
                                .padding(5)
                                .background(Color.green)
                                .cornerRadius(7)
                                .padding(-5)
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            
                            
                            NavigationLink(destination: WorkoutView(w: workout, workoutHistory: $workoutHistory)) {
                                Text(workout.name)
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
                            workouts.append(newWorkout)
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
        
        workouts: Binding.constant([
        Workout(name: "Bench Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155]),
        Workout(name: "Shoulder Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [95, 105, 115]),
        Workout(name: "PullUps", cat: "Pull", set: 3, rep: [8, 10, 12], weight: [95, 105, 115]),
        Workout(name: "Squat", cat: "Legs", set: 3, rep: [8, 10, 12], weight: [95, 105, 115])
    ]))
}

