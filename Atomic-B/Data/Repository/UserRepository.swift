import Foundation
import Networking

final class UserRepository: UserRepositoryProtocol {
  private let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }

  func getListUser(perPage: Int, since: Int) async throws -> [UserEntity] {
    let result: [UserResponse] = try await networkService.request(UserEndpoint.getListUser(perPage, since))
    return result.map { $0.toDomain() }
  }

  func getUser(with loginUsername: String) async throws -> UserDetailEntity {
    let result: UserDetailResponse = try await networkService.request(UserEndpoint.getUserDetail(loginUsername))
    return result.toDomain()
  }
}
