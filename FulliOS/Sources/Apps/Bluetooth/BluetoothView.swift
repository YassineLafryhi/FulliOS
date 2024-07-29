//
//  BluetoothView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import SwiftUI

internal struct BluetoothView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()

    var body: some View {
        NavigationView {
            List(bluetoothManager.peripherals, id: \.identifier) { peripheral in
                NavigationLink(destination: PeripheralDetailView(bluetoothManager: bluetoothManager)) {
                    Text(peripheral.name ?? "Unknown")
                }
                .onTapGesture {
                    bluetoothManager.connect(to: peripheral)
                }
            }
            .navigationTitle("Peripherals")
            .onAppear {
                bluetoothManager.startScanning()
            }
        }
    }
}
