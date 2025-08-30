final class ListUserViewControllerBuilder: ViewControllerBuilder {
  private let userUseCase: UserUseCase
  private var delegate: ListUserGitHubViewControllerDelegate?

  init(userUseCase: UserUseCase) {
    self.userUseCase = userUseCase
  }

  func withDelegate(_ delegate: ListUserGitHubViewControllerDelegate) -> Self {
    self.delegate = delegate
    return self
  }

  func build() -> ListUserGitHubViewController {
    let viewModel = ListUserGitHubViewModel(userUseCase: userUseCase)
    let viewController = ListUserGitHubViewController(viewModel: viewModel)
    viewController.delegate = self.delegate
    return viewController
  }
}
