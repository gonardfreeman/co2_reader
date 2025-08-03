//
//  configuration.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-03.
//
import CoreBluetooth

struct ConfigurationServiceUUIDDefinitions {
    static let usedCharacteristicsUUIDs = [
        ConfigurationServiceUUIDDefinitions.name.uuid
    ]
    
    static let service: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "ConfigurationService",
        uuid: CBUUID(string: "EF680100-9B35-4933-9B10-52FFA9740042")
    )
    static let name: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "Name",
        uuid: CBUUID(string: "EF680101-9B35-4933-9B10-52FFA9740042")
    )
}
