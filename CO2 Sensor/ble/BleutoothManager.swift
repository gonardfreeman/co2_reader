import Combine
import CoreBluetooth
import Foundation
import SwiftData

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    let newReadingPublisher = PassthroughSubject<BLEReading, Never>()

    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var timer: Timer?

    @Published var isConnected = false
    @Published var deviceName: String = "No data yet"
    @Published var gas: Gas = .init()
    @Published var temperature: Temperature = .init()
    @Published var humidity: UInt8 = 0

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(
                withServices: [
                    ConfigurationServiceUUIDDefinitions.service.uuid,
                    EnvironmentServiceUUIDDefinitions.service.uuid,
                ],
                options: nil,
            )
        } else {
            print("Bluetooth not available")
        }
    }

    func centralManager(_: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData _: [String: Any], rssi _: NSNumber) {
        print("Discovered: \(peripheral.name ?? "Unknown")")
        connectedPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
        peripheral.delegate = self
    }

    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: \(peripheral.name ?? "Unknown")")
        isConnected = true
        peripheral.discoverServices(
            [
                ConfigurationServiceUUIDDefinitions.service.uuid,
                EnvironmentServiceUUIDDefinitions.service.uuid,
            ],
        )
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices _: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics(
                ConfigurationServiceUUIDDefinitions.usedCharacteristicsUUIDs + EnvironmentServiceUUIDDefinitions.usedCharacteristicsUUIDs,
                for: service,
            )
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error _: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        let mergedUUIDs = ConfigurationServiceUUIDDefinitions.usedCharacteristicsUUIDs + EnvironmentServiceUUIDDefinitions.usedCharacteristicsUUIDs
        for characteristic in characteristics where mergedUUIDs.contains(characteristic.uuid) {
            switch characteristic.uuid {
            case EnvironmentServiceUUIDDefinitions.gas.uuid:
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            case EnvironmentServiceUUIDDefinitions.temperature.uuid:
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            case EnvironmentServiceUUIDDefinitions.humidity.uuid:
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            case ConfigurationServiceUUIDDefinitions.name.uuid:
                updateValue(characteristic: characteristic)
            default:
                print("has to be defined")
            }
        }
    }

    func peripheral(_: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error {
            print("⚠️ Failed to enable notifications: \(error.localizedDescription)")
            return
        }
        updateValue(characteristic: characteristic)
    }

    func peripheral(_: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error _: Error?) {
        updateValue(characteristic: characteristic)
    }

    private func updateValue(characteristic: CBCharacteristic) {
        switch characteristic.uuid {
        case ConfigurationServiceUUIDDefinitions.name.uuid:
            updateName(characteristic: characteristic)
        case EnvironmentServiceUUIDDefinitions.gas.uuid:
            updateCo2(characteristic: characteristic)
        case EnvironmentServiceUUIDDefinitions.temperature.uuid:
            updateTemperature(characteristic: characteristic)
        case EnvironmentServiceUUIDDefinitions.humidity.uuid:
            updateHumidity(characteristic: characteristic)
        default:
            print("unknown char: \(characteristic.uuid)")
        }
    }

    private func updateHumidity(characteristic: CBCharacteristic) {
        guard let value = characteristic.value else {
            print("no value for: \(characteristic.uuid)")
            return
        }
        DispatchQueue.main.async {
            self.humidity = UInt8(value[0])
            self.newReadingPublisher.send(
                BLEReading(
                    humidity: UInt8(value[0]),
                    type: "humidity",
                ),
            )
        }
    }

    private func updateTemperature(characteristic: CBCharacteristic) {
        guard let value = characteristic.value else {
            print("no value for: \(characteristic.uuid)")
            return
        }
        guard let temperature = Temperature(data: value) else { return }
        DispatchQueue.main.async {
            self.temperature = temperature
            self.newReadingPublisher.send(
                BLEReading(
                    temperature: temperature.decimal,
                    type: "temperature",
                ),
            )
        }
    }

    private func updateCo2(characteristic: CBCharacteristic) {
        guard let value = characteristic.value else {
            print("no value for: \(characteristic.uuid)")
            return
        }
        guard let gas = Gas(data: value) else { return }
        DispatchQueue.main.async {
            self.gas = gas
            self.newReadingPublisher.send(
                BLEReading(
                    gas: gas.co2_ppm,
                    type: "co2",
                ),
            )
        }
    }

    private func updateName(characteristic: CBCharacteristic) {
        guard let value = characteristic.value else {
            print("no value for: \(characteristic.uuid)")
            return
        }
        let stringData = String(decoding: value, as: UTF8.self)
        DispatchQueue.main.async {
            self.deviceName = stringData
            self.newReadingPublisher.send(
                BLEReading(
                    deviceName: stringData,
                    type: "deviceName",
                ),
            )
        }
    }
}
