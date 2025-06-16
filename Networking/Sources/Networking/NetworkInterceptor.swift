import Foundation

public protocol NetworkInterceptor {
  func intercept(request: inout URLRequest)
  func intercept(response: URLResponse?, data: Data?, error: Error?)
}
