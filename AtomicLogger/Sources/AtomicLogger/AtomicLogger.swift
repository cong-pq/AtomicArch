import Foundation
import Logging

/// A protocol that defines the behavior for logging messages with different levels.
/// Any logger implementation should conform to this protocol to allow flexible logging strategies.
public protocol LoggerProtocol {
  /// Logs a message at a specific logging level.
  ///
  /// - Parameters:
  ///   - level: The logging level (e.g., `.info`, `.error`) that categorizes the importance of the log message.
  ///   - message: A closure that returns the message to log. Using `@autoclosure` ensures the message is lazily evaluated.
  /// - Note: This method allows for conditional logging, where messages are only evaluated when the appropriate logging level is enabled.
  func log(
    level: LogLevel,
    message: @autoclosure () -> String
  )
}

/// A concrete implementation of the `Logger` protocol that utilizes the `Logging.Logger` from Swift's logging package.
/// This implementation writes logs to the configured logging system based on the specified log level.
///
/// - Uses `Logging.Logger` under the hood to actually perform the logging operations.
public struct LoggerImpl: LoggerProtocol {
  /// The actual logger used for logging messages.
  private let logger: Logging.Logger

  /// Initializes the logger with a specific label, which typically represents the source of the log (e.g., module name).
  ///
  /// - Parameter label: A string used to identify the source or module that generates the logs.
  public init(label: String) {
    self.logger = Logging.Logger(label: label)
  }

  /// Logs a message with a specific log level.
  ///
  /// - Parameters:
  ///   - level: The log level that determines the severity or category of the log (e.g., `.info`, `.warning`).
  ///   - message: A closure that returns the string message to be logged. The closure is evaluated lazily to avoid unnecessary computation when the log level is not enabled.
  public func log(level: LogLevel, message: @autoclosure () -> String) {
    self.logger.log(
      level: level.toLoggingLevel(),
      .init(stringLiteral: message())
    )
  }
}

/// A no-op (no operation) implementation of the `Logger` protocol that discards any log messages.
/// This is typically used in production builds or when logging is disabled to avoid unnecessary computation.
///
/// - This implementation is used when you need to disable logging or don't want any logs to be recorded.
public struct NoLogger: LoggerProtocol {
  /// The actual logger used for logging messages (not used in `NoLogger`, but kept for initialization consistency).
  private let logger: Logging.Logger

  /// Initializes the logger with a specific label. In `NoLogger`, this doesn't affect functionality as no logging is done.
  ///
  /// - Parameter label: A string used to identify the source or module that generates the logs (not used in `NoLogger`).
  public init(label: String) {
    self.logger = Logging.Logger(label: label)
  }

  /// A no-op implementation of the `log` method. It does not perform any logging.
  ///
  /// - Parameters:
  ///   - level: The log level (e.g., `.info`, `.error`). This is ignored by `NoLogger`.
  ///   - message: A closure that returns the message to log. This is ignored by `NoLogger`.
  public func log(level _: LogLevel, message _: @autoclosure () -> String) {
    // No operation - no logging happens here.
  }
}
