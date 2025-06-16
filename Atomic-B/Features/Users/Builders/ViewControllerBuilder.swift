import AtomicCore
import UIKit

protocol ViewControllerBuilder {
  associatedtype ViewController
  func build() -> ViewController
}
