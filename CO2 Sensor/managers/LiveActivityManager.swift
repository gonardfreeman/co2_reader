//
//  LiveActivityManager.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-05.
//
import ActivityKit
import Foundation

@MainActor
final class ActivityManager {
    static let shared = ActivityManager()
    private var activity: Activity<SensorLiveActivitiesAttributes>?

    func startActivity(params: ActivityParams) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled.")
            return
        }

        let attributes = SensorLiveActivitiesAttributes(
            sensorType: params.sensorType,
            safeLevel: params.safeLevel,
            iconName: params.iconName,
        )
        let contentState = SensorLiveActivitiesAttributes.ContentState(
            value: params.value,
            avg: params.avg,
            min: params.min,
            max: params.max,
        )
        let content = ActivityContent<SensorLiveActivitiesAttributes.ContentState>(state: contentState, staleDate: nil, relevanceScore: 100)
        do {
            activity = try Activity<SensorLiveActivitiesAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil,
            )
        } catch {
            print("Failed to start activity: \(error)")
        }
    }

    func updateActivity(params: ActivityParams) {
        let contentState = SensorLiveActivitiesAttributes.ContentState(
            value: params.value,
            avg: params.avg,
            min: params.min,
            max: params.max,
        )
        let content = ActivityContent<SensorLiveActivitiesAttributes.ContentState>(state: contentState, staleDate: nil, relevanceScore: 100)
        Task {
            await activity?.update(content)
        }
    }

    func endActivity(params: ActivityParams) {
        let contentState = SensorLiveActivitiesAttributes.ContentState(
            value: params.value,
            avg: params.avg,
            min: params.min,
            max: params.max,
        )
        let content = ActivityContent<SensorLiveActivitiesAttributes.ContentState>(state: contentState, staleDate: nil, relevanceScore: 100)
        Task {
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
}
