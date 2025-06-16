# AtomicLogger

A lightweight, protocol-based logging library for Swift applications, designed to provide flexible and extensible logging capabilities. It integrates with Apple's `swift-log` package and supports various logging levels, making it easy to log messages, network requests, and responses.

## Features

- **Protocol-based design** for flexible logging strategies
- **Multiple logging levels** (trace, debug, info, notice, warning, error, critical)
- **Lazy message evaluation** using `@autoclosure`
- **No-op logger** for production builds or when logging is disabled
- **Networking extensions** for logging HTTP requests and responses
- **iOS 16+ support** via Swift Package Manager

---

## Installation

### Local Package

Add the package to your `Package.swift` dependencies:

```swift
.package(path: "../AtomicLogger")
```

### Remote Package

Alternatively, you can use the remote package:

```swift
.package(url: "https://github.com/yourusername/AtomicLogger.git", from: "1.0.0")
```

Or use Xcode's Swift Package Manager integration.

---

## Usage

### 1. Initialize a Logger

```swift
import AtomicLogger

let logger = LoggerImpl(label: "com.myapp.logger")
```

### 2. Log Messages

```swift
logger.log(level: .info, message: "Application started")
logger.log(level: .error, message: "An error occurred: \(error.localizedDescription)")
```

### 3. Use NoLogger for Production

```swift
let noLogger = NoLogger(label: "com.myapp.logger")
// No logs will be recorded
```

### 4. Log Network Requests and Responses

```swift
logger.log(request: urlRequest, data: responseData, response: httpResponse, error: nil)
```

---

## API Reference

### LoggerProtocol

```swift
public protocol LoggerProtocol {
    func log(level: LogLevel, message: @autoclosure () -> String)
}
```

### LogLevel

```swift
public enum LogLevel {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical
}
```

### Networking Extensions

- **Logging HTTP Requests and Responses**:
  ```swift
  func log(request: URLRequest? = nil, data: Data? = nil, response: HTTPURLResponse? = nil, error: Error? = nil)
  ```

- **Pretty Printing**:
  - `Data.prettyPrintPayload()`: Converts `Data` to a pretty-printed JSON or plain text.
  - `Dictionary.prettyPrint()`: Converts a dictionary to a pretty-printed JSON string.
  - `String.indented(by:)`: Adds indentation to each line of a string.

---

## License

This package is licensed under the terms of the license included in the `LICENSE` file. 