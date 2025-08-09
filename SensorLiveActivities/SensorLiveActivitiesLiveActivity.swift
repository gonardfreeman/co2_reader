//
//  SensorLiveActivitiesLiveActivity.swift
//  SensorLiveActivities
//
//  Created by Dima Bondarenko on 2025-08-05.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct SensorLiveActivitiesLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SensorLiveActivitiesAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: context.attributes.iconName)
                        .font(.system(size: 28))
                    Text(context.attributes.sensorType)
                        .font(.system(size: 28))
                }
                HStack {
                    Text("Cur: \(context.state.value)")
                }
                HStack {
                    Text("Avg: \(context.state.min)")
                    Text("Safe: \(context.attributes.safeLevel)")
                }
                HStack {
                    Text("Min: \(context.state.min)")
                    Text("Max: \(context.state.max)")
                    Spacer()
                }
            }
            .padding()

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Text(context.attributes.safeLevel)
                        Image(systemName: context.attributes.iconName)
                    }
                    .padding()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Cur: \(context.state.value)")
                        .fixedSize(horizontal: true, vertical: false)
                        .padding()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Safe: \(context.attributes.safeLevel)")
                            Text("Avg: \(context.state.avg)")
                        }
                        Spacer()
                        VStack {
                            Text("Min: \(context.state.min)")
                            Text("Max: \(context.state.max)")
                        }
                    }
                    .padding(
                        EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                    )
                }
            } compactLeading: {
                Image(systemName: context.attributes.iconName)
            } compactTrailing: {
                Text(context.state.value)
            } minimal: {
                Text(String(context.state.value))
            }
            .widgetURL(URL(string: "co2sensor://ble-status"))
            .keylineTint(Color.red)
        }
    }
}

private extension SensorLiveActivitiesAttributes {
    static var preview: SensorLiveActivitiesAttributes {
        SensorLiveActivitiesAttributes(sensorType: "CO2", safeLevel: "1000ppm", iconName: "carbon.dioxide.cloud")
    }
}

private extension SensorLiveActivitiesAttributes.ContentState {
    static var co2: SensorLiveActivitiesAttributes.ContentState {
        SensorLiveActivitiesAttributes.ContentState(
            value: "200ppm",
            avg: "1000ppm",
            min: "1000ppm",
            max: "1000ppm",
        )
    }

    static var temp: SensorLiveActivitiesAttributes.ContentState {
        SensorLiveActivitiesAttributes.ContentState(
            value: "22°C",
            avg: "1000°C",
            min: "1000°C",
            max: "1000°C",
        )
    }
}

#Preview("Notification", as: .content, using: SensorLiveActivitiesAttributes.preview) {
    SensorLiveActivitiesLiveActivity()
} contentStates: {
    SensorLiveActivitiesAttributes.ContentState.co2
    SensorLiveActivitiesAttributes.ContentState.temp
}
