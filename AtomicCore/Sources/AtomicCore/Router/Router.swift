import UIKit

public protocol Router: AnyObject {
  func present(
    _ viewController: UIViewController,
    animated: Bool
  )

  func present(
    _ viewController: UIViewController,
    animated: Bool,
    onDismissed: (() -> Void)?
  )

  func dismiss(animated: Bool)
}

public extension Router {
  func present(
    _ viewController: UIViewController,
    animated: Bool
  ) {
    self.present(
      viewController,
      animated: animated,
      onDismissed: nil
    )
  }
}
