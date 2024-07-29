//
//  CrashHandler.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import Foundation

internal class CrashHandler {
    static let shared = CrashHandler()

    func setupCrashHandler() {
        NSSetUncaughtExceptionHandler { exception in
            CrashHandler.shared.handleException(exception: exception)
        }

        signal(SIGABRT) { _ in CrashHandler.shared.handleSignal(SIGABRT) }
        signal(SIGILL) { _ in CrashHandler.shared.handleSignal(SIGILL) }
        signal(SIGSEGV) { _ in CrashHandler.shared.handleSignal(SIGSEGV) }
        signal(SIGFPE) { _ in CrashHandler.shared.handleSignal(SIGFPE) }
        signal(SIGBUS) { _ in CrashHandler.shared.handleSignal(SIGBUS) }
        signal(SIGPIPE) { _ in CrashHandler.shared.handleSignal(SIGPIPE) }
    }

    func handleException(exception: NSException) {
        let crashDetails = [
            "name": exception.name.rawValue,
            "reason": exception.reason ?? "Unknown",
            "userInfo": exception.userInfo ?? [:],
            "callStackSymbols": exception.callStackSymbols
        ] as [String: Any]

        saveCrashReport(crashDetails)
    }

    func handleSignal(_ signal: Int32) {
        let crashDetails = [
            "signal": "Received signal \(signal) indicating a crash."
        ] as [String: Any]

        saveCrashReport(crashDetails)
    }

    func saveCrashReport(_ crashDetails: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: crashDetails, options: .prettyPrinted)
            let filePath = getDocumentsDirectory().appendingPathComponent("crashReport.json")
            try jsonData.write(to: filePath)
            print("Crash report saved to \(filePath)")
        } catch {
            print("Failed to save crash report: \(error.localizedDescription)")
        }
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
