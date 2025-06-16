@testable import Atomic_B
import Combine
import XCTest

final class ListUserGitHubViewModelTests: XCTestCase {
  private var sut: ListUserGitHubViewModel!
  private var mockUseCase: MockUserUseCase!
  private var cancellables: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    self.mockUseCase = MockUserUseCase()
    self.sut = ListUserGitHubViewModel(userUseCase: self.mockUseCase)
    self.cancellables = []
  }

  override func tearDown() {
    self.sut = nil
    self.mockUseCase = nil
    self.cancellables = nil
    super.tearDown()
  }

  func testInitialState() {
    XCTAssertTrue(self.sut.users.isEmpty)
  }

  func testLoadUsersSuccess() async {
    // Given
    let expectedUsers = TestData.mockUsers(count: 2)
    self.mockUseCase.getListUserResult = .success(expectedUsers)

    // When
    await self.sut.loadUsers()

    // Then
    XCTAssertEqual(self.sut.users.count, 2)
  }

  func testLoadUsersFailure() async {
    // Given
    let mockError = TestData.mockError(message: "Network error")
    self.mockUseCase.getListUserResult = .failure(mockError)

    // When
    await self.sut.loadUsers()

    // Then
    XCTAssertTrue(self.sut.users.isEmpty)
  }

  func testLoadMoreUsers() async {
    // Given
    let initialUsers = TestData.mockUsers(count: 2)
    let moreUsers = TestData.mockUsers(count: 2, startIndex: 2)
    self.mockUseCase.getListUserResult = .success(initialUsers)

    // When
    await self.sut.loadUsers()
    self.mockUseCase.getListUserResult = .success(moreUsers)
    await self.sut.loadUsers(since: 3)

    // Then
    XCTAssertEqual(self.sut.users.count, 4)
  }
}
