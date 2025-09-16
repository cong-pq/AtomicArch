import Foundation

public extension LoggerProtocol {
  func log(
    request: URLRequest? = nil,
    data: Data? = nil,
    response: HTTPURLResponse? = nil,
    error: Error? = nil
  ) {
    var message = ""

    // Log the request details
    if let request {
      message += "\n📤 Request:\n\(request.logMessage())"
    }

    // Log the response details
    message += "\n📥 Response:\n"

    if let statusCode = response?.statusCode {
      message += "  ✅ Status Code: \(statusCode)\n"
    }

    if let data {
      message += "  📦 Payload:\n\(data.prettyPrintPayload().indented(by: 4))\n"
    } else {
      message += "  📦 Payload: No data received\n"
    }

    // Log errors if present
    if let error {
      message += "  ❌ Error: \(error.localizedDescription)\n"
      self.log(level: .error, message: message)
    } else {
      self.log(level: .info, message: message)
    }

    message += "\n=== Log End ===\n"
  }
}

public extension URLRequest {
  func logMessage() -> String {
    var result = ""
    result += " \n🌐 Endpoint: \(url?.absoluteString ?? "N/A")"
    result += " \n🗂 Headers:\n\(allHTTPHeaderFields?.prettyPrint() ?? "N/A")"
    result += " \n🔧 Method: \(httpMethod ?? "N/A")"
    return result
  }
}

extension Data {
  /// Pretty prints the payload from `Data` as JSON or plain text.
  func prettyPrintPayload() -> String {
    if
      let json = try? JSONSerialization.jsonObject(with: self, options: []),
      let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
      let jsonString = String(data: jsonData, encoding: .utf8)
    {
      jsonString
    } else if let string = String(data: self, encoding: .utf8) {
      "\"\(string)\""
    } else {
      "\"Unable to parse payload\""
    }
  }
}

extension Dictionary where Key == String {
  /// Converts a dictionary to a pretty-printed JSON string.
  func prettyPrint() -> String {
    var string = ""
    let options: JSONSerialization.WritingOptions = [.prettyPrinted]
    if let data = try? JSONSerialization.data(withJSONObject: self, options: options) {
      if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        string = nstr as String
      }
    }
    return string
  }
}

extension String {
  /// Adds indentation to each line of the string.
  func indented(by spaces: Int) -> String {
    let indentation = String(repeating: " ", count: spaces)
    return self
      .split(separator: "\n")
      .map { "\(indentation)\($0)" }
      .joined(separator: "\n")
  }
}
