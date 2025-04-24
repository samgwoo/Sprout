//
//  HealthData.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 2/28/25.
//

import Foundation
import FirebaseFirestore

class HealthData: Codable {

    var timeStamp = Date()
    var stepCount: Int
    var distanceWalkingRunning: Double
    var flightsClimbed: Int
    
    var heartRateVariability: Double
    
    var bodyMass: Double
    var height: Double
    
    var environmentalAudioExposure: Double
    var headphoneAudioExposure: Double
    
    var sleepHours: Double
    
    var walkingSpeed: Double
    var walkingAsymmetryPercentage: Double
    var walkingDoubleSupportPercentage: Double
        
    init(
        stepCount: Int = 0,
        distanceWalkingRunning: Double = 0.0,
        flightsClimbed: Int = 0,
        heartRateVariability: Double = 0.0,
        bodyMass: Double = 0.0,
        height: Double = 0.0,
        environmentalAudioExposure: Double = 0.0,
        headphoneAudioExposure: Double = 0.0,
        sleepHours: Double = 0.0,
        walkingSpeed: Double = 0.0,
        walkingAsymmetryPercentage: Double = 0.0,
        walkingDoubleSupportPercentage: Double = 0.0
    ) {
        self.timeStamp = Date()
        self.stepCount = stepCount
        self.distanceWalkingRunning = distanceWalkingRunning
        self.flightsClimbed = flightsClimbed
        self.heartRateVariability = heartRateVariability
        self.bodyMass = bodyMass
        self.height = height
        self.environmentalAudioExposure = environmentalAudioExposure
        self.headphoneAudioExposure = headphoneAudioExposure
        self.sleepHours = sleepHours
        self.walkingSpeed = walkingSpeed
        self.walkingAsymmetryPercentage = walkingAsymmetryPercentage
        self.walkingDoubleSupportPercentage = walkingDoubleSupportPercentage
    }
    
    // Convert to JSON for sharing
    func toDictionary() -> [String: Any] {
            return [
                "timestamp": Timestamp(date: timeStamp),
                "stepCount": stepCount,
                "distanceWalkingRunning": distanceWalkingRunning,
                "flightsClimbed": flightsClimbed,
                "heartRateVariability": heartRateVariability,
                "bodyMass": bodyMass,
                "height": height,
                "environmentalAudioExposure": environmentalAudioExposure,
                "headphoneAudioExposure": headphoneAudioExposure,
                "sleepHours": sleepHours,
                "walkingSpeed": walkingSpeed,
                "walkingAsymmetryPercentage": walkingAsymmetryPercentage,
                "walkingDoubleSupportPercentage": walkingDoubleSupportPercentage,
            ]
        }
}

