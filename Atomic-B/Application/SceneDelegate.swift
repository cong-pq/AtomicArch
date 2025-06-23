import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private lazy var config = AppConfig()
  private var coordinator: ListUserGitHubCoordinator?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)
    self.window = window

    let router = SceneRouter(window: window)
    let userService = UserRepositoryImpl(networkService: config.networkClient)
    let userUseCase = UserUseCaseImpl(repository: userService)
    self.coordinator = ListUserGitHubCoordinator(router: router, userUseCase: userUseCase)

    self.coordinator?.present(animated: true, onDismissed: nil)
  }
}
