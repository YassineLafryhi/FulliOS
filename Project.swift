import ProjectDescription

let project = Project(
    name: "FulliOS",
    targets: [
        .target(
            name: "FulliOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.github.yassinelafryhi.FulliOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["FulliOS/Sources/**"],
            resources: ["FulliOS/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                //.external(name: "Kingfisher"),
                //.external(name: "SwiftSoup")
            ]
        ),
        .target(
            name: "FulliOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.github.yassinelafryhi.FulliOSTests",
            infoPlist: .default,
            sources: ["FulliOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "FulliOS")]
        ),
        .target(
            name: "FulliOSUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "io.github.yassinelafryhi.FulliOSUITests",
            infoPlist: .default,
            sources: ["FulliOS/UITests/**"],
            resources: [],
            dependencies: [.target(name: "FulliOS")]
        ),
    ]
)
