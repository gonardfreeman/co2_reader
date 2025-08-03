//
//  environment.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-03.
//
import CoreBluetooth

struct EnvironmentServiceUUIDDefinitions {
    static let usedCharacteristicsUUIDs: [CBUUID] = [
        EnvironmentServiceUUIDDefinitions.temperature.uuid,
        EnvironmentServiceUUIDDefinitions.humidity.uuid,
        EnvironmentServiceUUIDDefinitions.gas.uuid
    ]
    
    static let service: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "EnvironmentService",
        uuid: CBUUID(string: "EF680200-9B35-4933-9B10-52FFA9740042")
    )
    static let temperature: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "Temperature",
        uuid: CBUUID(string: "EF680201-9B35-4933-9B10-52FFA9740042")
    )
    static let pressure: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "Pressure",
        uuid: CBUUID(string: "EF680202-9B35-4933-9B10-52FFA9740042")
    )
    static let humidity: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "Humidity",
        uuid: CBUUID(string: "EF680203-9B35-4933-9B10-52FFA9740042")
    )
    static let gas: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "Gas",
        uuid: CBUUID(string: "EF680204-9B35-4933-9B10-52FFA9740042")
    )
    static let color: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "Color",
        uuid: CBUUID(string: "EF680205-9B35-4933-9B10-52FFA9740042")
    )
    static let config: BaseServiceCharacteristicDescription = BaseServiceCharacteristicDescription(
        name: "Config",
        uuid: CBUUID(string: "EF680206-9B35-4933-9B10-52FFA9740042")
    )
}
