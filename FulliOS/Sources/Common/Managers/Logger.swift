//
//  LoggerManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import Foundation

internal func log(_ message: String) {
    Logger.shared.log("FulliOS: \(message)")
}

internal enum LogLevel: String {
    case debug = "[DEBUG]"
    case info = "[INFO]"
    case warning = "[WARNING]"
    case error = "[ERROR]"
}

internal class Logger {
    static let shared = Logger()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Shared.defaultDateAndTimeFormat
        return formatter
    }()

    private let loggingQueue: DispatchQueue = .init(label: "LoggerQueue")

    private var fileHandle: FileHandle?

    private init() {
        initializeLogFile()
    }

    func log(
        _ message: String,
        level: LogLevel = .debug,
        fileName: String = #file,
        line: Int = #line,
        functionName: String = #function) {
        let timestamp = dateFormatter.string(from: Date())
        let logMessage =
            "\(timestamp) \(level.rawValue) [\(sourceFileName(filePath: fileName)):\(line) \(functionName)] \(message)\n"

        loggingQueue.async {
            Swift.print(logMessage)
            if let data = logMessage.data(using: .utf8) {
                self.fileHandle?.write(data)
            }
        }
    }

    private func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        if let last = components.last {
            return components.isEmpty ? "" : last
        } else {
            return ""
        }
    }

    private func initializeLogFile() {
        let fileManager = FileManager.default
        let logsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let logFileURL = logsDirectory.appendingPathComponent("AppLogs.txt")

        if !fileManager.fileExists(atPath: logFileURL.path) {
            try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
        }

        fileHandle = try? FileHandle(forWritingTo: logFileURL)
        fileHandle?.seekToEndOfFile()
    }
}

extension Logger {
    static func debug(_ message: String, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        shared.log(message, level: .debug, fileName: fileName, line: line, functionName: functionName)
    }

    static func info(_ message: String, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        shared.log(message, level: .info, fileName: fileName, line: line, functionName: functionName)
    }

    static func warning(_ message: String, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        shared.log(message, level: .warning, fileName: fileName, line: line, functionName: functionName)
    }

    static func error(_ message: String, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        shared.log(message, level: .error, fileName: fileName, line: line, functionName: functionName)
    }
}
