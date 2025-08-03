import Foundation
import CoreBluetooth


class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var timer: Timer?
    
    @Published var isConnected = false
    @Published var deviceName: String = "No data yet"
    @Published var gas: Gas = Gas()
    @Published var temperature: Temperature = Temperature()
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
                    EnvironmentServiceUUIDDefinitions.service.uuid
                ],
                options: nil
            )
        } else {
            print("Bluetooth not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered: \(peripheral.name ?? "Unknown")")
        connectedPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
        peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: \(peripheral.name ?? "Unknown")")
        isConnected = true
        peripheral.discoverServices(
            [
                ConfigurationServiceUUIDDefinitions.service.uuid,
                EnvironmentServiceUUIDDefinitions.service.uuid
            ]
        )
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics(
                ConfigurationServiceUUIDDefinitions.usedCharacteristicsUUIDs + EnvironmentServiceUUIDDefinitions.usedCharacteristicsUUIDs,
                for: service
            )
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        let mergedUUIDs = ConfigurationServiceUUIDDefinitions.usedCharacteristicsUUIDs + EnvironmentServiceUUIDDefinitions.usedCharacteristicsUUIDs
        for characteristic in characteristics where mergedUUIDs.contains(characteristic.uuid ) {
            switch characteristic.uuid {
            case EnvironmentServiceUUIDDefinitions.gas.uuid:
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                break
            case EnvironmentServiceUUIDDefinitions.temperature.uuid:
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                break
            case EnvironmentServiceUUIDDefinitions.humidity.uuid:
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                break
            case ConfigurationServiceUUIDDefinitions.name.uuid:
                updateValue(characteristic: characteristic)
                break
            default:
                print("has to be defined")
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("⚠️ Failed to enable notifications: \(error.localizedDescription)")
            return
        }
        updateValue(characteristic: characteristic)
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        updateValue(characteristic: characteristic)
    }
    
    private func updateValue(characteristic: CBCharacteristic) {
        switch characteristic.uuid {
        case ConfigurationServiceUUIDDefinitions.name.uuid:
            updateName(characteristic: characteristic)
            break;
        case EnvironmentServiceUUIDDefinitions.gas.uuid:
            updateCo2(characteristic: characteristic)
            break;
        case EnvironmentServiceUUIDDefinitions.temperature.uuid:
            updateTemperature(characteristic: characteristic)
            break;
        case EnvironmentServiceUUIDDefinitions.humidity.uuid:
            updateHumidity(characteristic: characteristic)
            break;
        default:
            print("unknown char: \(characteristic.uuid)")
            break;
        }
    }
    
    private func updateHumidity(characteristic: CBCharacteristic) {
        guard let value = characteristic.value else {
            print("no value for: \(characteristic.uuid)")
            return
        }
        DispatchQueue.main.async {
            self.humidity = UInt8(value[0])
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
        }
    }
}
