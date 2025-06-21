import Foundation

/// @mockable
protocol UserRepositoryProtocol {
  func getListUser(perPage: Int, since: Int) async throws -> [UserEntity]
  func getUser(with loginUsername: String) async throws -> UserDetailEntity
}
