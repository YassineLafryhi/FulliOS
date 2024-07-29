//
//  BluetoothManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import CoreBluetooth
import SwiftUI

internal class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isBluetoothOn = false
    @Published var peripherals: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var discoveredServices: [CBService] = []
    @Published var discoveredCharacteristics: [CBCharacteristic] = []
    @Published var receivedData: Data?

    private var centralManager: CBCentralManager?
    private var targetPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        if centralManager?.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            isBluetoothOn = true
            startScanning()
        default:
            isBluetoothOn = false
        }
    }

    func centralManager(
        _: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData _: [String: Any],
        rssi _: NSNumber) {
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
        }
    }

    func connect(to peripheral: CBPeripheral) {
        targetPeripheral = peripheral
        centralManager?.connect(peripheral, options: nil)
    }

    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices _: Error?) {
        if let services = peripheral.services {
            discoveredServices = services
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error _: Error?) {
        if let characteristics = service.characteristics {
            discoveredCharacteristics.append(contentsOf: characteristics)
        }
    }

    func readValue(for characteristic: CBCharacteristic) {
        targetPeripheral?.readValue(for: characteristic)
    }

    func writeValue(_ data: Data, for characteristic: CBCharacteristic) {
        targetPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }

    func peripheral(_: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error _: Error?) {
        if let value = characteristic.value {
            receivedData = value
        }
    }
}
