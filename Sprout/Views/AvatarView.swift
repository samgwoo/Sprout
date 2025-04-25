import SwiftUI

struct AvatarView: View {
    @EnvironmentObject var userVM: UserViewModel
    

    private let skins   = ["purple", "green", "yellow"]
    private let accKeys = ["flowers","greenbowtie",
                           "greenhair","longhair1","pigtail",
                           "yellowbowtie"]
    
    private var user: User?          { userVM.user }
    
    private var prefix: String       { skins[user?.appearance.skinColor ?? 0] }
    
    private var latestWorkout: WorkoutHistoryEntry? {
            user?.workoutHistory.max { $0.date < $1.date }
        }
    private var hd: HealthData {
        user?.healthData.max { $0.timeStamp < $1.timeStamp } ?? HealthData()
    }
    
    
    private var upper: Int {
        guard let w = latestWorkout else { return 0 }
        return max(w.pushStrength, w.pullStrength)
    }
    private var lower: Int { latestWorkout?.legStrength ?? 0 }
    
    // missing-sleep ⇒ no eyes
    private var showEyes: Bool {
        hd.sleepHours >= 6
    }
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
        guard let ap = user?.appearance else { return [] }

        return [ap.accessory1, ap.accessory2, ap.accessory3]
            .compactMap { idxOpt in
                guard let i = idxOpt, i < accKeys.count else { return nil }
                let key = accKeys[i]

                if key.starts(with: "longhair") {
                    guard prefix == "purple" else { return nil }

                    return "longhair\(upper + 1)"
                }

                return key
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
        .frame(width: 600, height: 600)          // bigger character
    }
}



#Preview {
    let auth = AuthViewModel()
    let previewUser = User(
        uid: "demo",
        email: "demo@sprout.app",
        appearance: Appearance(skinColor: 0, accessory1: 0, accessory2: 3),
        healthData: [
            HealthData(
                stepCount: 0,
                distanceWalkingRunning: 0,
                flightsClimbed: 0,
                heartRateVariability: 82,
                bodyMass: 0,
                height: 0,
                environmentalAudioExposure: 0,
                headphoneAudioExposure: 0,
                sleepHours: 5,
                walkingSpeed: 0,
                walkingAsymmetryPercentage: 15,
                walkingDoubleSupportPercentage: 0
            )
        ],
        workoutHistory: [
            WorkoutHistoryEntry(date: .now, split: "legs", workout: [
                Exercise(name: "Squat", cat: "legs", sets: [LiftSet(weight: 150, reps: 5)]),
                Exercise(name: "Bench Press", cat: "push", sets: [LiftSet(weight: 170, reps: 5)])
            ])
        ],
        coins: 0
    )
    let vm: UserViewModel = {
        let v = UserViewModel(authVM: auth)
        v.user = previewUser
        return v
    }()
    AvatarView()
        .environmentObject(vm)
        .padding()
}
