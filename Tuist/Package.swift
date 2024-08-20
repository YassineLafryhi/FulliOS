// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "FulliOS",
    dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1"),
    //.package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
    //.package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.5"),

        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
    ]
)
