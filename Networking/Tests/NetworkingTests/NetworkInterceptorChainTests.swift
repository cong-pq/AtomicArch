@testable import Networking
import XCTest

final class NetworkInterceptorChainTests: XCTestCase {
  // MARK: - Properties

  private var sut: NetworkInterceptorChain!
  private var mockInterceptors: [MockInterceptor]!

  // MARK: - Setup & Teardown

  override func setUp() {
    super.setUp()
    self.mockInterceptors = [
      MockInterceptor(),
      MockInterceptor(),
      MockInterceptor()
    ]
    self.sut = NetworkInterceptorChain(interceptors: self.mockInterceptors)
  }

  override func tearDown() {
    self.sut = nil
    self.mockInterceptors = nil
    super.tearDown()
  }

  // MARK: - Request Interception Tests

  func test_interceptRequest_callsAllInterceptorsInOrder() {
    // given
    var request = URLRequest(url: URL(string: "https://example.com")!)

    // when
    self.sut.interceptRequest(&request)

    // then
    for (index, interceptor) in self.mockInterceptors.enumerated() {
      XCTAssertTrue(interceptor.didInterceptRequest, "Interceptor \(index) should intercept request")
      XCTAssertEqual(interceptor.interceptionOrder, index, "Interceptor \(index) should be called in order")
    }
  }

  func test_interceptRequest_passesModifiedRequestToNextInterceptor() {
    // given
    var request = URLRequest(url: URL(string: "https://example.com")!)
    self.mockInterceptors[0].requestModifier = { request in
      request.addValue("test", forHTTPHeaderField: "Custom")
    }

    // when
    self.sut.interceptRequest(&request)

    // then
    XCTAssertEqual(request.value(forHTTPHeaderField: "Custom"), "test")
  }

  // MARK: - Response Interception Tests

  func test_interceptResponse_callsAllInterceptorsInOrder() {
    // given
    let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    let data = "test".data(using: .utf8)

    // when
    self.sut.interceptResponse(response: response, data: data, error: nil)

    // then
    for (index, interceptor) in self.mockInterceptors.enumerated() {
      XCTAssertTrue(interceptor.didInterceptResponse, "Interceptor \(index) should intercept response")
      XCTAssertEqual(interceptor.interceptionOrder, index, "Interceptor \(index) should be called in order")
    }
  }

  func test_interceptResponse_passesErrorToAllInterceptors() {
    // given
    let error = NetworkError.invalidResponse

    // when
    self.sut.interceptResponse(response: nil, data: nil, error: error)

    // then
    for interceptor in self.mockInterceptors {
      XCTAssertEqual(interceptor.lastError as? NetworkError, error)
    }
  }
}

// MARK: - Mock Interceptor

private class MockInterceptor: NetworkInterceptor {
  var didInterceptRequest = false
  var didInterceptResponse = false
  var interceptionOrder = -1
  var lastError: Error?
  var requestModifier: ((inout URLRequest) -> Void)?

  func intercept(request _: inout URLRequest) {
    self.didInterceptRequest = true
  }

  func intercept(response _: URLResponse?, data _: Data?, error _: Error?) {
    self.didInterceptResponse = true
  }
}
