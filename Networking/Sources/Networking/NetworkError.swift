import Foundation

public enum NetworkError: Error, Equatable {
  case invalidURL
  case invalidResponse
  case httpError(statusCode: Int, data: Data?)
  case decodingError(Error)
  case networkError(Error)
  case unauthorized
  case timeout
  case cancelled
  case sslPinningFailed
  case noConnection
  case unknown

  public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.noConnection, .noConnection):
      true
    case (.invalidResponse, .invalidResponse):
      true
    case let (.httpError(lhsCode, _), .httpError(rhsCode, _)):
      lhsCode == rhsCode
    case (.decodingError, .decodingError):
      true
    default:
      false
    }
  }

  public var localizedDescription: String {
    switch self {
    case .invalidURL:
      "Invalid URL"
    case .invalidResponse:
      "Invalid response from server"
    case let .httpError(statusCode, _):
      "HTTP error with status code: \(statusCode)"
    case let .decodingError(error):
      "Failed to decode response: \(error.localizedDescription)"
    case let .networkError(error):
      "Network error: \(error.localizedDescription)"
    case .unauthorized:
      "Unauthorized access"
    case .timeout:
      "Request timed out"
    case .cancelled:
      "Request was cancelled"
    case .sslPinningFailed:
      "SSL certificate validation failed"
    case .noConnection:
      "No internet connection available"
    case .unknown:
      "Unknown error occurred"
    }
  }
}
