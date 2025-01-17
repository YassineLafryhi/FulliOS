#!/usr/bin/env swift
import Foundation

let sharedSourcePaths: [String] = [
    "FulliOS/Sources/Common/**",
    "FulliOS/Sources/Components/**",
    "FulliOS/Sources/Constants/**",
    "FulliOS/Sources/Generated/**",
    "FulliOS/Sources/FulliOSApp.swift"
]

let swiftToolsVersion = "5.7"
let iOSDeploymentTarget = "16.0"

guard CommandLine.arguments.count > 1 else {
    print("Usage: ./generate.swift <AppName>")
    exit(1)
}

let appName = CommandLine.arguments[1]

let subAppPath = "FulliOS/Sources/Apps/\(appName)"
guard FileManager.default.fileExists(atPath: subAppPath) else {
    print("❌ The folder `\(subAppPath)` does not exist.")
    exit(1)
}

let projectSwiftContent = """
import ProjectDescription

let projectName = "\(appName)"

let dependencies: [TargetDependency] = [
    .external(name: "Alamofire")
]

let project = Project(
    name: projectName,
    organizationName: "MyOrg",
    packages: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0")
    ],
    targets: [
        Target(
            name: projectName,
            platform: .iOS,
            product: .app,
            bundleId: "com.example.\(appName.lowercased())",
            deploymentTarget: .iOS(targetVersion: "\(iOSDeploymentTarget)", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: [
                "\(subAppPath)/**"
            ] + [
                \(sharedSourcePaths.map { "\"\($0)\"" }.joined(separator: ", "))
            ],
            resources: [
                "\(subAppPath)/**/*.xcassets",
                "\(subAppPath)/**/*.xib",
                "\(subAppPath)/**/*.storyboard"
            ],
            dependencies: dependencies
        )
    ]
)
"""

let projectFilePath = "Project.swift"

do {
    print("🔧 Generating `Project.swift` for app: \(appName)")
    try projectSwiftContent.write(toFile: projectFilePath, atomically: true, encoding: .utf8)
} catch {
    print("❌ Failed to write \(projectFilePath): \(error)")
    exit(1)
}

let genResult = runShellCommand("tuist generate")
guard genResult == 0 else {
    print("❌ tuist generate failed.")
    exit(1)
}

_ = runShellCommand("open \(appName).xcworkspace")

@discardableResult
func runShellCommand(_ command: String) -> Int32 {
    print(">> \(command)")
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
