import SwiftUI

struct EntryRow: View {
    let entry: WorkoutHistoryEntry

    var body: some View {
        HStack {
            Text(entry.workout.first?.cat.uppercased() ?? "—")
                .font(.caption).bold().foregroundColor(.white)
                .padding(5).background(Color.green)
                .cornerRadius(7)
            Spacer()
            Text(entry.date, style: .date)
                .foregroundColor(.green)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ExerciseListView: View {
    @Binding var historyEntries: [WorkoutHistoryEntry]
    let entryID: UUID
    @EnvironmentObject var userVM: UserViewModel

    @State private var showingAddExercise = false
    @State private var newExerciseName = ""

    private var entryIndex: Int? {
        historyEntries.firstIndex { $0.id == entryID }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let idx = entryIndex {
                    ForEach(historyEntries[idx].workout) { exercise in
                        WorkoutView(
                            exercise: exercise,
                            workoutHistory: $historyEntries
                        )
                    }
                } else {
                    Text("Workout not found")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Exercises")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddExercise = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
        }
        .alert("New Exercise", isPresented: $showingAddExercise, actions: {
            TextField("Exercise name", text: $newExerciseName)
            Button("Add") {
                guard let idx = entryIndex,
                      !newExerciseName.trimmingCharacters(in: .whitespaces).isEmpty
                else { return }

                // create with one empty LiftSet
                let added = Exercise(
                    name: newExerciseName,
                    cat: newExerciseName,
                    sets: [LiftSet(weight: 0, reps: 0)]
                )
                historyEntries[idx].workout.append(added)

                // persist back to userVM
                if var u = userVM.user {
                    u.workoutHistory = historyEntries
                    userVM.updateUserProfile(newUser: u)
                }

                newExerciseName = ""
            }
            Button("Cancel", role: .cancel) {
                newExerciseName = ""
            }
        }, message: {
            Text("Enter a name for your new exercise")
        })
    }
}

struct WorkoutListView: View {
    @Binding var workoutHistory: [WorkoutHistoryEntry]
    @EnvironmentObject var userVM: UserViewModel
    @State private var showingAddWorkout = false

    // present entries in reverse chronological order
    private var sortedEntries: [WorkoutHistoryEntry] {
        workoutHistory.sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationView {
            List(sortedEntries) { entry in
                NavigationLink(
                    destination: ExerciseListView(
                        historyEntries: $workoutHistory,
                        entryID: entry.id
                    )
                ) {
                    EntryRow(entry: entry)
                }
            }
            .navigationTitle("Workout History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddWorkout = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddSplitView { newExercise in
                    let newEntry = WorkoutHistoryEntry(
                        date: Date(),
                        workout: [newExercise]
                    )
                    workoutHistory.append(newEntry)

                    if var u = userVM.user {
                        u.workoutHistory = workoutHistory
                        userVM.updateUserProfile(newUser: u)
                    }

                    showingAddWorkout = false
                }
            }
        }
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    @State static var sampleHistory: [WorkoutHistoryEntry] = [
        WorkoutHistoryEntry(
            date: Date().addingTimeInterval(-3600),
            workout: [
                Exercise(
                    name: "Bench Press",
                    cat: "Push",
                    sets: [
                        LiftSet(weight: 135, reps: 8),
                        LiftSet(weight: 145, reps: 10),
                        LiftSet(weight: 155, reps: 12)
                    ]
                ),
                Exercise(
                    name: "Overhead Press",
                    cat: "Push",
                    sets: [
                        LiftSet(weight: 135, reps: 8),
                        LiftSet(weight: 145, reps: 10),
                        LiftSet(weight: 155, reps: 12)
                    ]
                )
            ]
        ),
        WorkoutHistoryEntry(
            date: Date().addingTimeInterval(-86400),
            workout: [
                Exercise(
                    name: "Squat",
                    cat: "Legs",
                    sets: [
                        LiftSet(weight: 185, reps: 5),
                        LiftSet(weight: 185, reps: 5),
                        LiftSet(weight: 185, reps: 5),
                        LiftSet(weight: 185, reps: 5)
                    ]
                )
            ]
        )
    ]

    static var previews: some View {
        WorkoutListView(workoutHistory: $sampleHistory)
            .environmentObject(UserViewModel())
    }
}
