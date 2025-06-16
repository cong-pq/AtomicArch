import Combine
import Foundation

/// A protocol that defines the basic structure of a view model.
public protocol ViewModel: AnyObject {
  /// The cancellables used for managing subscriptions.
  var cancellables: Set<AnyCancellable> { get set }

  /// Binds the view model to its view.
  func bind()
}

public extension ViewModel {
  func bind() {
    // Default implementation does nothing
  }
}

/// A protocol that defines a view model with input and output.
public protocol ViewModelType {
  /// The input type for the view model.
  associatedtype Input

  /// The output type for the view model.
  associatedtype Output

  /// Transforms the input into output.
  /// - Parameter input: The input to transform.
  /// - Returns: The transformed output.
  func transform(input: Input) -> Output
}
