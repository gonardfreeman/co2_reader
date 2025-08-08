//
//  SensorActivityAttributes.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-05.
//
import ActivityKit
import WidgetKit

struct ActivityParams {
    var value: String
    var iconName: String
    var safeLevel: String
    var avg: String
    var min: String
    var max: String
    var sensorType: String
}

struct SensorLiveActivitiesAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var value: String
        var avg: String
        var min: String
        var max: String
    }

    var sensorType: String
    var safeLevel: String
    var iconName: String
}
