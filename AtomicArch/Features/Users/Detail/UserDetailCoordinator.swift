import AtomicCore
import UIKit

protocol UserDetailCoordinatorDelegate: AnyObject {
  func userDetailCoordinatorDidFinish(_ coordinator: UserDetailCoordinator)
}

final class UserDetailCoordinator: Coordinator, UserDetailViewControllerDelegate {
  // MARK: - Properties

  var children: [Coordinator] = []
  let router: Router
  private let user: UserEntity
  private let userUseCase: UserUseCase
  weak var delegate: UserDetailCoordinatorDelegate?

  // MARK: - Initialization

  init(router: Router, user: UserEntity, userUseCase: UserUseCase) {
    self.router = router
    self.user = user
    self.userUseCase = userUseCase
  }

  // MARK: - Coordinator

  func present(animated: Bool, onDismissed: (() -> Void)?) {
    let viewController = UserDetailViewControllerBuilder(userUseCase: userUseCase, user: user)
      .withDelegate(self)
      .build()

    self.router.present(viewController, animated: animated, onDismissed: { [weak self] in
      guard let self = self else { return }
      self.delegate?.userDetailCoordinatorDidFinish(self)
      onDismissed?()
    })
  }

  // MARK: - UserDetailViewControllerDelegate

  func userDetailViewControllerDidFinish(_: UserDetailViewController) {
    self.router.dismiss(animated: true)
  }
}
