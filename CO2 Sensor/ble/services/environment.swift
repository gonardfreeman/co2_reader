//
//  environment.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-03.
//
import CoreBluetooth

enum EnvironmentServiceUUIDDefinitions {
    static let usedCharacteristicsUUIDs: [CBUUID] = [
        EnvironmentServiceUUIDDefinitions.temperature.uuid,
        EnvironmentServiceUUIDDefinitions.humidity.uuid,
        EnvironmentServiceUUIDDefinitions.gas.uuid,
    ]

    static let service: BaseServiceCharacteristicDescription = .init(
        name: "EnvironmentService",
        uuid: CBUUID(string: "EF680200-9B35-4933-9B10-52FFA9740042"),
    )
    static let temperature: BaseServiceCharacteristicDescription = .init(
        name: "Temperature",
        uuid: CBUUID(string: "EF680201-9B35-4933-9B10-52FFA9740042"),
    )
    static let pressure: BaseServiceCharacteristicDescription = .init(
        name: "Pressure",
        uuid: CBUUID(string: "EF680202-9B35-4933-9B10-52FFA9740042"),
    )
    static let humidity: BaseServiceCharacteristicDescription = .init(
        name: "Humidity",
        uuid: CBUUID(string: "EF680203-9B35-4933-9B10-52FFA9740042"),
    )
    static let gas: BaseServiceCharacteristicDescription = .init(
        name: "Gas",
        uuid: CBUUID(string: "EF680204-9B35-4933-9B10-52FFA9740042"),
    )
    static let color: BaseServiceCharacteristicDescription = .init(
        name: "Color",
        uuid: CBUUID(string: "EF680205-9B35-4933-9B10-52FFA9740042"),
    )
    static let config: BaseServiceCharacteristicDescription = .init(
        name: "Config",
        uuid: CBUUID(string: "EF680206-9B35-4933-9B10-52FFA9740042"),
    )
}
