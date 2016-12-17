# Vapor Checksum Assets

![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)
![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20OS%20X-blue.svg)
![Package Managers](https://img.shields.io/badge/package%20managers-SwiftPM-yellow.svg)

> Add checksums of `.js`/`.css` files to url querystring in [Vapor](https://vapor.codes/) applications for cache busting.

## Installation

Via Swift Package Manager:

```swift
.Package(url: "https://github.com/voronianski/vapor-checksum-assets.git", majorVersion: 0, minor: 1)
```

## Usage

Module has a minimal API:

```swift
import Vapor

let drop = Droplet()

// pass application instance
let cs = ChecksumAssetsManager(drop)

// files are looked up in ./Public folder
let js = try cs.add("/path/to/build.js")

// returns "/path/to/build.js?f2c175192bfd0508b30d72e020af74252b98dcc3"
print(js)
```

## Example

Controller example that uses `ChecksumAssetsManager` to versionify assets and pass urls to [Leaf](https://github.com/vapor/leaf) template:

```swift
// ./Sources/App/main.swift

import HTTP
import Vapor

class ClientController {
  let cs: ChecksumAssetsManager

  init() {
    cs = ChecksumAssetsManager(drop)
  }

  func index(_ req: Request) throws -> ResponseRepresentable {
    // it's easy to add separate methods for production and development
    return try serve()
  }

  func serve() throws -> View {
    let css = try cs.add("/build/app.css")
    let js = try cs.add("/build/app.js")

    return try drop.view.make("index", [
      "maincss": css,
      "mainjs": js
    ])
  }
}

let drop = Droplet()

let cc = ClientController()
drop.get("/", handler: cc.index)

drop.run()
```

```html
<!-- ./Resources/Views/index.leaf -->

<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Example</title>
    <link rel="stylesheet" href="#(maincss)" type="text/css" />
  </head>

  <body>
    <script src="#(mainjs)"></script>
  </body>
</html>
```

---

**MIT Licensed**
