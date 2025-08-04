//
//  BluetoothModel.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-02.
//

import Foundation
import SwiftData

@Model
final class BluetoothState {
    var isGasNotify: Bool = false
    var isTemperatureNotify: Bool = false
    var isHumidityNotify: Bool = false

    init(isGas: Bool, isTemp: Bool, isHumidity: Bool) {
        isGasNotify = isGas
        isHumidityNotify = isHumidity
        isTemperatureNotify = isTemp
    }
}
