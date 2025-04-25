import SwiftUI
import HealthKit
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class HealthViewModel: ObservableObject {
    
    @Published var healthData: HealthData?
    
    private let healthStore = HKHealthStore()
    private var authVM: AuthViewModel
    private let userVM : UserViewModel
    
    
    private var userId: String? {  authVM.userSession?.uid }
    
    init(authVM: AuthViewModel, userVM: UserViewModel) {
        self.authVM = authVM
        self.userVM = userVM
        requestHealthKitPermission()
    }
    
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    private func requestHealthKitPermission() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let toRead: Set<HKObjectType> = [
            .quantityType(forIdentifier: .stepCount)!,
            .quantityType(forIdentifier: .distanceWalkingRunning)!,
            .quantityType(forIdentifier: .flightsClimbed)!,
            .quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            .quantityType(forIdentifier: .bodyMass)!,
            .quantityType(forIdentifier: .height)!,
            .quantityType(forIdentifier: .environmentalAudioExposure)!,
            .quantityType(forIdentifier: .headphoneAudioExposure)!,
            .categoryType(forIdentifier: .sleepAnalysis)!,
            .quantityType(forIdentifier: .walkingSpeed)!,
            .quantityType(forIdentifier: .walkingAsymmetryPercentage)!,
            .quantityType(forIdentifier: .walkingDoubleSupportPercentage)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: toRead) { ok, err in
            if ok { Task { await self.fetchHealthData() } }
        }
    }
    
    func fetchHealthData() {
        guard userId != nil else {
            print("User not logged in; cannot fetch HealthKit data.")
            return
        }
        
        let group = DispatchGroup()
        
        var stepCount                  = 0
        var distanceWalkingRunning     = 0.0
        var flightsClimbed             = 0
        var heartRateVariability       = 0.0
        var bodyMass                   = 0.0
        var height                     = 0.0
        var environmentalAudioExposure = 0.0
        var headphoneAudioExposure     = 0.0
        var sleepHours                 = 0.0
        var walkingSpeed               = 0.0
        var walkingAsymmetryPercentage = 0.0
        var walkingDoubleSupportPercentage = 0.0
        
        // helper for one-off quantity samples
        func sample(
            _ id: HKQuantityTypeIdentifier,
            unit: HKUnit,
            assign: @escaping (Double) -> Void
        ) {
            if let type = HKQuantityType.quantityType(forIdentifier: id) {
                group.enter()
                let q = HKSampleQuery(sampleType: type,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [.init(key: HKSampleSortIdentifierStartDate,
                                                              ascending: false)]) { _, res, _ in
                    if let s = res?.first as? HKQuantitySample {
                        assign(s.quantity.doubleValue(for: unit))
                    }
                    group.leave()
                }
                healthStore.execute(q)
            }
        }
        
        sample(.stepCount,                       unit: .count()) { stepCount = Int($0) }
        sample(.distanceWalkingRunning,          unit: .meter()) { distanceWalkingRunning = $0 }
        sample(.flightsClimbed,                  unit: .count()) { flightsClimbed = Int($0) }
        sample(.heartRateVariabilitySDNN,        unit: .secondUnit(with: .milli)) { heartRateVariability = $0 }
        sample(.bodyMass,                        unit: .gramUnit(with: .kilo))   { bodyMass = $0 }
        sample(.height,                          unit: .meter())                { height = $0 }
        sample(.environmentalAudioExposure,      unit: .decibelAWeightedSoundPressureLevel()) { environmentalAudioExposure = $0 }
        sample(.headphoneAudioExposure,          unit: .decibelAWeightedSoundPressureLevel()) { headphoneAudioExposure = $0 }
        sample(.walkingSpeed,                    unit: .meter().unitDivided(by: .second()))  { walkingSpeed = $0 }
        sample(.walkingAsymmetryPercentage,      unit: .percent())              { walkingAsymmetryPercentage = $0 }
        sample(.walkingDoubleSupportPercentage,  unit: .percent())              { walkingDoubleSupportPercentage = $0 }
        
        // sleep last 24 h
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let since = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            let pred  = HKQuery.predicateForSamples(withStart: since, end: .now, options: .strictEndDate)
            group.enter()
            let q = HKSampleQuery(sampleType: sleepType, predicate: pred,
                                  limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, res, _ in
                let seconds = (res as? [HKCategorySample])?
                    .reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) } ?? 0
                sleepHours = seconds / 3600
                group.leave()
            }
            healthStore.execute(q)
        }
        
        // finish
        group.notify(queue: .main) {
            let hd = HealthData(
                stepCount: stepCount,
                distanceWalkingRunning: distanceWalkingRunning,
                flightsClimbed: flightsClimbed,
                heartRateVariability: heartRateVariability,
                bodyMass: bodyMass,
                height: height,
                environmentalAudioExposure: environmentalAudioExposure,
                headphoneAudioExposure: headphoneAudioExposure,
                sleepHours: sleepHours,
                walkingSpeed: walkingSpeed,
                walkingAsymmetryPercentage: walkingAsymmetryPercentage,
                walkingDoubleSupportPercentage: walkingDoubleSupportPercentage
            )
            
            self.healthData = hd
            self.userVM.appendHealthData(hd)   // persist via UserViewModel
        }
    }
    
    
    
    private func saveHealthDataToUser() {
        guard let hd = healthData else { return }
        userVM.appendHealthData(hd)   // single source of truth
    }
    
    
    
    func refreshLocalHealthData() {
        guard let latest = userVM.user?.healthData.max(by: { $0.timeStamp < $1.timeStamp }) else {
            print("No health data stored for this user.")
            return
        }
        healthData = latest
    }
}
