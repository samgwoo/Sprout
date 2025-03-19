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
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.categoryType(forIdentifier: .handwashingEvent)!,
            HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!,
            HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .walkingSpeed)!,
            HKObjectType.quantityType(forIdentifier: .walkingAsymmetryPercentage)!,
            HKObjectType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!,
            HKObjectType.workoutType()
        ]
        
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
        guard let userId = userId else {
            print("User is not logged in, cannot fetch health data.")
            return
        }

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let query = HKSampleQuery(sampleType: stepType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            let stepCount = (results?.first as? HKQuantitySample)?.quantity.doubleValue(for: HKUnit.count()) ?? 0
            
            DispatchQueue.main.async {
                self.healthData = HealthData(stepCount: Int(stepCount), heartRate: 75.0)
                self.saveHealthDataToFirestore()
            }
        }
        healthStore.execute(query)
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
                    heartRate: data["heartRate"] as? Double ?? 0.0
                )

                DispatchQueue.main.async {
                    self.healthData = fetchedData // ✅ Automatically updates UI
                }
            }
    }
}
