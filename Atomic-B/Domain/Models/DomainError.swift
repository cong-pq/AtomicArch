import Foundation

enum DomainError: LocalizedError {
  case invalidUsername
  case invalidPaginationParameters
  case userNotFound
  case invalidUserData

  var errorDescription: String? {
    switch self {
    case .invalidUsername:
      return "Username must be between 1 and 39 characters and contain only alphanumeric characters and hyphens"
    case .invalidPaginationParameters:
      return "Pagination parameters must be positive numbers"
    case .userNotFound:
      return "User not found"
    case .invalidUserData:
      return "Invalid user data"
    }
  }
}
