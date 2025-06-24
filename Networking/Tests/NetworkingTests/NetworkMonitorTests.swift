import Network
@testable import Networking
import XCTest

@available(iOS 12.0, macOS 10.14, *)
final class NetworkMonitorTests: XCTestCase {
  // MARK: - Properties

  private var sut: NetworkMonitor!
  private var monitor: NWPathMonitor!
  private var queue: DispatchQueue!

  // MARK: - Setup & Teardown

  override func setUp() {
    super.setUp()
    self.queue = DispatchQueue(label: "test.queue")
    self.monitor = NWPathMonitor()
    self.sut = NetworkMonitor(monitor: self.monitor, queue: self.queue)
  }

  override func tearDown() {
    self.sut = nil
    self.monitor = nil
    self.queue = nil
    super.tearDown()
  }

  // MARK: - Connection Status Tests

  func test_isConnected_whenPathIsSatisfied_returnsTrue() {
    // given
    let expectation = expectation(description: "Path update")
    var isConnected = false

    self.sut.onConnectionChange = { _ in
      isConnected = self.sut.isConnected
      expectation.fulfill()
    }

    // when
    self.monitor.start(queue: self.queue)

    // then
    waitForExpectations(timeout: 1)
    XCTAssertTrue(isConnected)
  }

//  func test_isConnected_whenPathIsNotSatisfied_returnsFalse() {
//    // given
//    let expectation = expectation(description: "Path update")
//    var isConnected = true
//
//    self.sut.onConnectionChange = { _ in
//      isConnected = self.sut.isConnected
//      expectation.fulfill()
//    }
//
//    // when
//    self.monitor.cancel()
//
//    // then
//    waitForExpectations(timeout: 1)
//    XCTAssertFalse(isConnected)
//  }

  // MARK: - Connection Type Tests

  func test_connectionType_whenPathIsWifi_returnsWifi() {
    // given
    let expectation = expectation(description: "Path update")
    var connectionType: ConnectionType?

    self.sut.onConnectionChange = { type in
      connectionType = type
      expectation.fulfill()
    }

    // when
    self.monitor.start(queue: self.queue)

    // then
    waitForExpectations(timeout: 1)
    XCTAssertEqual(connectionType, .wifi)
  }

//  func test_connectionType_whenPathIsCellular_returnsCellular() {
//    // given
//    let expectation = expectation(description: "Path update")
//    var connectionType: ConnectionType?
//
//    self.sut.onConnectionChange = { type in
//      connectionType = type
//      expectation.fulfill()
//    }
//
//    // when
//    self.monitor.start(queue: self.queue)
//
//    // then
//    waitForExpectations(timeout: 1)
//    XCTAssertEqual(connectionType, .cellular)
//  }

//  func test_connectionType_whenPathIsEthernet_returnsEthernet() {
//    // given
//    let expectation = expectation(description: "Path update")
//    var connectionType: ConnectionType?
//
//    self.sut.onConnectionChange = { type in
//      connectionType = type
//      expectation.fulfill()
//    }
//
//    // when
//    self.monitor.start(queue: self.queue)
//
//    // then
//    waitForExpectations(timeout: 1)
//    XCTAssertEqual(connectionType, .ethernet)
//  }

//  func test_connectionType_whenPathIsOther_returnsOther() {
//    // given
//    let expectation = expectation(description: "Path update")
//    var connectionType: ConnectionType?
//
//    self.sut.onConnectionChange = { type in
//      connectionType = type
//      expectation.fulfill()
//    }
//
//    // when
//    self.monitor.start(queue: self.queue)
//
//    // then
//    waitForExpectations(timeout: 1)
//    XCTAssertEqual(connectionType, .other)
//  }

//  func test_connectionType_whenPathIsNotSatisfied_returnsNone() {
//    // given
//    let expectation = expectation(description: "Path update")
//    var connectionType: ConnectionType?
//
//    self.sut.onConnectionChange = { type in
//      connectionType = type
//      expectation.fulfill()
//    }
//
//    // when
//    self.monitor.cancel()
//
//    // then
//    waitForExpectations(timeout: 1)
//    XCTAssertEqual(connectionType, Optional.none)
//  }
}
