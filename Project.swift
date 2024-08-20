import Foundation
import ProjectDescription

let name = "FulliOS"

let versionNumber = "1.0.0"

let setupGitHooks = TargetScript.pre(
    script: readFromFile(.relativeToRoot("Scripts/BuildPhases/setup-git-hooks.sh")),
    name: "Setup Git Hooks",
    basedOnDependencyAnalysis: false)

let runSwiftGen = TargetScript.pre(
    script: readFromFile(.relativeToRoot("Scripts/BuildPhases/run-swiftgen.sh")),
    name: "Run SwiftGen",
    basedOnDependencyAnalysis: false)

let runRswift = TargetScript.pre(
    script: readFromFile(.relativeToRoot("Scripts/BuildPhases/run-rswift.sh")),
    name: "Run R.swift",
    basedOnDependencyAnalysis: false)

let runSwiftFormat = TargetScript.pre(
    script: readFromFile(.relativeToRoot("Scripts/BuildPhases/run-swiftformat.sh")),
    name: "Format Code With SwiftFormat",
    basedOnDependencyAnalysis: false)

let runSwiftLint = TargetScript.pre(
    script: readFromFile(.relativeToRoot("Scripts/BuildPhases/run-swiftlint.sh")),
    name: "Lint Code With SwiftLint",
    basedOnDependencyAnalysis: false)

let runSwiftySpell = TargetScript.pre(
    script: readFromFile(.relativeToRoot("Scripts/BuildPhases/run-swiftyspell.sh")),
    name: "Check Spelling With SwiftySpell",
    basedOnDependencyAnalysis: false)

let runPeriphery = TargetScript.pre(
    script: readFromFile(.relativeToRoot("Scripts/BuildPhases/run-periphery.sh")),
    name: "Identify Unused Code With Periphery",
    basedOnDependencyAnalysis: false)

let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": Plist.Value(stringLiteral: versionNumber),
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "NSAppleMusicUsageDescription": "Please allow access to media.",
    "NSPhotoLibraryUsageDescription": "Please allow access to the Photo library to add photo's to posts.",
    "NSLocalNetworkUsageDescription": "Please allow access to local network to enable audio calling",
    "UIApplicationSceneManifest": ["UISceneConfigurations": [:]],
    "UIFileSharingEnabled": .boolean(true),
    "LSSupportsOpeningDocumentsInPlace": .boolean(true),
    "NSPhotoLibraryAddUsageDescription": "We need access to save photos to your library",
    "NSCameraUsageDescription": "We need access to the camera to take photos",
    "UIAppFonts": .array([
        .string("charlatan.otf"),
        .string("balsamiq.ttf"),
        .string("din.ttf")
    ]),
    "NSBonjourServices": .array([
        .string("_dartobservatory._tcp")
    ]),
    "NSFaceIDUsageDescription": "We use Face ID to enhance security",
    "NSLocationWhenInUseUsageDescription": "We need your location to show it on the map",
    "NSLocationAlwaysUsageDescription": "We need your location to show it on the map",
    "NSMicrophoneUsageDescription": "We need access to your microphone to record audio",
    "NSSpeechRecognitionUsageDescription": "This app uses speech recognition to convert your speech to text.",
    "NSBluetoothAlwaysUsageDescription": "This app uses Bluetooth to connect to nearby devices for enhanced functionality.",
    "NSHealthUpdateUsageDescription": "We need to update your health data.",
    "NSHealthShareUsageDescription": "We need to access your health data to provide personalized insights."
]

let project = Project(
    name: name,
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "55DHYS5FJZ",
            "EXCLUDED_ARCHS[sdk=iphonesimulator*]": "arm64",
            "SWIFT_OBJC_BRIDGING_HEADER": "\(name)/Sources/Common/BridgingHeader/FulliOS-Bridging-Header.h",
            "GCC_PREFIX_HEADER": "\(name)/Sources/Common/PrefixHeader/FulliOS-Prefix-Header.pch",
            "GCC_PRECOMPILE_PREFIX_HEADER": "YES",
            "HEADER_SEARCH_PATHS": "$(SRCROOT)/\(name)/Sources/Common/Wrappers/OpenCVWrapper"
        ],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: .relativeToRoot("Configurations/Debug.xcconfig")),
            .release(
                name: "Release",
                xcconfig: .relativeToRoot("Configurations/Release.xcconfig"))
        ]),
    targets: [
        .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: "io.github.yassinelafryhi.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            scripts: [
                setupGitHooks,
                runSwiftGen,
                runRswift,
                runSwiftFormat,
                runSwiftLint,
                runSwiftySpell,
                runPeriphery
            ],
            dependencies: [
                .xcframework(path: .relativeToRoot("Frameworks/App.xcframework")),
                .xcframework(path: .relativeToRoot("Frameworks/Flutter.xcframework")),
                .framework(path: .relativeToRoot("Frameworks/shared.framework")),
                .framework(path: .relativeToRoot("Frameworks/UnityFramework.framework")),
                .library(
                    path: .relativeToRoot("StaticLibs/librust.a"),
                    publicHeaders: .relativeToRoot("RustLibrary"),
                    swiftModuleMap: nil),
                .library(
                    path: .relativeToRoot("StaticLibs/libc.a"),
                    publicHeaders: .relativeToRoot("CLibrary"),
                    swiftModuleMap: nil)
            ]),
        .target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.github.yassinelafryhi.\(name)Tests",
            infoPlist: .default,
            sources: ["\(name)/Tests/**"],
            resources: [],
            dependencies: [.target(name: name)]),
        .target(
            name: "\(name)UITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "io.github.yassinelafryhi.\(name)UITests",
            infoPlist: .default,
            sources: ["\(name)/UITests/**"],
            resources: [],
            dependencies: [.target(name: name)])
    ])

func readFromFile(_ path: ProjectDescription.Path) -> String {
    let fileURL = URL(fileURLWithPath: path.pathString)
    let content = try! String(contentsOf: fileURL, encoding: .utf8)
    return content
}
