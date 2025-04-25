import SwiftUI

struct ShopView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var selectedTab: Tab = .skins

    enum Tab: String, CaseIterable {
        case skins = "Skins"
        case accessories = "Accessories"
    }

    private let skinOptions = ["purplebase", "greenbase"]
    private let skinPrices = [200, 300]
    private let accessoryOptions = ["none", "flowers", "greenbowtie", "greenhair", "longhair1", "pigtail", "yellowbowtie"]
    private let accessoryPrices = [0, 50, 75, 60, 60, 80, 70, 120]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        ZStack {
            Image("background1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .opacity(0.3)
            if let user = userVM.user {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .foregroundColor(.yellow)
                        Text("\(user.coins)")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)

                    Picker("", selection: $selectedTab) {
                        ForEach(Tab.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(currentOptions.indices, id: \.self) { idx in
                                itemView(for: idx, user: user)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .navigationTitle("Shop")
                .font(Constants.headerFont)
            } else {
                ProgressView("Loading…")
            }
        }
    }

    private var currentOptions: [String] {
        selectedTab == .skins ? skinOptions : accessoryOptions
    }

    private func currentPrice(at idx: Int) -> Int {
        selectedTab == .skins ? skinPrices[idx] : accessoryPrices[idx]
    }

    private func isOwned(_ idx: Int, user: User) -> Bool {
        switch selectedTab {
        case .skins:
            return user.appearance.unlockedSkins.contains(idx)
        case .accessories:
            return idx == 0 || user.appearance.unlockedAccessories.contains(idx)
        }
    }

    private func isEquipped(_ idx: Int, user: User) -> Bool {
        switch selectedTab {
        case .skins:
            return user.appearance.skinColor == idx
        case .accessories:
            if idx == 0 {
                return user.appearance.accessory1 == nil &&
                       user.appearance.accessory2 == nil &&
                       user.appearance.accessory3 == nil
            }
            return [user.appearance.accessory1,
                    user.appearance.accessory2,
                    user.appearance.accessory3]
                   .contains(idx)
        }
    }

    private func handleTap(_ idx: Int, owned: Bool, equipped: Bool, price: Int) {
        guard var user = userVM.user else { return }
        switch selectedTab {
        case .skins:
            if !owned {
                userVM.buySkin(at: idx, price: price)
            } else if !equipped {
                user.appearance.skinColor = idx
                userVM.updateUserProfile(newUser: user)
            }
        case .accessories:
            if !owned {
                userVM.buyAccessory(at: idx, price: price)
            } else if idx == 0 {
                user.appearance.accessory1 = nil
                user.appearance.accessory2 = nil
                user.appearance.accessory3 = nil
                userVM.updateUserProfile(newUser: user)
            } else if !equipped {
                let slots = [user.appearance.accessory1, user.appearance.accessory2, user.appearance.accessory3]
                if slots[0] == nil {
                    user.appearance.accessory1 = idx
                } else if slots[1] == nil {
                    user.appearance.accessory2 = idx
                } else if slots[2] == nil {
                    user.appearance.accessory3 = idx
                } else {
                    user.appearance.accessory1 = slots[1]
                    user.appearance.accessory2 = slots[2]
                    user.appearance.accessory3 = idx
                }
                userVM.updateUserProfile(newUser: user)
            }
        }
    }

    private func buttonTitle(_ idx: Int, owned: Bool, equipped: Bool) -> String {
        switch selectedTab {
        case .skins:
            if !owned { return "Buy" }
            return equipped ? "Equipped" : "Equip"
        case .accessories:
            if !owned { return "Buy" }
            if idx == 0 { return isEquipped(idx, user: userVM.user!) ? "Equipped" : "None" }
            return equipped ? "Equipped" : "Equip"
        }
    }

    private func buttonColor(_ idx: Int, owned: Bool, equipped: Bool, coins: Int, price: Int) -> Color {
        if !owned { return coins >= price ? .accentGreen : .gray }
        return equipped ? .gray : .accentGreen
    }

    private func buttonDisabled(_ idx: Int, owned: Bool, equipped: Bool, coins: Int, price: Int) -> Bool {
        switch selectedTab {
        case .skins:
            return (!owned && coins < price) || equipped
        case .accessories:
            if !owned { return coins < price }
            return equipped
        }
    }

    @ViewBuilder
    private func itemView(for idx: Int, user: User) -> some View {
        let imageName = currentOptions[idx]
        let price = currentPrice(at: idx)
        let owned = isOwned(idx, user: user)
        let equip = isEquipped(idx, user: user)
        let size: CGFloat = selectedTab == .accessories ? 100 : 80

        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: size, height: size)
                    .shadow(radius: 2)
                if let ui = UIImage(named: imageName) {
                    let trimmed = ui.trimmingTransparentPixels()
                    Image(uiImage: trimmed)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.8, height: size * 0.8)
                        .clipped()
                }
            }
            .frame(width: size, height: size)
            Text(owned ? (equip ? "Equipped" : (selectedTab == .accessories && idx == 0 ? "Clear All" : "Owned")) : "\(price) coins")
                .font(Constants.searchFont)
                .foregroundColor(owned ? .secondary : (user.coins >= price ? .accentGreen : .pink))
            Button {
                handleTap(idx, owned: owned, equipped: equip, price: price)
            } label: {
                Text(buttonTitle(idx, owned: owned, equipped: equip))
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(buttonColor(idx, owned: owned, equipped: equip, coins: user.coins, price: price))
                    .cornerRadius(6)
            }
            .disabled(buttonDisabled(idx, owned: owned, equipped: equip, coins: user.coins, price: price))
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(equip ? Color.accentGreen : (owned ? Color.secondary : Color.accentGreen), lineWidth: 2)
        )
    }
}
