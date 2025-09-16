import Foundation
import Network

public enum ConnectionType {
  case wifi, cellular, ethernet, other, none
}

public protocol NetworkMonitoring {
  var isConnected: Bool { get }
  var connectionType: ConnectionType { get }
  var onConnectionChange: ((ConnectionType) -> Void)? { get set }
}

@available(iOS 12.0, macOS 10.14, *)
public protocol PathMonitoring {
  var pathUpdateHandler: (@Sendable (NWPath) -> Void)? { get set }
  func start(queue: DispatchQueue)
  func cancel()
}

@available(iOS 12.0, macOS 10.14, *)
extension NWPathMonitor: PathMonitoring {}

@available(iOS 12.0, macOS 10.14, *)
public final class NetworkMonitor: NetworkMonitoring {
  private var monitor: PathMonitoring
  private let queue: DispatchQueue

  public private(set) var isConnected: Bool = false
  public private(set) var connectionType: ConnectionType = .none
  public var onConnectionChange: ((ConnectionType) -> Void)?

  public init(monitor: PathMonitoring = NWPathMonitor(), queue: DispatchQueue = DispatchQueue.global(qos: .background)) {
    self.queue = queue
    self.monitor = monitor
    self.setupMonitor()
  }

  private func setupMonitor() {
    self.monitor.pathUpdateHandler = { [weak self] path in
      self?.handlePathUpdate(path)
    }
    self.monitor.start(queue: self.queue)
  }

  private func handlePathUpdate(_ path: NWPath) {
    self.isConnected = path.status == .satisfied

    let newConnectionType: ConnectionType = if path.usesInterfaceType(.wifi) {
      .wifi
    } else if path.usesInterfaceType(.cellular) {
      .cellular
    } else if path.usesInterfaceType(.wiredEthernet) {
      .ethernet
    } else if path.status == .satisfied {
      .other
    } else {
      .none
    }

    if newConnectionType != self.connectionType {
      self.connectionType = newConnectionType
      self.onConnectionChange?(newConnectionType)
    }
  }

  deinit {
    monitor.cancel()
  }
}
