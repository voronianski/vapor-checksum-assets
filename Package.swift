import PackageDescription

let package = Package(
  name: "VaporChecksumAssets",
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1)
  ]
)
