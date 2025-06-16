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
      return true
    case (.invalidResponse, .invalidResponse):
      return true
    case let (.httpError(lhsCode, _), .httpError(rhsCode, _)):
      return lhsCode == rhsCode
    case (.decodingError, .decodingError):
      return true
    default:
      return false
    }
  }

  public var localizedDescription: String {
    switch self {
    case .invalidURL:
      return "Invalid URL"
    case .invalidResponse:
      return "Invalid response from server"
    case let .httpError(statusCode, _):
      return "HTTP error with status code: \(statusCode)"
    case let .decodingError(error):
      return "Failed to decode response: \(error.localizedDescription)"
    case let .networkError(error):
      return "Network error: \(error.localizedDescription)"
    case .unauthorized:
      return "Unauthorized access"
    case .timeout:
      return "Request timed out"
    case .cancelled:
      return "Request was cancelled"
    case .sslPinningFailed:
      return "SSL certificate validation failed"
    case .noConnection:
      return "No internet connection available"
    case .unknown:
      return "Unknown error occurred"
    }
  }
}
