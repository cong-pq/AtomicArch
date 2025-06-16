import Foundation

public protocol NetworkServiceProtocol {
  func request<T: Decodable>(_ target: Target) async throws -> T
}
