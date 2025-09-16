import AtomicLogger
import Foundation
import Networking

final class LoggingInterceptor: NetworkInterceptor {
  private let logger: LoggerProtocol

  init(logger: LoggerProtocol) {
    self.logger = logger
  }

  func intercept(request: inout URLRequest) {
    self.logger.log(level: .info, message: request.logMessage())
  }

  func intercept(response: URLResponse?, data: Data?, error: (any Error)?) {
    if let httpResponse = response as? HTTPURLResponse {
      self.logger.log(data: data, response: httpResponse, error: error)
    }
  }
}
