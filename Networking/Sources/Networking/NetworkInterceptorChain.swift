import Foundation

public class NetworkInterceptorChain {
  private var interceptors: [NetworkInterceptor] = []

  public init(interceptors: [NetworkInterceptor]) {
    self.interceptors = interceptors
  }

  public func addInterceptor(_ interceptor: NetworkInterceptor) {
    self.interceptors.append(interceptor)
  }

  func interceptRequest(_ request: inout URLRequest) {
    for interceptor in self.interceptors {
      interceptor.intercept(request: &request)
    }
  }

  func interceptResponse(response: URLResponse?, data: Data?, error: Error?) {
    for interceptor in self.interceptors {
      interceptor.intercept(response: response, data: data, error: error)
    }
  }
}
