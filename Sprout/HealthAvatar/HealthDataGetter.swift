//
//  HealthDataGetter.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 2/21/25.
//

import Foundation
import HealthKit


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


    let typesToRead: Set<HKObjectType> = [heartRateType, stepCountType]
    
    healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
        if success {
            print("HealthKit permission granted.")
        } else {
            print("HealthKit permission denied: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}
