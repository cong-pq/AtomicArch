import Foundation

final class UserUseCaseImpl: UserUseCase {
  private let repository: UserRepository

  init(repository: UserRepository) {
    self.repository = repository
  }

  func getListUser(perPage: Int, since: Int) async throws -> [UserEntity] {
    try await self.repository.getListUser(perPage: perPage, since: since)
  }

  func getUser(with loginUsername: String) async throws -> UserDetailEntity {
    try await self.repository.getUser(with: loginUsername)
  }
}
