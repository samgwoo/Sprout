import SwiftUI

struct AddSplitView: View {
    enum Split: String, CaseIterable, Identifiable {
        case push = "Push"
        case pull = "Pull"
        case legs = "Legs"
        var id: String { rawValue }
    }

    @State private var selectedSplit: Split = .push
    var onSave: (WorkoutHistoryEntry) -> Void

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

            Button("Save") {
                let entry = WorkoutHistoryEntry(
                    date: Date(),
                    split: selectedSplit.rawValue,
                    workout: []
                )
                onSave(entry)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}
