//
//  DeviceInfoView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/7/2024.
//

import CoreMotion
import DeviceKit
import SwiftUI

internal struct DeviceInfoView: View {
    let device = Device.current
    let motionManager = CMMotionManager()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    InfoRow(title: "Model", value: device.description)
                    InfoRow(title: "Name", value: device.name ?? "Unknown")
                    InfoRow(title: "iOS Version", value: device.systemVersion ?? "Unknown")
                    InfoRow(title: "Screen Size", value: "\(String(format: "%.1f", device.diagonal)) inches")
                    InfoRow(title: "Screen Resolution", value: screenResolutionString())
                    InfoRow(title: "CPU", value: device.cpu.description)
                }

                Group {
                    InfoRow(title: "CPU Cores", value: "\(ProcessInfo.processInfo.processorCount)")
                    InfoRow(title: "RAM", value: formatBytes(Int64(ProcessInfo.processInfo.physicalMemory)))
                    // InfoRow(title: "Total Disk Space", value: formatBytes(device.diskSpace ?? 0))
                    InfoRow(title: "Battery Level", value: "\(Int((device.batteryLevel ?? 0) * 100))%")
                    InfoRow(title: "Battery State", value: batteryStateString(device.batteryState))
                }

                Group {
                    InfoRow(title: "Accelerometer", value: motionManager.isAccelerometerAvailable ? "Available" : "Not Available")
                    InfoRow(title: "Gyroscope", value: motionManager.isGyroAvailable ? "Available" : "Not Available")
                    InfoRow(title: "Magnetometer", value: motionManager.isMagnetometerAvailable ? "Available" : "Not Available")
                    // InfoRow(title: "Device Orientation", value: UIDevice.current.orientation.description)
                }

                Group {
                    InfoRow(title: "IP Address", value: getWiFiAddress() ?? "Not Available")
                    // InfoRow(title: "Carrier", value: device.carrierName ?? "Not Available")
                }
            }
            .padding()
        }
        .navigationBarTitle("Device Info", displayMode: .inline)
    }

    private func screenResolutionString() -> String {
        let bounds = UIScreen.main.nativeBounds
        return "\(Int(bounds.width)) x \(Int(bounds.height))"
    }

    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }

    private func batteryStateString(_ state: Device.BatteryState?) -> String {
        switch state {
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        case .unplugged:
            return "Unplugged"
        case .none:
            return "Not Available"
        @unknown default:
            return "Unknown"
        }
    }

    private func getWiFiAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(
                        &addr,
                        socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname,
                        socklen_t(hostname.count),
                        nil,
                        socklen_t(0),
                        NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}

internal struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .bold()
            Spacer()
            Text(value)
        }
    }
}
