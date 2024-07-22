//
//  NFCReader.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 22/7/2024.
//

import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var scannedMessage = ""
    private var nfcSession: NFCNDEFReaderSession?

    func scan() {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = "Hold your iPhone near an NFC tag."
        nfcSession?.begin()
    }

    func readerSession(_: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.scannedMessage = "Scanning failed: \(error.localizedDescription)"
        }
    }

    func readerSession(_: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard
            let ndefMessage = messages.first,
            let record = ndefMessage.records.first,
            record.typeNameFormat != .empty else {
            DispatchQueue.main.async {
                self.scannedMessage = "No valid message found."
            }
            return
        }

        if let string = String(data: record.payload, encoding: .utf8) {
            DispatchQueue.main.async {
                self.scannedMessage = string
            }
        }
    }
}
