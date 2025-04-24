import SwiftUI

struct AvatarView: View {
    @EnvironmentObject var user: User
    
    // MARK: static tables
    private let skins   = ["green", "purple", "yellow"]
    private let accKeys = ["greenbowtie", "greenhair", "pigtail", "longhair", "yellowbowtie"]
    
    // MARK:- runtime helpers
    private var prefix: String                     { skins[user.appearance.skinColor] }
    private var latest: WorkoutHistoryEntry?       { user.workoutHistory.max { $0.date < $1.date } }
    private var hd: HealthData                     { user.healthData }
    
    private var upper: Int {
        guard let w = latest else { return 0 }
        return max(w.pushStrength, w.pullStrength)
    }
    private var lower: Int { latest?.legStrength ?? 0 }
    
    // missing-sleep ⇒ no eyes
    private var showEyes: Bool {
        hd.sleepHours >= 6          // slept enough?  yes ⇒ draw eyes
    }
    // high gait asymmetry (>10 %) ⇒ drop right foot
    private var showRightFoot: Bool {
        hd.walkingAsymmetryPercentage < 10
    }
    
    private var torso: String? {
        switch upper {
        case 1: return "\(prefix)torso1"
        case 2: return "\(prefix)torso2"
        default: return nil
        }
    }
    private var legs: String? {
        switch lower {
        case 1: return "\(prefix)legs1"
        case 2: return "\(prefix)legs2"
        default: return nil
        }
    }
    
    private var accessories: [String] {
        [user.appearance.accessory1,
         user.appearance.accessory2,
         user.appearance.accessory3]
        .compactMap { idxOpt in
            guard let i = idxOpt, i < accKeys.count else { return nil }
            let key = accKeys[i]
            if key == "longhair", prefix != "purple" { return nil }          // longhair only on purple skin
            return key == "longhair" ? "longhair\(upper + 1)" : key
        }
    }
    
    // MARK:- view
    var body: some View {
        ZStack {
            // base + heart
            Image("\(prefix)base").resizable().scaledToFit()
            Image("\(prefix)heart").resizable().scaledToFit()
            
            // conditional eye
            if showEyes {
                Image("\(prefix)eye").resizable().scaledToFit()
            }
            
            // feet (always left, right only if gait OK)
            Image("\(prefix)leftfoot").resizable().scaledToFit()
            if showRightFoot {
                Image("\(prefix)rightfoot").resizable().scaledToFit()
            }
            
            // strength overlays
            if let t = torso { Image(t).resizable().scaledToFit() }
            if let l = legs  { Image(l).resizable().scaledToFit() }
            
            // accessories
            ForEach(accessories, id: \.self) { Image($0).resizable().scaledToFit() }
        }
        .frame(width: 400, height: 400)          // bigger character
    }
}



#Preview {
    let squat = Exercise(
        name: "Squat",
        cat: "legs",
        sets: [LiftSet(weight: 260, reps: 5)]
    )
    
    let bench = Exercise(
        name: "Bench Press",
        cat: "push",
        sets: [LiftSet(weight: 170, reps: 5)]
    )
    
    let entry = WorkoutHistoryEntry(date: .now, workout: [squat, bench])
    
    let previewUser = User(
        uid: "demo",
        email: "demo@sprout.app",
        appearance: Appearance(
            skinColor: 0,
            accessory1: 0,
            accessory2: 3
        ),
        healthData: {
            var h = HealthData()
            h.heartRateVariability = 82
            return h
        }(),
        workoutHistory: [entry]
    )
    
    AvatarView()
        .environmentObject(previewUser)
        .padding()
}
