import AtomicCore
import UIKit

protocol ListUserGitHubCoordinatorDelegate: AnyObject {
  func listUserGitHubCoordinatorDidFinish(_ coordinator: ListUserGitHubCoordinator)
}

final class ListUserGitHubCoordinator: Coordinator {
  // MARK: - Properties

  var children: [Coordinator] = []
  let router: Router
  private let userUseCase: UserUseCase
  weak var delegate: ListUserGitHubCoordinatorDelegate?

  // MARK: - Initialization

  init(router: Router, userUseCase: UserUseCase) {
    self.router = router
    self.userUseCase = userUseCase
  }

  // MARK: - Coordinator

  func present(animated: Bool, onDismissed: (() -> Void)?) {
    let viewController = ListUserViewControllerBuilder(userUseCase: userUseCase)
      .withDelegate(self)
      .build()
    self.router.present(viewController, animated: animated, onDismissed: onDismissed)
  }
}

// MARK: - ListUserGitHubViewControllerDelegate

extension ListUserGitHubCoordinator: ListUserGitHubViewControllerDelegate {
  func didSelectUser(_ user: UserEntity) {
    let coordinator = UserDetailCoordinator(router: router, user: user, userUseCase: userUseCase)
    presentChild(coordinator, animated: true)
  }
}
