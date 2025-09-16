import AtomicCore
import Combine
import Foundation

final class ListUserGitHubViewModel: ViewModel, ViewModelType {
  // MARK: - Types

  enum ViewState: Equatable {
    case idle
    case loading
    case loaded([UserEntity])
    case error

    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
      switch (lhs, rhs) {
      case (.idle, .idle):
        true
      case (.loading, .loading):
        true
      case let (.loaded(lhsUser), .loaded(rhsUser)):
        lhsUser == rhsUser
      case (.error, .error):
        true
      default:
        false
      }
    }
  }

  struct Input {
    let loadUsers: AnyPublisher<Void, Never>
    let loadMore: AnyPublisher<UserEntity, Never>
  }

  struct Output {
    let viewState: AnyPublisher<ViewState, Never>
  }

  // MARK: - Properties

  private let userUseCase: UserUseCase
  private let appendQueue = DispatchQueue(label: "com.xproject.UserListViewModel.appendQueue")

  // MARK: - Published Properties

  @Published private(set) var viewState: ViewState = .idle
  @Published private(set) var users: [UserEntity] = []

  // MARK: - Cancellables

  var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization

  init(userUseCase: UserUseCase) {
    self.userUseCase = userUseCase
  }

  // MARK: - ViewModelType

  func transform(input: Input) -> Output {
    // Handle load users
    input.loadUsers
      .sink { [weak self] _ in
        Task {
          await self?.loadUsers()
        }
      }
      .store(in: &self.cancellables)

    // Handle load more
    input.loadMore
      .sink { [weak self] user in
        self?.loadMoreIfNeeded(for: user)
      }
      .store(in: &self.cancellables)

    return Output(
      viewState: self.$viewState.eraseToAnyPublisher()
    )
  }

  // MARK: - Private Methods

  func loadUsers(since: Int = 0) async {
    await MainActor.run {
      self.viewState = .loading
    }

    do {
      let newUsers = try await userUseCase.getListUser(perPage: 50, since: since)
      self.appendUsers(newUsers)
      await MainActor.run {
        self.viewState = .loaded(self.users)
      }
    } catch {
      await MainActor.run {
        self.viewState = .error
      }
    }
  }

  private func appendUsers(_ newUsers: [UserEntity]) {
    self.appendQueue.sync {
      let existingUserIDs = Set(users.map(\.id))
      let filteredUsers = newUsers.filter { !existingUserIDs.contains($0.id) }
      self.users.append(contentsOf: filteredUsers)
    }
  }

  private func loadMoreIfNeeded(for user: UserEntity) {
    guard case .loaded = self.viewState else { return }
    guard let lastUser = users.last, user.id == lastUser.id else { return }

    Task {
      let since = self.users.count
      await self.loadUsers(since: since)
    }
  }
}
