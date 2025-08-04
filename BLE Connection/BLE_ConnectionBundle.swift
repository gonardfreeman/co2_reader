//
//  BLE_ConnectionBundle.swift
//  BLE Connection
//
//  Created by Dima Bondarenko on 2025-08-03.
//

import SwiftUI
import WidgetKit

@main
struct BLE_ConnectionBundle: WidgetBundle {
    var body: some Widget {
        BLE_Connection()
        BLE_ConnectionLiveActivity()
    }
}
