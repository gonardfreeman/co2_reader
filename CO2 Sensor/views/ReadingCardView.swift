//
//  ReadingCard.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-04.
//
import SwiftData
import SwiftUI

struct ReadingCardView: View {
    let readingType: String

    @Environment(\.modelContext) private var context
    @State private var filteredReadings: [BLEReading] = []

    var currentReading: String {
        if filteredReadings.isEmpty {
            return "N/A"
        }
        guard let cur = filteredReadings.first else {
            return "N/A"
        }
        switch readingType {
        case "co2":
            guard let gas = cur.gas else {
                return "N/A"
            }
            return String(gas)
        case "temperature":
            guard let temp = cur.temperature else {
                return "N/A"
            }
            return String(temp)
        case "humidity":
            guard let hum = cur.humidity else {
                return "N/A"
            }
            return String(hum)
        default:
            return "N/A"
        }
    }

    var allReadings: [Int32] {
        guard !filteredReadings.isEmpty else {
            return []
        }
        let currentReadings: [Int32?] = filteredReadings
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
        guard !filteredReadings.isEmpty else {
            return "N/A"
        }
        guard let maxValue = allReadings.max() else {
            return "N/A"
        }
        return String(maxValue)
    }

    var minReading: String {
        guard !filteredReadings.isEmpty else {
            return "N/A"
        }
        guard let maxValue = allReadings.min() else {
            return "N/A"
        }
        return String(maxValue)
    }

    var avgReading: String {
        guard !filteredReadings.isEmpty else {
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

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                HStack {
                    Image(systemName: iconName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(hex: "#6e757b"))
                    Text(mainLabel)
                        .font(.largeTitle)
                }
                Spacer()
                VStack {
                    Text(currentReading)
                        .font(.largeTitle)
                    Text(units)
                }
            }
            .padding()
            VStack(alignment: .leading) {
                HStack {
                    Text("Avg:")
                    Text("\(avgReading)\(units)")
                }
                HStack {
                    Text("Max:")
                    Text("\(maxReading)\(units)")
                }
                HStack {
                    Text("Min:")
                    Text("\(minReading)\(units)")
                }
                HStack {
                    Text(safeAmountLabel)
                    Text("\(safeAmount)\(units)")
                }
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#dcdedd"), lineWidth: 1),
        )
        .padding()
        .onAppear(perform: fetchData)
    }

    private func fetchData() {
        let descriptor = FetchDescriptor<BLEReading>(
            predicate: #Predicate { $0.type == readingType },
            sortBy: [.init(\.timestamp, order: .reverse)],
        )

        do {
            filteredReadings = try context.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BLEReading.self, configurations: config)
    container.mainContext.insert(
        BLEReading(
            gas: 400,
            type: "co2",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            gas: 392,
            type: "co2",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            gas: 504,
            type: "co2",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            gas: 300,
            type: "co2",
        ),
    )
    return ReadingCardView(readingType: "co2")
        .modelContainer(container)
}
