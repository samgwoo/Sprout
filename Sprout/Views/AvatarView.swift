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
    private var recentWorkouts: [WorkoutHistoryEntry] {
        guard let history = user?.workoutHistory else { return [] }
        return history.sorted { $0.date > $1.date }.prefix(3).map { $0 }
    }
    
    private var upper: Int {
        let push = recentWorkouts.map(\.pushStrength).max() ?? 0
        let pull = recentWorkouts.map(\.pullStrength).max() ?? 0
        return max(push, pull)
    }
    
    private var lower: Int {
        recentWorkouts.map(\.legStrength).max() ?? 0
    }
    
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
            // Background
            Image("background1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .ignoresSafeArea()
            
            GeometryReader { geo in
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .frame(width: 320, height: 520)
                            .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                        
                        ZStack {
                            // base + heart
                            Image("\(prefix)base").resizable().scaledToFit()
                            Image("\(prefix)heart").resizable().scaledToFit()
                            
                            if showEyes {
                                Image("\(prefix)eye").resizable().scaledToFit()
                            }
                            
                            Image("\(prefix)leftfoot").resizable().scaledToFit()
                            if showRightFoot {
                                Image("\(prefix)rightfoot").resizable().scaledToFit()
                            }
                            
                            if let t = torso { Image(t).resizable().scaledToFit() }
                            if let l = legs  { Image(l).resizable().scaledToFit() }
                            
                            ForEach(accessories, id: \.self) { Image($0).resizable().scaledToFit() }
                        }
                        .frame(width: 500, height: 500)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height) // force VStack to fill screen
                .contentShape(Rectangle())
            }
        }
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
