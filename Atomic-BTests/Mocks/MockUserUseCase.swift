@testable import Atomic_B
import Foundation

final class MockUserUseCase: UserUseCase {
  var getListUserResult: Result<[UserEntity], Error>?
  var getUserResult: Result<UserDetailEntity, Error>?

  var lastPerPage: Int?
  var lastSince: Int?
  var lastUsername: String?

  // Remove duplicate Equatable conformance since it's already in main target
  static func mockUser(id: Int = 1, login: String = "testUser") -> UserEntity {
    UserEntity(
      id: UUID(),
      login: login,
      avatarUrl: "https://test.com",
      htmlUrl: "https://github.com/\(login)"
    )
  }

  static func mockUserDetail() -> UserDetailEntity {
    UserDetailEntity(
      id: 1,
      login: "testUser",
      avatarUrl: "https://test.com",
      htmlUrl: "https://github.com/testUser",
      name: "Test User",
      company: "Test Company",
      blog: "https://test.com",
      location: "Test Location",
      email: "test@example.com",
      bio: "Test Bio",
      publicRepos: 10,
      publicGists: 5,
      followers: 100,
      following: 50
    )
  }

  func getListUser(perPage: Int, since: Int) async throws -> [UserEntity] {
    self.lastPerPage = perPage
    self.lastSince = since

    switch self.getListUserResult {
    case let .success(users):
      return users
    case let .failure(error):
      throw error
    case .none:
      return []
    }
  }

  func getUser(with loginUsername: String) async throws -> UserDetailEntity {
    self.lastUsername = loginUsername

    switch self.getUserResult {
    case let .success(user):
      return user
    case let .failure(error):
      throw error
    case .none:
      throw NSError(domain: "MockUserUseCase", code: -1)
    }
  }
}
