//
//  ReadingCard.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-04.
//
import SwiftData
import SwiftUI

struct ReadingCardView: View {
    @Environment(\.modelContext) private var context
    @StateObject var viewModel: BLEViewModel
    let readingType: String
    let impactMedium = UIImpactFeedbackGenerator(style: .medium)

    init(
        readingType: String,
        context contextData: ModelContext,
    ) {
        self.readingType = readingType
        _viewModel = StateObject(
            wrappedValue: BLEViewModel(
                modelContext: contextData,
                readingType: readingType,
            ),
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                HStack {
                    Image(systemName: viewModel.iconName)
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "#6e757b"))
                    Text(viewModel.mainLabel)
                        .font(.largeTitle)
                    if !viewModel.isConnected {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
                Spacer()
                VStack {
                    Text(viewModel.currentReading)
                        .font(.largeTitle)
                    Text(viewModel.units)
                }
            }
            .padding()
            VStack(alignment: .leading) {
                HStack {
                    Text("Avg:")
                    Text("\(viewModel.avgReading)\(viewModel.units)")
                }
                HStack {
                    Text("Max:")
                    Text("\(viewModel.maxReading)\(viewModel.units)")
                }
                HStack {
                    Text("Min:")
                    Text("\(viewModel.minReading)\(viewModel.units)")
                }
                HStack {
                    Text(viewModel.safeAmountLabel)
                    Text("\(viewModel.safeAmount)\(viewModel.units)")
                    Spacer()
                    HStack {
                        Button {
                            impactMedium.impactOccurred()
                            viewModel.stopActivity()
                        } label: {
                            Image(systemName: "stop.circle")
                        }
                        Button {
                            Task {
                                impactMedium.impactOccurred()
                                await viewModel.endAllActivities()
                                viewModel.startActivity(readingType: readingType)
                            }
                        } label: {
                            Image(systemName: "play.circle")
                        }
                        Button {
                            impactMedium.impactOccurred()
                            viewModel.deleteAllReadings()

                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#dcdedd"), lineWidth: 1),
        )
        .padding()
        .onAppear(perform: viewModel.fetchData)
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
    return ReadingCardView(
        readingType: "co2",
        context: container.mainContext,
    )
    .modelContainer(container)
}
