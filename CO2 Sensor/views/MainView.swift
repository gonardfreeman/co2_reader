//
//  MainView.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-02.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @StateObject var viewModel: BLEViewModel
    @Environment(\.modelContext) private var context

    init(
        modelContext: ModelContext,
    ) {
        _viewModel = StateObject(
            wrappedValue: BLEViewModel(
                modelContext: modelContext,
                readingType: "deviceName",
            ),
        )
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(viewModel.deviceName)
                        .font(.largeTitle)
                    Spacer()
                }
                ReadingCardView(
                    readingType: "co2",
                    context: context,
                )
                ReadingCardView(
                    readingType: "temperature",
                    context: context,
                )
                ReadingCardView(
                    readingType: "humidity",
                    context: context,
                )
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
    return MainView(
        modelContext: container.mainContext,
    )
    .modelContainer(container)
}
