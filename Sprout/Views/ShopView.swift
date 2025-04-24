import SwiftUI

struct ShopView: View {
    @EnvironmentObject var appearance: Appearance
    @State private var selectedTab: Tab = .skins

    enum Tab: String, CaseIterable {
        case skins       = "Skins"
        case accessories = "Accessories"
    }

    // Your assets
    private let skinOptions      = ["skin1", "skin2", "skin3"]
    private let accessoryOptions = ["hat1", "glasses1", "necklace1"]

    // Three flexible columns = exactly 3 items per row
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 3
    )

    var body: some View {
        VStack {
            // Picker for Skins vs Accessories
            Picker("", selection: $selectedTab) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Grid with 3 items per row
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(currentOptions.indices, id: \.self) { index in
                        VStack(spacing: 8) {
                            Image(currentOptions[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)

                            let owned = isUnlocked(index)
                            Text(owned ? "Owned" : "Buy")
                                .font(Constants.searchFont)
                                .foregroundColor(owned ? .secondary : .accentGreen)
                                .lineLimit(1)
                                .fixedSize()

                            Button(action: {
                                if !owned {
                                    if selectedTab == .skins {
                                        appearance.unlockedSkins.append(index)
                                    } else {
                                        appearance.unlockedAccessories.append(index)
                                    }
                                }
                            }) {
                                EmptyView()
                            }
                            .buttonStyle(.plain)
                            .disabled(owned)
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity) // split evenly
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isUnlocked(index) ? Color.secondary : Color.accentGreen,
                                        lineWidth: 2)
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Shop")
        .font(Constants.headerFont)
    }

    // MARK: - Helpers

    private var currentOptions: [String] {
        selectedTab == .skins ? skinOptions : accessoryOptions
    }

    private func isUnlocked(_ index: Int) -> Bool {
        if selectedTab == .skins {
            return appearance.unlockedSkins.contains(index)
        } else {
            return appearance.unlockedAccessories.contains(index)
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShopView()
                .environmentObject(
                    Appearance(
                        skinColor: 0,
                        accessory1: nil,
                        accessory2: nil,
                        accessory3: nil,
                        unlockedSkins: [0],
                        unlockedAccessories: []
                    )
                )
        }
    }
}
