import SwiftUI

struct AddSplitView: View {
    enum Split: String, CaseIterable, Identifiable {
        case push = "Push"
        case pull = "Pull"
        case legs = "Legs"
        var id: String { rawValue }
    }

    @State private var selectedSplit: Split = .push
    var onSave: (Exercise) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Split")
                .font(.headline)

            Picker("Split", selection: $selectedSplit) {
                ForEach(Split.allCases) { split in
                    Text(split.rawValue).tag(split)
                }
            }
            .pickerStyle(.segmented)

            Button(action: save) {
                Text("Save")
                    .font(.body).bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    private func save() {
        let newExercise = Exercise(
            name: selectedSplit.rawValue,
            cat: selectedSplit.rawValue,
            sets: [LiftSet(weight: 0, reps: 0)]
        )
        onSave(newExercise)
        dismiss()
    }
}
