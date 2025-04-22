import SwiftUI
import HealthKit
import FirebaseFirestore

class HealthViewModel: ObservableObject {
    
    @Published var healthData: HealthData?
    private let db = Firestore.firestore()
    private let healthStore = HKHealthStore()
    private var authViewModel: AuthViewModel  // Link to AuthViewModel
    
    var userId: String? {
        return authViewModel.userSession?.uid  // Get user ID from AuthViewModel
    }
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        requestHealthKitPermission()
    }
    
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func requestHealthKitPermission() {
        guard isHealthKitAvailable() else {
            print("HealthKit is not available on this device")
            return
        }
        
        var typesToRead = Set<HKObjectType>()
        
        if let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            typesToRead.insert(stepType)
        }
        if let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
            typesToRead.insert(distanceType)
        }
        if let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) {
            typesToRead.insert(flightsType)
        }
        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            typesToRead.insert(heartRateType)
        }
        if let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) {
            typesToRead.insert(hrvType)
        }
        if let respType = HKQuantityType.quantityType(forIdentifier: .respiratoryRate) {
            typesToRead.insert(respType)
        }
        if let massType = HKQuantityType.quantityType(forIdentifier: .bodyMass) {
            typesToRead.insert(massType)
        }
        if let heightType = HKQuantityType.quantityType(forIdentifier: .height) {
            typesToRead.insert(heightType)
        }
        if let washType = HKObjectType.categoryType(forIdentifier: .handwashingEvent) {
            typesToRead.insert(washType)
        }
        if let envAudioType = HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure) {
            typesToRead.insert(envAudioType)
        }
        if let headphoneAudioType = HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure) {
            typesToRead.insert(headphoneAudioType)
        }
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            typesToRead.insert(sleepType)
        }
        if let walkingSpeedType = HKQuantityType.quantityType(forIdentifier: .walkingSpeed) {
            typesToRead.insert(walkingSpeedType)
        }
        if let walkingAsymmetryType = HKQuantityType.quantityType(forIdentifier: .walkingAsymmetryPercentage) {
            typesToRead.insert(walkingAsymmetryType)
        }
        if let walkingDoubleSupportType = HKQuantityType.quantityType(forIdentifier: .walkingDoubleSupportPercentage) {
            typesToRead.insert(walkingDoubleSupportType)
        }
        
        guard !typesToRead.isEmpty else {
            print("No HealthKit types available to request authorization for")
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                print("HealthKit permission granted.")
                self.fetchHealthData() // ✅ Fetch data after permission is granted
            } else {
                print("HealthKit permission denied: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchHealthData() {
        guard let _ = userId else {
            print("User is not logged in, cannot fetch health data.")
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        // Initialize variables with default values
        var stepCount = 0
        var distanceWalkingRunning: Double = 0.0
        var flightsClimbed = 0
        var heartRate: Double = 0.0
        var heartRateVariability: Double = 0.0
        var respiratoryRate: Double = 0.0
        var bodyMass: Double = 0.0
        var height: Double = 0.0
        var handwashingEventCount = 0
        var environmentalAudioExposure: Double = 0.0
        var headphoneAudioExposure: Double = 0.0
        var sleepHours: Double = 0.0
        var walkingSpeed: Double = 0.0
        var walkingAsymmetryPercentage: Double = 0.0
        var walkingDoubleSupportPercentage: Double = 0.0
        
        // STEP COUNT
        if let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: stepType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    stepCount = Int(sample.quantity.doubleValue(for: HKUnit.count()))
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // DISTANCE WALKING/RUNNING
        if let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: distanceType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    distanceWalkingRunning = sample.quantity.doubleValue(for: HKUnit.meter())
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // FLIGHTS CLIMBED
        if let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: flightsType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    flightsClimbed = Int(sample.quantity.doubleValue(for: HKUnit.count()))
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // HEART RATE
        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // HEART RATE VARIABILITY
        if let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: hrvType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    heartRateVariability = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // RESPIRATORY RATE
        if let respType = HKQuantityType.quantityType(forIdentifier: .respiratoryRate) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: respType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    respiratoryRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // BODY MASS
        if let massType = HKQuantityType.quantityType(forIdentifier: .bodyMass) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: massType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    bodyMass = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // HEIGHT
        if let heightType = HKQuantityType.quantityType(forIdentifier: .height) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    height = sample.quantity.doubleValue(for: HKUnit.meter())
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // HANDWASHING EVENT COUNT
        if let handwashingType = HKObjectType.categoryType(forIdentifier: .handwashingEvent) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: handwashingType, predicate: nil, limit: 0, sortDescriptors: nil) { _, results, _ in
                if let results = results {
                    handwashingEventCount = results.count
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // ENVIRONMENTAL AUDIO EXPOSURE
        if let envAudioType = HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: envAudioType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    environmentalAudioExposure = sample.quantity.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // HEADPHONE AUDIO EXPOSURE
        if let headphoneAudioType = HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: headphoneAudioType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    headphoneAudioExposure = sample.quantity.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // SLEEP HOURS (using sleep analysis data)
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            let predicate = HKQuery.predicateForSamples(withStart: oneDayAgo, end: Date(), options: .strictEndDate)
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, _ in
                var totalSleep: Double = 0.0
                if let sleepResults = results as? [HKCategorySample] {
                    for sample in sleepResults {
                        totalSleep += sample.endDate.timeIntervalSince(sample.startDate)
                    }
                }
                sleepHours = totalSleep / 3600.0
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // WALKING SPEED
        if let walkingSpeedType = HKQuantityType.quantityType(forIdentifier: .walkingSpeed) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: walkingSpeedType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    walkingSpeed = sample.quantity.doubleValue(for: HKUnit.meter().unitDivided(by: HKUnit.second()))
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // WALKING ASYMMETRY PERCENTAGE
        if let walkingAsymmetryType = HKQuantityType.quantityType(forIdentifier: .walkingAsymmetryPercentage) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: walkingAsymmetryType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    walkingAsymmetryPercentage = sample.quantity.doubleValue(for: HKUnit.percent())
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        // WALKING DOUBLE SUPPORT PERCENTAGE
        if let walkingDoubleSupportType = HKQuantityType.quantityType(forIdentifier: .walkingDoubleSupportPercentage) {
            dispatchGroup.enter()
            let query = HKSampleQuery(sampleType: walkingDoubleSupportType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
                if let sample = results?.first as? HKQuantitySample {
                    walkingDoubleSupportPercentage = sample.quantity.doubleValue(for: HKUnit.percent())
                }
                dispatchGroup.leave()
            }
            healthStore.execute(query)
        }
        
        
        // When all queries have completed, compile the health data and save it
        dispatchGroup.notify(queue: .main) {
            let healthData = HealthData(
                stepCount: stepCount,
                distanceWalkingRunning: distanceWalkingRunning,
                flightsClimbed: flightsClimbed,
                heartRate: heartRate,
                heartRateVariability: heartRateVariability,
                respiratoryRate: respiratoryRate,
                bodyMass: bodyMass,
                height: height,
                handwashingEventCount: handwashingEventCount,
                environmentalAudioExposure: environmentalAudioExposure,
                headphoneAudioExposure: headphoneAudioExposure,
                sleepHours: sleepHours,
                walkingSpeed: walkingSpeed,
                walkingAsymmetryPercentage: walkingAsymmetryPercentage,
                walkingDoubleSupportPercentage: walkingDoubleSupportPercentage
            )
            
            self.healthData = healthData
            self.saveHealthDataToFirestore()
        }
    }
    
    
    
    func saveHealthDataToFirestore() {
        guard let userId = userId, let healthData = healthData else {
            print("User is not logged in, cannot save data.")
            return
        }
        
        db.collection("users").document(userId).collection("healthData").addDocument(data: healthData.toDictionary()) { error in
            if let error = error {
                print("Error saving health data: \(error.localizedDescription)")
            } else {
                print("Health data successfully saved!")
            }
        }
    }
    
    
    
    func fetchLatestHealthDataFromFirestore() {
        guard let userId = userId else {
            print("User is not logged in, cannot fetch data.")
            return
        }
        
        db.collection("users").document(userId).collection("healthData")
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, let document = documents.first else {
                    print("No health data found: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let data = document.data()
                let fetchedData = HealthData(
                    stepCount: data["stepCount"] as? Int ?? 0,
                    distanceWalkingRunning: data["distanceWalkingRunning"] as? Double ?? 0.0,
                    flightsClimbed: data["flightsClimbed"] as? Int ?? 0,
                    heartRate: data["heartRate"] as? Double ?? 0.0,
                    heartRateVariability: data["heartRateVariability"] as? Double ?? 0.0,
                    respiratoryRate: data["respiratoryRate"] as? Double ?? 0.0,
                    bodyMass: data["bodyMass"] as? Double ?? 0.0,
                    height: data["height"] as? Double ?? 0.0,
                    handwashingEventCount: data["handwashingEventCount"] as? Int ?? 0,
                    environmentalAudioExposure: data["environmentalAudioExposure"] as? Double ?? 0.0,
                    headphoneAudioExposure: data["headphoneAudioExposure"] as? Double ?? 0.0,
                    sleepHours: data["sleepHours"] as? Double ?? 0.0,
                    walkingSpeed: data["walkingSpeed"] as? Double ?? 0.0,
                    walkingAsymmetryPercentage: data["walkingAsymmetryPercentage"] as? Double ?? 0.0,
                    walkingDoubleSupportPercentage: data["walkingDoubleSupportPercentage"] as? Double ?? 0.0
                    // no workoutSessions param if you're not using it!
                )
                
                DispatchQueue.main.async {
                    self.healthData = fetchedData
                }
            }
    }
}
