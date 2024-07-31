//
//  WebServerView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 27/7/2024.
//

import Network
import SwiftUI

internal struct WebServerView: View {
    @State private var serverStatus = "Server is not running"
    @State private var serverAddress = "IP Address: Unknown"

    var body: some View {
        VStack {
            FText(serverStatus)
            FText(serverAddress)
            FButton("Start Server") {
                startServer()
            }
        }
    }

    func startServer() {
        WebServerManager.shared.startServer()
        serverStatus = "Server is running"
        if let ipAddress = getIPAddress() {
            serverAddress = "IP Address: \(ipAddress):8080"
        }
    }

    func getIPAddress() -> String? {
        var address: String?
        var interfaceAddress: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&interfaceAddress) == 0 {
            var ptr = interfaceAddress
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { continue }
                let addressFamily = interface.ifa_addr.pointee.sa_family
                if addressFamily == UInt8(AF_INET) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(
                        interface.ifa_addr,
                        socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname,
                        socklen_t(hostname.count),
                        nil,
                        socklen_t(0),
                        NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
            freeifaddrs(interfaceAddress)
        }
        return address
    }
}
