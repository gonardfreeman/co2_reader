//
//  configuration.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-03.
//
import CoreBluetooth

enum ConfigurationServiceUUIDDefinitions {
    static let usedCharacteristicsUUIDs = [
        ConfigurationServiceUUIDDefinitions.name.uuid,
    ]

    static let service: BaseServiceCharacteristicDescription = .init(
        name: "ConfigurationService",
        uuid: CBUUID(string: "EF680100-9B35-4933-9B10-52FFA9740042"),
    )
    static let name: BaseServiceCharacteristicDescription = .init(
        name: "Name",
        uuid: CBUUID(string: "EF680101-9B35-4933-9B10-52FFA9740042"),
    )
}
