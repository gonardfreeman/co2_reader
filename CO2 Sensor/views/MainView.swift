//
//  MainView.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-02.
//

import SwiftData
import SwiftUI

struct MainView: View {
    let manager: BLEManager
    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    //                    Text(deviceNameRecord.first?.deviceName ?? "Loading...")
                    Text("Test")
                        .font(.largeTitle)
                    Spacer()
                }
                ReadingCardView(readingType: "co2", context: context, manager: manager)
                ReadingCardView(readingType: "temperature", context: context, manager: manager)
                ReadingCardView(readingType: "humidity", context: context, manager: manager)
            }
            .padding()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BLEReading.self, configurations: config)
    container.mainContext.insert(
        BLEReading(
            deviceName: "Test Device",
            type: "deviceName",
        ),
    )

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

    container.mainContext.insert(
        BLEReading(
            temperature: 20,
            type: "temperature",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            temperature: 21,
            type: "temperature",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            temperature: 22,
            type: "temperature",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            temperature: 21,
            type: "temperature",
        ),
    )

    container.mainContext.insert(
        BLEReading(
            humidity: 49,
            type: "humidity",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            humidity: 51,
            type: "humidity",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            humidity: 50,
            type: "humidity",
        ),
    )
    container.mainContext.insert(
        BLEReading(
            humidity: 49,
            type: "humidity",
        ),
    )
    let manager = BLEManager()
    return MainView(manager: manager)
        .modelContainer(container)
}
