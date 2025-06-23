import Foundation

public protocol NetworkService {
  func request<T: Decodable>(_ target: Target) async throws -> T
}
