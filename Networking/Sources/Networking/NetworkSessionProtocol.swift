import Foundation

public protocol NetworkSessionProtocol: AnyObject {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

@available(iOS 15.0, macOS 12.0, *)
extension URLSession: NetworkSessionProtocol {}
