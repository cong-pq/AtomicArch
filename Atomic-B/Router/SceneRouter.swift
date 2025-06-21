import AtomicCore
import UIKit

final class SceneRouter: NavigationRouter {
  // MARK: - Instance Properties

  let window: UIWindow

  // MARK: - Object Lifecycle

  init(window: UIWindow) {
    let navigationController = UINavigationController()
    self.window = window
    super.init(navigationController: navigationController)
    self.window.rootViewController = navigationController
    self.window.makeKeyAndVisible()
  }

  // MARK: - Router

  override func present(
    _ viewController: UIViewController,
    animated: Bool,
    onDismissed: (() -> Void)?
  ) {
    super.present(viewController, animated: animated, onDismissed: onDismissed)
  }
}
