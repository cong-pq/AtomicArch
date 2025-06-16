import Logging

/// An enum that defines the possible log levels used to categorize log messages based on their severity.
///
/// Each level corresponds to a specific importance or priority of the log message.
public enum LogLevel {
  case trace // Detailed information, typically for debugging.
  case debug // Used for debugging, generally not shown in production.
  case info // Informational messages, typically about the application's general flow.
  case notice // Normal but significant events, such as configuration changes.
  case warning // Warnings that might indicate potential issues.
  case error // Errors that indicate a failure or problem requiring attention.
  case critical // Critical errors that indicate a major failure in the system.

  /// Converts the `LogLevel` to its corresponding `Logging.Logger.Level` in Swift's logging system.
  ///
  /// - Returns: A `Logging.Logger.Level` that corresponds to the `LogLevel` enum value.
  /// - Note: This allows you to map your custom log levels to the ones used by `Logging.Logger`.
  func toLoggingLevel() -> Logging.Logger.Level {
    switch self {
    case .trace:
      return .trace
    case .debug:
      return .debug
    case .info:
      return .info
    case .notice:
      return .notice
    case .warning:
      return .warning
    case .error:
      return .error
    case .critical:
      return .critical
    }
  }
}
