//
//  co2.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-03.
//
import Foundation

struct Gas {
    var co2_ppm: UInt16
    var tvoc_ppb: UInt16

    init() {
        co2_ppm = 0
        tvoc_ppb = 0
    }
}

extension Gas {
    init?(data: Data) {
        guard data.count == 4 else { return nil }
        co2_ppm = UInt16(littleEndian: data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: UInt16.self) })
        tvoc_ppb = UInt16(littleEndian: data.withUnsafeBytes { $0.load(fromByteOffset: 2, as: UInt16.self) })
    }
}

struct Temperature {
    var integer: Int8
    var decimal: UInt8

    init() {
        integer = 0
        decimal = 0
    }
}

extension Temperature {
    init?(data: Data) {
        guard data.count >= 2 else { return nil }

        integer = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: Int8.self) }
        decimal = data.withUnsafeBytes { $0.load(fromByteOffset: 1, as: UInt8.self) }
    }
}
