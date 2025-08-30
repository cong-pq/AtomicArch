@testable import Atomic_B
import Networking
import XCTest

final class MockNetworkService: NetworkService {
  var requestHandler: ((Target) async throws -> Any)?
  func request<T>(_ target: Target) async throws -> T where T: Decodable {
    if let handler = requestHandler {
      let result = try await handler(target)
      guard let typed = result as? T else {
        throw NetworkError.decodingError(NSError(domain: "", code: -1))
      }
      return typed
    }
    throw NetworkError.unknown
  }
}

final class UserRepositoryImplTests: XCTestCase {
  var networkService: MockNetworkService!
  var repository: UserRepositoryImpl!

  override func setUp() {
    super.setUp()
    self.networkService = MockNetworkService()
    self.repository = UserRepositoryImpl(networkService: self.networkService)
  }

  func test_getListUser_success() async throws {
    // Arrange
    let expected = [UserEntity(id: UUID(), login: "test", avatarUrl: "url", htmlUrl: "html")]
    let userResponses = expected.map { UserResponse(id: 1, login: $0.login, avatarUrl: $0.avatarUrl, htmlUrl: $0.htmlUrl) }
    self.networkService.requestHandler = { _ in userResponses }

    // Act
    let users = try await repository.getListUser(perPage: 10, since: 0)

    // Assert
    XCTAssertEqual(users, expected)
  }

  func test_getListUser_failure() async {
    // Arrange
    self.networkService.requestHandler = { _ in throw NetworkError.noConnection }

    // Act & Assert
    await XCTAssertThrowsErrorAsync(try await self.repository.getListUser(perPage: 10, since: 0)) { error in
      XCTAssertEqual(error as? NetworkError, .noConnection)
    }
  }

  func test_getUser_success() async throws {
    // Arrange
    let expected = UserDetailEntity(id: 1, login: "test", avatarUrl: "a", htmlUrl: "b", name: "Test User", company: "", blog: "", location: "", email: "", bio: "", publicRepos: 0, publicGists: 0, followers: 0, following: 0)
    let userDetailResponse = UserDetailResponse(
      id: 1,
      login: expected.login,
      avatarUrl: expected.avatarUrl, // <-- add this
      htmlUrl: expected.htmlUrl, // <-- add this
      name: expected.name,
      company: expected.company,
      blog: expected.blog,
      location: expected.location,
      email: expected.email,
      bio: expected.bio,
      publicRepos: expected.publicRepos,
      publicGists: expected.publicGists,
      followers: expected.followers,
      following: expected.following
    )
    self.networkService.requestHandler = { _ in userDetailResponse }

    // Act
    let detail = try await repository.getUser(with: "test")

    // Assert
    XCTAssertEqual(detail, expected)
  }

  func test_getUser_failure() async {
    // Arrange
    self.networkService.requestHandler = { _ in throw NetworkError.noConnection }

    // Act & Assert
    await XCTAssertThrowsErrorAsync(try await self.repository.getUser(with: "test")) { error in
      XCTAssertEqual(error as? NetworkError, .noConnection)
    }
  }
}
