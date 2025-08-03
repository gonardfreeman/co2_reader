//
//  base.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-03.
//

import CoreBluetooth

struct BaseServiceCharacteristicDescription {
    var name: String
    var uuid: CBUUID
    
    init(name: String, uuid: CBUUID) {
        self.name = name
        self.uuid = uuid
    }
}
