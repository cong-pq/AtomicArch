import AtomicLogger
import Foundation
import Networking

struct AppConfig {
  let networkClient: NetworkServiceProtocol
  let logger: LoggerProtocol = {
    #if DEBUG
      return LoggerImpl(label: "GitHubUsers_UAT")
    #else
      return LoggerImpl(label: "GitHubUsers_PROD")
    #endif
  }()

  init() {
    let logginNetworkIntercetor = LoggingInterceptor(
      logger: logger
    )
    let interceptorChain = NetworkInterceptorChain(interceptors: [logginNetworkIntercetor])
    let configuration = NetworkService.Configuation(
      baseURL: Environment.baseURL,
      defaultHeaders: ["Content-Type": "application/json"]
    )
    self.networkClient = NetworkService(
      configuration: configuration,
      session: URLSession.shared,
      interceptorChain: interceptorChain,
      networkMonitor: NetworkMonitor()
    )
  }
}
