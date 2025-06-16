# AtomicCore

A lightweight Swift package providing MVVM + Coordinator architecture components for iOS applications.

## Features

- 🏗 MVVM architectural pattern
- 🧭 Coordinator-based navigation
- 🔄 Combine integration
- 📱 UIKit components
- 🧪 Unit test support
- 🎯 Type-safe dependency injection

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Local Package
Add AtomicCore to your Xcode project as a local Swift package:

1. Add package location:
```swift
dependencies: [
    .package(path: "../AtomicCore")
]
```

2. Add dependency to your target:
```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["AtomicCore"])
]
```

### Usage

## License

AtomicCore is available under the MIT license. See the LICENSE file for more info.