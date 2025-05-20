// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "kaspa-price-bot",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.0")
    ],
    targets: [
        .target(
            name: "kaspa_price_bot",
            dependencies: ["Alamofire"])
    ]
)