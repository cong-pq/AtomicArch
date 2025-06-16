import UIKit

/// A protocol that defines the basic structure of a view.
public protocol View: AnyObject {
  /// The view model associated with this view.
  associatedtype ViewModelType: ViewModel

  /// The view model instance.
  var viewModel: ViewModelType { get }

  /// Initializes the view with a view model.
  /// - Parameter viewModel: The view model to use.
  init(viewModel: ViewModelType)

  /// Sets up the view's UI components.
  func setupUI()

  /// Sets up the view's constraints.
  func setupConstraints()

  /// Binds the view to its view model.
  func bind()
}

public extension View {
  func setupUI() {
    // Default implementation does nothing
  }

  func setupConstraints() {
    // Default implementation does nothing
  }

  func bind() {
    // Default implementation does nothing
  }
}

/// A protocol that defines a view controller with a view model.
public protocol ViewControllerType: UIViewController {
  /// The view model associated with this view controller.
  associatedtype ViewModelType: ViewModel

  /// The view model instance.
  var viewModel: ViewModelType { get }

  /// Initializes the view controller with a view model.
  /// - Parameter viewModel: The view model to use.
  init(viewModel: ViewModelType)
}
