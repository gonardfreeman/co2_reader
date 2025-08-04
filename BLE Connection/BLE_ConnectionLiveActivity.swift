//
//  BLE_ConnectionLiveActivity.swift
//  BLE Connection
//
//  Created by Dima Bondarenko on 2025-08-03.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct BLE_ConnectionAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var status: String
    }

    var deviceName: String
}

struct BLE_ConnectionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BLE_ConnectionAttributes.self) { context in
            // Lock Screen View
            VStack {
                Text("BLE: \(context.attributes.deviceName)")
                Text(context.state.status)
            }
            .activityBackgroundTint(.blue)
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Image(systemName: "carbon.dioxide.cloud")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                        VStack(alignment: .leading) {
                            Text("Device: \(context.attributes.deviceName)")
                            Text(context.state.status)
                        }
                    }
                }
            } compactLeading: {
                HStack {
                    Image(systemName: "carbon.dioxide.cloud")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                    Text("BLE")
                }
            } compactTrailing: {
                Text(context.state.status.prefix(1))
            } minimal: {
                Text(context.state.status.prefix(1))
            }
            .widgetURL(URL(string: "yourapp://ble-status"))
            .keylineTint(.cyan)
        }
    }
}

private extension BLE_ConnectionAttributes {
    static var preview: BLE_ConnectionAttributes {
        BLE_ConnectionAttributes(deviceName: "co2_sense")
    }
}

private extension BLE_ConnectionAttributes.ContentState {
    static var connected: BLE_ConnectionAttributes.ContentState {
        BLE_ConnectionAttributes.ContentState(status: "Connected")
    }

    static var searching: BLE_ConnectionAttributes.ContentState {
        BLE_ConnectionAttributes.ContentState(status: "Searching")
    }
}

#Preview("Notification", as: .content, using: BLE_ConnectionAttributes.preview) {
    BLE_ConnectionLiveActivity()
} contentStates: {
    BLE_ConnectionAttributes.ContentState.connected
    BLE_ConnectionAttributes.ContentState.searching
}
