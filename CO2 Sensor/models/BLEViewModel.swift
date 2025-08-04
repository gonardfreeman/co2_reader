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
    @Published var isConnected: Bool = false

    @Published var gas: Gas = .init()
    @Published var temperature: Temperature = .init()
    @Published var humidity: UInt8 = 0

    private var bleManager: BLEManager!
    private var cancellables = Set<AnyCancellable>()

    init(modelContext: ModelContext) {
        bleManager = BLEManager(modelContext: modelContext)

        bleManager.$isConnected
            .assign(to: \.isConnected, on: self)
            .store(in: &cancellables)

        bleManager.$gas
            .assign(to: \.gas, on: self)
            .store(in: &cancellables)

        bleManager.$temperature
            .assign(to: \.temperature, on: self)
            .store(in: &cancellables)

        bleManager.$humidity
            .assign(to: \.humidity, on: self)
            .store(in: &cancellables)
    }
}
