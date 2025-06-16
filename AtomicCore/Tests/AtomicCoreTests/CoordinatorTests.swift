@testable import AtomicCore
import XCTest

final class CoordinatorTests: XCTestCase {
  // MARK: - Test Router

  private final class MockRouter: Router {
    var presentedViewController: UIViewController?
    var presentedAnimated: Bool?
    var onDismissedCalled = false

    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
      self.presentedViewController = viewController
      self.presentedAnimated = animated
      onDismissed?()
      self.onDismissedCalled = true
    }
  }

  // MARK: - Test ViewController

  private final class TestViewController: UIViewController {}

  // MARK: - Test Coordinator

  private final class TestCoordinator: BaseCoordinator {
    private let viewController: TestViewController

    init(router: Router) {
      self.viewController = TestViewController()
      super.init(router: router)
    }

    override func present(animated: Bool, onDismissed: (() -> Void)?) {
      router.present(self.viewController, animated: animated, onDismissed: onDismissed)
    }
  }

  // MARK: - Properties

  private var sut: TestCoordinator!
  private var router: MockRouter!

  // MARK: - Setup

  override func setUp() {
    super.setUp()
    self.router = MockRouter()
    self.sut = TestCoordinator(router: self.router)
  }

  override func tearDown() {
    self.sut = nil
    self.router = nil
    super.tearDown()
  }

  // MARK: - Tests

  func test_init_setsRouter() {
    // Then
    XCTAssertNotNil(self.sut.router)
    XCTAssertEqual(self.sut.router as? MockRouter, self.router)
  }

  func test_present_presentsViewController() {
    // When
    self.sut.present(animated: true, onDismissed: nil)

    // Then
    XCTAssertNotNil(self.router.presentedViewController)
    XCTAssertTrue(self.router.presentedViewController is TestViewController)
    XCTAssertEqual(self.router.presentedAnimated, true)
  }

  func test_present_callsOnDismissed() {
    // When
    self.sut.present(animated: true) {
      // Then
      XCTAssertTrue(self.router.onDismissedCalled)
    }
  }
}
