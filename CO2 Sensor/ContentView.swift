//
//  ContentView.swift
//  CO2 Sensor
//
//  Created by Dima Bondarenko on 2025-08-02.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var bleManager = BLEManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("BLE Status: \(bleManager.isConnected ? "Connected" : "Scanning...")")
                .font(.headline)
            VStack {
                HStack {
                    Text("Received Name:")
                        .font(.subheadline)
                    Text(bleManager.deviceName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    Text("Received CO2:")
                        .font(.subheadline)
                    Text(String(bleManager.gas.co2_ppm))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    Text("Received Temperature:")
                        .font(.subheadline)
                    Text(String(bleManager.temperature.integer))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    Text("Received Humidity:")
                        .font(.subheadline)
                    Text(String(bleManager.humidity))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                }
            }
            
        }
        .padding()
    }
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    
    //    var body: some View {
    //        NavigationSplitView {
    //            List {
    //                ForEach(items) { item in
    //                    NavigationLink {
    //                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
    //                    } label: {
    //                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
    //                    }
    //                }
    //                .onDelete(perform: deleteItems)
    //            }
    //            .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    EditButton()
    //                }
    //                ToolbarItem {
    //                    Button(action: addItem) {
    //                        Label("Add Item", systemImage: "plus")
    //                    }
    //                }
    //            }
    //        } detail: {
    //            Text("Select an item")
    //        }
    //    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(timestamp: Date())
    //            modelContext.insert(newItem)
    //        }
    //    }
    //
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            for index in offsets {
    //                modelContext.delete(items[index])
    //            }
    //        }
    //    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
