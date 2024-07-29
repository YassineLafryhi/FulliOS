//
//  NFCReaderView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 22/7/2024.
//

import CoreNFC
import SwiftUI

internal struct NFCReaderView: View {
    @StateObject private var nfcReader = NFCReader()
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("NFC Reader")
                .font(.largeTitle)

            Button(action: {
                nfcReader.scan()
            }) {
                Text("Scan NFC Tag")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if !nfcReader.scannedMessage.isEmpty {
                Text("Scanned Message:")
                    .font(.headline)
                Text(nfcReader.scannedMessage)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Scanning Not Supported"),
                message: Text("This device doesn't support NFC scanning."),
                dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if !NFCNDEFReaderSession.readingAvailable {
                showAlert = true
            }
        }
    }
}
