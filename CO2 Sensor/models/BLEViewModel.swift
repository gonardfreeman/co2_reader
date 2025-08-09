//
//  BLEViewModel.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-04.
//
import Combine
import Foundation
import SwiftData

class BLEViewModel: ObservableObject {
    let readingType: String
    private var cancellables = Set<AnyCancellable>()
    private let bleManager: BLEManager
    private let activityManager: ActivityManager
    private let context: ModelContext
    
    private var isActivityRunning: Bool = false
    
    
    @Published var isConnected: Bool = false
    @Published var readings: [BLEReading] = []
    
    var sensorType: String {
        switch readingType {
        case "co2":
            "CO2"
        case "temperature":
            "Temperature"
        case "humidity":
            "Humidity"
        default:
            "Unknown sensor"
        }
    }
    
    var deviceName: String {
        guard !readings.isEmpty else {
            return "Loading..."
        }
        let readings = readings.map { reading in
            reading.deviceName ?? nil
        }.compactMap(\.self)
        guard let cur = readings.first else {
            return "Loading..."
        }
        return cur
    }
    
    var currentReading: String {
        if allReadings.isEmpty {
            return "N/A"
        }
        guard let cur = allReadings.first else {
            return "N/A"
        }
        return String(cur)
    }
    
    var allReadings: [Int32] {
        guard !readings.isEmpty else {
            return []
        }
        let currentReadings: [Int32?] = readings
            .map { reading in
                switch readingType {
                case "co2":
                    guard let gas = reading.gas else {
                        return nil
                    }
                    return Int32(gas)
                case "temperature":
                    guard let temp = reading.temperature else {
                        return nil
                    }
                    return Int32(temp)
                case "humidity":
                    guard let hum = reading.humidity else {
                        return nil
                    }
                    return Int32(hum)
                default:
                    return nil
                }
            }
        return currentReadings.compactMap(\.self)
    }
    
    var maxReading: String {
        guard !allReadings.isEmpty else {
            return "N/A"
        }
        guard let maxValue = allReadings.max() else {
            return "N/A"
        }
        return String(maxValue)
    }
    
    var minReading: String {
        guard !allReadings.isEmpty else {
            return "N/A"
        }
        guard let maxValue = allReadings.min() else {
            return "N/A"
        }
        return String(maxValue)
    }
    
    var avgReading: String {
        guard !allReadings.isEmpty else {
            return "N/A"
        }
        if allReadings.isEmpty {
            return "N/A"
        }
        let sum = allReadings.reduce(0, +)
        let avg = sum / Int32(allReadings.count)
        return String(avg)
    }
    
    var safeAmount: String {
        switch readingType {
        case "co2":
            "1000"
        case "temperature":
            "22"
        case "humidity":
            "70"
        default:
            "N/A"
        }
    }
    
    var safeAmountLabel: String {
        switch readingType {
        case "co2":
            "Safe limit:"
        case "temperature":
            "Recommended:"
        case "humidity":
            "Recommended:"
        default:
            "Recommended:"
        }
    }
    
    var units: String {
        switch readingType {
        case "co2":
            "ppm"
        case "temperature":
            "°C"
        case "humidity":
            "%"
        default:
            " Unknown unit"
        }
    }
    
    var mainLabel: String {
        switch readingType {
        case "co2":
            "CO2"
        case "temperature":
            "Temperature"
        case "humidity":
            "Humidity"
        default:
            "Reading"
        }
    }
    
    var iconName: String {
        switch readingType {
        case "co2":
            "carbon.dioxide.cloud"
        case "temperature":
            "thermometer.sun"
        case "humidity":
            "humidity"
        default:
            "sensor"
        }
    }
    
    init(
        modelContext: ModelContext,
        readingType: String,
        bleManager: BLEManager = .shared,
        activityManager: ActivityManager = .shared
    ) {
        context = modelContext
        self.readingType = readingType
        self.bleManager = bleManager
        self.activityManager = activityManager
        subscribeToBLE()
        subscribeToConnectivity()
        fetchData()
    }
    
    private func subscribeToBLE() {
        bleManager.newReadingPublisher
            .sink { [weak self] reading in
                self?.save(reading: reading)
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToConnectivity() {
        bleManager.connectivityPublisher
            .sink { [weak self] isActive in
                self?.isConnected = isActive
            }
            .store(in: &cancellables)
    }
    
    private func save(reading: BLEReading) {
        context.insert(reading)
        do {
            try context.save()
        } catch {
            print("Failed to save reading: \(error)")
        }
        
        readings.insert(reading, at: 0)
        updateActivity()
    }
    
    func fetchData() {
        let type = readingType
        let descriptor = FetchDescriptor<BLEReading>(
            predicate: #Predicate { $0.type == type },
            sortBy: [.init(\.timestamp, order: .reverse)],
        )
        
        do {
            readings = try context.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    func deleteAllReadings() {
        do {
            let all = try context.fetch(FetchDescriptor<BLEReading>())
            all.forEach { context.delete($0) }
            try context.save()
            readings = []
        } catch {
            print("Delete failed: \(error)")
        }
    }
    
    @MainActor
    func startActivity(readingType innerReadingType: String) {
        activityManager.startActivity(
            params: ActivityParams(
                value: currentReading,
                iconName: iconName,
                safeLevel: safeAmount,
                avg: avgReading,
                min: minReading,
                max: maxReading,
                sensorType: innerReadingType,
            ),
        )
        isActivityRunning = true
    }
    
    private func updateActivity() {
        if isActivityRunning == false {
            return
        }
        activityManager.updateActivity(params: ActivityParams(
            value: currentReading,
            iconName: iconName,
            safeLevel: safeAmount,
            avg: avgReading,
            min: minReading,
            max: maxReading,
            sensorType: readingType,
        ))
    }
    
    func stopActivity() {
        activityManager.endActivity(
            params: ActivityParams(
                value: currentReading,
                iconName: iconName,
                safeLevel: safeAmount,
                avg: avgReading,
                min: minReading,
                max: maxReading,
                sensorType: readingType,
            )
        )
        isActivityRunning = false
    }
    
    func endAllActivities() async {
        await activityManager.endAllActivities()
    }
}
