import SwiftUI

struct WorkoutView: View {
    @ObservedObject var exercise: Exercise
    @Binding var workoutHistory: [WorkoutHistoryEntry]

    var body: some View {
        VStack {
            // MARK: – Header
            Text(exercise.cat)
                .font(.title).bold().foregroundColor(.green)
                .padding(.top)

            // MARK: – Name + Set controls
            HStack {
                Button {
                    guard exercise.sets.count > 1 else { return }
                    exercise.sets.removeLast()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }

                Spacer()

                Text(exercise.name.uppercased())
                    .font(.headline).foregroundColor(.gray)

                Spacer()

                Button {
                    guard exercise.sets.count < 7 else { return }
                    exercise.sets.append(LiftSet(weight: 0, reps: 0))
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal)

            Divider().padding(.vertical)

            // MARK: – Column headers
            HStack {
                Spacer()
                Text("Weight")
                    .font(.caption).bold().foregroundColor(.gray)
                Spacer()
                Text("Reps")
                    .font(.caption).bold().foregroundColor(.gray)
                Spacer()
            }

            // MARK: – Sets editor
            ForEach($exercise.sets) { $set in
                HStack {
                    Spacer()

                    TextField(
                        "0",
                        value: $set.weight,
                        formatter: NumberFormatter()
                    )
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)

                    Spacer()

                    TextField(
                        "0",
                        value: $set.reps,
                        formatter: NumberFormatter()
                    )
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)

                    Spacer()
                }
                .padding(.vertical, 4)
            }

            Spacer()
        }
        .padding()
    }
}

struct WorkoutView_Previews: PreviewProvider {
    @State static var sampleHistory: [WorkoutHistoryEntry] = [
        WorkoutHistoryEntry(
            date: Date(),
            split: "Push",
            workout: [
                Exercise(
                    name: "Bench Press",
                    cat: "Push",
                    sets: [
                        LiftSet(weight: 135, reps: 8),
                        LiftSet(weight: 145, reps: 10),
                        LiftSet(weight: 155, reps: 12)
                    ]
                )
            ]
        )
    ]

    static var previews: some View {
        WorkoutView(
            exercise: sampleHistory[0].workout[0],
            workoutHistory: $sampleHistory
        )
    }
}
