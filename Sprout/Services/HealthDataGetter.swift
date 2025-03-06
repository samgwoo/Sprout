//
//  HealthDataGetter.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 2/21/25.
//

import Foundation
import HealthKit
import FirebaseFirestore


let db = Firestore.firestore()

let healthStore = HKHealthStore()

func isHealthKitAvailable() -> Bool {
    return HKHealthStore.isHealthDataAvailable()
}

func requestHealthKitPermission() {
    guard isHealthKitAvailable() else {
        print("HealthKit is not available on this device")
        return
    }
    
    // Activity
    let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
    let distanceWalkingRunningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    let flightsClimbedType = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!

    // Heart & Vitals
    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let heartRateVariabilityType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    let respiratoryRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate)!

    let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)! // Weight
    let heightType = HKObjectType.quantityType(forIdentifier: .height)!

    // Hygiene & Environmental
    let handwashingEventType = HKObjectType.categoryType(forIdentifier: .handwashingEvent)!
    let environmentalAudioExposureType = HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!
    let headphoneAudioExposureType = HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure)!


    // Sleep & Mindfulness
    let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

    // Mobility & Walking Metrics
    let walkingSpeedType = HKObjectType.quantityType(forIdentifier: .walkingSpeed)!
    let walkingAsymmetryPercentageType = HKObjectType.quantityType(forIdentifier: .walkingAsymmetryPercentage)!
    let walkingDoubleSupportPercentageType = HKObjectType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!

    // Workout Data
    let workoutType = HKObjectType.workoutType()


    let typesToRead: Set<HKObjectType> = [heartRateType, stepCountType, distanceWalkingRunningType, flightsClimbedType, heartRateType, heartRateVariabilityType, respiratoryRateType, bodyMassType, heightType, handwashingEventType, environmentalAudioExposureType, headphoneAudioExposureType, sleepAnalysisType, walkingSpeedType, walkingAsymmetryPercentageType, walkingDoubleSupportPercentageType, workoutType]
    
    healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
        if success {
            print("HealthKit permission granted.")
            
        } else {
            print("HealthKit permission denied: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    func saveHealthDataToFirestore(_ healthData: HealthData) {
        let userId = "user_123" // Replace with actual user ID (can use Firebase Auth)
        
        db.collection("users").document(userId).collection("healthData").addDocument(data: healthData.toDictionary()) { error in
            if let error = error {
                print("Error saving health data: \(error.localizedDescription)")
            } else {
                print("Health data successfully saved!")
            }
        }
    }
    
    func fetchLatestHealthDataFromFirestore(completion: @escaping (HealthData?) -> Void) {
        let userId = "user_123" // Replace with actual user ID
        
        db.collection("users").document(userId).collection("healthData")
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, let document = documents.first else {
                    print("No health data found: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                let data = document.data()
                let healthData = HealthData(
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
                    walkingDoubleSupportPercentage: data["walkingDoubleSupportPercentage"] as? Double ?? 0.0,
                    workoutSessions: data["workoutSessions"] as? Int ?? 0
                )

                completion(healthData)
            }
    }
}
