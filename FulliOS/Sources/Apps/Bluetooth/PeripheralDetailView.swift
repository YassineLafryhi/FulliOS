//
//  PeripheralDetailView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import SwiftUI

internal struct PeripheralDetailView: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        List {
            Section(header: Text("Services")) {
                ForEach(bluetoothManager.discoveredServices, id: \.uuid) { service in
                    Text(service.uuid.uuidString)
                }
            }
            Section(header: Text("Characteristics")) {
                ForEach(bluetoothManager.discoveredCharacteristics, id: \.uuid) { characteristic in
                    HStack {
                        Text(characteristic.uuid.uuidString)
                        Spacer()
                        if characteristic.properties.contains(.read) {
                            Button(action: {
                                bluetoothManager.readValue(for: characteristic)
                            }) {
                                Text("Read")
                            }
                        }
                        if characteristic.properties.contains(.write) {
                            Button(action: {
                                let dataToWrite = "test".data(using: .utf8)!
                                bluetoothManager.writeValue(dataToWrite, for: characteristic)
                            }) {
                                Text("Write")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Peripheral Details")
    }
}
