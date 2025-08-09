//
//  CO2_SensorApp.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-02.
//

import SwiftData
import SwiftUI

@main
struct CO2_SensorApp: App {
//    @Environment(\.scenePhase) private var scenePhase
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BLEReading.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainView(modelContext: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
//        .onChange(of: scenePhase, initial: false) { _, newValue in
//            switch newValue {
//            case .inactive:
//                print("inactive")
//                BLEManager.shared.deactivateBLE()
//                break;
//            case .active:
//                print("active")
//                BLEManager.shared.activateBLE()
//                break;
//            case .background:
//                break
//            @unknown default:
//                break
//            }
//        }
    }
}
