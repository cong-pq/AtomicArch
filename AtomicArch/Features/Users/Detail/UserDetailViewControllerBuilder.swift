final class UserDetailViewControllerBuilder: ViewControllerBuilder {
  private let userUseCase: UserUseCase
  private let user: UserEntity
  private var delegate: UserDetailViewControllerDelegate?

  init(userUseCase: UserUseCase, user: UserEntity) {
    self.userUseCase = userUseCase
    self.user = user
  }

  func withDelegate(_ delegate: UserDetailViewControllerDelegate) -> Self {
    self.delegate = delegate
    return self
  }

  func build() -> UserDetailViewController {
    let viewModel = UserDetailViewModel(userUseCase: userUseCase, username: user.login)
    let viewController = UserDetailViewController(viewModel: viewModel)
    viewController.delegate = self.delegate
    return viewController
  }
}
