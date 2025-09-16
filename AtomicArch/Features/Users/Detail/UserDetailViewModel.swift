import AtomicCore
import Combine
import Foundation

final class UserDetailViewModel: ViewModel, ViewModelType {
  // MARK: - Types

  enum ViewState: Equatable {
    case idle
    case loading
    case loaded(UserDetailEntity)
    case error(Error)

    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
      switch (lhs, rhs) {
      case (.idle, .idle):
        true
      case (.loading, .loading):
        true
      case let (.loaded(lhsUser), .loaded(rhsUser)):
        lhsUser == rhsUser
      case let (.error(lhsError), .error(rhsError)):
        lhsError.localizedDescription == rhsError.localizedDescription
      default:
        false
      }
    }
  }

  struct Input {
    let loadUser: AnyPublisher<Void, Never>
  }

  struct Output {
    let viewState: AnyPublisher<ViewState, Never>
  }

  // MARK: - Properties

  private let userUseCase: UserUseCase
  private let username: String
  private(set) var user: UserDetailEntity?

  // MARK: - Published Properties

  @Published private(set) var viewState: ViewState = .idle

  // MARK: - Cancellables

  var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization

  init(userUseCase: UserUseCase, username: String) {
    self.userUseCase = userUseCase
    self.username = username
  }

  // MARK: - ViewModelType

  func transform(input: Input) -> Output {
    // Handle load user
    input.loadUser
      .sink { [weak self] _ in
        Task {
          await self?.loadUser()
        }
      }
      .store(in: &self.cancellables)

    return Output(
      viewState: self.$viewState.eraseToAnyPublisher()
    )
  }

  // MARK: - Private Methods

  private func loadUser() async {
    await MainActor.run {
      self.viewState = .loading
    }

    do {
      let user = try await userUseCase.getUser(with: self.username)
      await MainActor.run {
        self.user = user
        self.viewState = .loaded(user)
      }
    } catch {
      await MainActor.run {
        self.viewState = .error(error)
      }
    }
  }
}
