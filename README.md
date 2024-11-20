<p align="center">
<a href="https://www.kitura.io/">
<img src="https://raw.githubusercontent.com/Kitura/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
</a>
</p>


[![APIDoc](https://img.shields.io/badge/apidoc-KituraContracts-1FBCE4.svg?style=flat)](https://kitura.github.io/KituraContracts/index.html)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKitura%2FKituraContracts%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Kitura/KituraContracts)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKitura%2FKituraContracts%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Kitura/KituraContracts)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


# KituraContracts

## Summary

KituraContracts is a library containing type definitions shared by client (e.g. [KituraKit](https://kitura.github.io/KituraKit/)) and server (e.g. [Kitura](https://kitura.github.io/Kitura)) code. These shared type definitions include [Codable Closure Aliases](https://kitura.github.io/KituraContracts/Typealiases.html), [RequestError](https://kitura.github.io/KituraContracts/Structs/RequestError.html), [QueryEncoder](https://kitura.github.io/KituraContracts/Classes/QueryEncoder.html), [QueryDecoder](https://kitura.github.io/KituraContracts/Classes/QueryDecoder.html), [Coder](https://kitura.github.io/KituraContracts/Classes/Coder.html), [Identifier Protocol](https://kitura.github.io/KituraContracts/Protocols/Identifier.html#/s:15KituraContracts10IdentifierP5valueSSv) and [Extensions](https://kitura.github.io/KituraContracts/Extensions.html#/s:SS) to String and Int, which add conformity to the Identifier protocol.

## Usage

KituraContracts represents the types and protocols that are common to both the [Kitura](https://github.com/Kitura/Kitura) server and [KituraKit](https://github.com/Kitura/KituraKit) client side library. If you are using Kitura or KituraKit, your project does not need to depend on KituraContracts explicitly.

#### Add dependencies

Add the `KituraContracts` package to the dependencies within your application’s `Package.swift` file. Substitute `"x.x.x"` with the latest `KituraContracts` [release](https://github.com/Kitura/KituraContracts/releases).

```swift
.package(url: "https://github.com/Kitura/KituraContracts.git", from: "x.x.x")
```

Add `KituraContracts` to your target's dependencies:

```swift
.target(name: "example", dependencies: ["KituraContracts"]),
```

#### Import package

```swift
import KituraContracts
```

## Example

This example, shows how to use a shared type definition for `RequestError` within a router POST method on `users`. If no errors occurred and you have a `User` you can respond with the user and pass nil as the `RequestError?` value. If there has been an error you can respond with an appropriate error and pass nil for the `User?`.

````swift
public struct User: Codable {
    ...
}

router.post("/users") { (user: User, respondWith: (User?, RequestError?) -> Void) in

    if databaseConnectionIsOk {
        ...
        respondWith(user, nil)
    } else {
        ...
        respondWith(nil, .internalServerError)
    }
}
````

## Swift version

The 1.x.x releases were tested on macOS and Linux using the Swift 4.1 binaries. Please note that this is the default version of Swift that is included in [Xcode 9.3](https://developer.apple.com/xcode/).

## API Documentation
For more information visit our [API reference](https://kitura.github.io/KituraContracts/index.html).

## Community

We love to talk server-side Swift and Kitura. Join our [Slack](http://swift-at-ibm-slack.mybluemix.net/) to meet the team!

## License

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/Kitura/KituraContracts/blob/master/LICENSE).
