import Foundation
import CoreBluetooth

struct Gas {
    var co2_ppm: UInt16
    var tvoc_ppb: UInt16
    
    init() {
        self.co2_ppm = 0
        self.tvoc_ppb = 0
    }
}

extension Gas {
    init?(data: Data) {
        guard data.count == 4 else { return nil }
        self.co2_ppm = UInt16(littleEndian: data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: UInt16.self) })
        self.tvoc_ppb = UInt16(littleEndian: data.withUnsafeBytes { $0.load(fromByteOffset: 2, as: UInt16.self) })
    }
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var gasCharacteristic: CBCharacteristic?
    var timer: Timer?
    
    @Published var isConnected = false
    @Published var deviceName: String = "No data yet"
    @Published var gas: Gas = Gas()
    
    let configServiceUUID = CBUUID(string: "EF680100-9B35-4933-9B10-52FFA9740042")
    let deviceNameCharacteristicUUID = CBUUID(string: "EF680101-9B35-4933-9B10-52FFA9740042")
    
    let envServiceUUID = CBUUID(string: "EF680200-9B35-4933-9B10-52FFA9740042")
    let co2CharacteristicUUID = CBUUID(string: "EF680204-9B35-4933-9B10-52FFA9740042")
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [configServiceUUID, envServiceUUID], options: nil)
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
        peripheral.discoverServices([configServiceUUID, envServiceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics([deviceNameCharacteristicUUID, co2CharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        for characteristic in characteristics where [co2CharacteristicUUID, deviceNameCharacteristicUUID].contains(characteristic.uuid ) {
            switch characteristic.uuid {
            case co2CharacteristicUUID:
                gasCharacteristic = characteristic
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                } else {
                    print("Characteristic \(characteristic.uuid) doesn't support notify.")
                }
                break
            case deviceNameCharacteristicUUID:
                readOnce(characteristic: characteristic)
                break
            default:
                print("has to be defined")
                break
            }
        }
    }
    
    private func readOnce( characteristic: CBCharacteristic) {
        if let peripheral = connectedPeripheral {
            print("read once: \(characteristic.uuid)")
            peripheral.readValue(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("⚠️ Failed to enable notifications: \(error.localizedDescription)")
            return
        }
        print("✅ Notification state updated for \(characteristic.uuid) — isNotifying: \(characteristic.isNotifying)")
        if characteristic.uuid == co2CharacteristicUUID {
            if let value = characteristic.value {
                if let gas = Gas(data: value) {
                    DispatchQueue.main.async {
                        self.gas = gas
                    }
                }
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("updated value for \(characteristic.uuid)")
        if characteristic.uuid == deviceNameCharacteristicUUID {
            if let value = characteristic.value {
                let stringData = String(decoding: value, as: UTF8.self)
                DispatchQueue.main.async {
                    self.deviceName = stringData
                }
            }
        }
        
        
    }
}
