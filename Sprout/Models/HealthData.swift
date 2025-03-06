//
//  HealthData.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 2/28/25.
//

import Foundation
import FirebaseFirestore

class HealthData: Codable {
    let uuid: String
    var timeStamp = Date()
    var stepCount: Int
    var distanceWalkingRunning: Double
    var flightsClimbed: Int
    
    var heartRate: Double
    var heartRateVariability: Double
    var respiratoryRate: Double
    
    var bodyMass: Double
    var height: Double
    
    var handwashingEventCount: Int
    var environmentalAudioExposure: Double
    var headphoneAudioExposure: Double
    
    var sleepHours: Double
    
    var walkingSpeed: Double
    var walkingAsymmetryPercentage: Double
    var walkingDoubleSupportPercentage: Double
    
    var workoutSessions: Int
    
    init(
        stepCount: Int = 0,
        distanceWalkingRunning: Double = 0.0,
        flightsClimbed: Int = 0,
        heartRate: Double = 0.0,
        heartRateVariability: Double = 0.0,
        respiratoryRate: Double = 0.0,
        bodyMass: Double = 0.0,
        height: Double = 0.0,
        handwashingEventCount: Int = 0,
        environmentalAudioExposure: Double = 0.0,
        headphoneAudioExposure: Double = 0.0,
        sleepHours: Double = 0.0,
        walkingSpeed: Double = 0.0,
        walkingAsymmetryPercentage: Double = 0.0,
        walkingDoubleSupportPercentage: Double = 0.0,
        workoutSessions: Int = 0
    ) {
        self.uuid = UUID().uuidString
        self.timeStamp = Date()
        self.stepCount = stepCount
        self.distanceWalkingRunning = distanceWalkingRunning
        self.flightsClimbed = flightsClimbed
        self.heartRate = heartRate
        self.heartRateVariability = heartRateVariability
        self.respiratoryRate = respiratoryRate
        self.bodyMass = bodyMass
        self.height = height
        self.handwashingEventCount = handwashingEventCount
        self.environmentalAudioExposure = environmentalAudioExposure
        self.headphoneAudioExposure = headphoneAudioExposure
        self.sleepHours = sleepHours
        self.walkingSpeed = walkingSpeed
        self.walkingAsymmetryPercentage = walkingAsymmetryPercentage
        self.walkingDoubleSupportPercentage = walkingDoubleSupportPercentage
        self.workoutSessions = workoutSessions
    }
    
    // Convert to JSON for sharing
    func toDictionary() -> [String: Any] {
            return [
                "uuid": uuid,
                "timestamp": Timestamp(date: timeStamp),
                "stepCount": stepCount,
                "distanceWalkingRunning": distanceWalkingRunning,
                "flightsClimbed": flightsClimbed,
                "heartRate": heartRate,
                "heartRateVariability": heartRateVariability,
                "respiratoryRate": respiratoryRate,
                "bodyMass": bodyMass,
                "height": height,
                "handwashingEventCount": handwashingEventCount,
                "environmentalAudioExposure": environmentalAudioExposure,
                "headphoneAudioExposure": headphoneAudioExposure,
                "sleepHours": sleepHours,
                "walkingSpeed": walkingSpeed,
                "walkingAsymmetryPercentage": walkingAsymmetryPercentage,
                "walkingDoubleSupportPercentage": walkingDoubleSupportPercentage,
                "workoutSessions": workoutSessions
            ]
        }
}

