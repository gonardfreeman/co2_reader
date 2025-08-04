//
//  BLEReading.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-04.
//
import Foundation
import SwiftData

@Model
class BLEReading {
    var type: String
    var deviceName: String?
    var temperature: UInt8?
    var gas: UInt16?
    var humidity: UInt8?

    var timestamp: Date

    init(deviceName: String, type: String, timestamp: Date = .now) {
        self.deviceName = deviceName
        self.type = type
        self.timestamp = timestamp
    }

    init(temperature: UInt8, type: String, timestamp: Date = .now) {
        self.type = type
        self.temperature = temperature
        self.timestamp = timestamp
    }

    init(gas: UInt16, type: String, timestamp: Date = .now) {
        self.type = type
        self.gas = gas
        self.timestamp = timestamp
    }

    init(humidity: UInt8, type: String, timestamp: Date = .now) {
        self.type = type
        self.humidity = humidity
        self.timestamp = timestamp
    }
}
