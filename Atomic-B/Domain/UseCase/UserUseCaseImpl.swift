import Foundation

final class UserUseCaseImpl: UserUseCase {
  private let repository: UserRepositoryProtocol

  init(repository: UserRepositoryProtocol) {
    self.repository = repository
  }

  func getListUser(perPage: Int, since: Int) async throws -> [UserEntity] {
    // Validate pagination parameters
    try UserValidator.validatePaginationParameters(perPage: perPage, since: since)

    // Get users from repository
    let users = try await repository.getListUser(perPage: perPage, since: since)

    // Validate each user
    try users.forEach { try UserValidator.validateUser($0) }

    return users
  }

  func getUser(with loginUsername: String) async throws -> UserDetailEntity {
    // Validate username
    try UserValidator.validateUsername(loginUsername)

    // Get user from repository
    let user = try await repository.getUser(with: loginUsername)

    // Validate user data
    try UserValidator.validateUserDetail(user)

    return user
  }
}
