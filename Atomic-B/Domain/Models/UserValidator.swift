import Foundation

enum UserValidator {
  static func validateUsername(_ username: String) throws {
    // GitHub usernames must be between 1 and 39 characters
    // and can only contain alphanumeric characters and hyphens
    let pattern = "^[a-zA-Z0-9-]{1,39}$"
    let regex = try NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: username.utf16.count)

    guard regex.firstMatch(in: username, range: range) != nil else {
      throw DomainError.invalidUsername
    }
  }

  static func validatePaginationParameters(perPage: Int, since: Int) throws {
    guard perPage > 0, since >= 0 else {
      throw DomainError.invalidPaginationParameters
    }
  }

  static func validateUser(_ user: UserEntity) throws {
    try self.validateUsername(user.login)

    // Validate URLs
    guard
      URL(string: user.avatarUrl) != nil,
      URL(string: user.htmlUrl) != nil
    else {
      throw DomainError.invalidUserData
    }
  }

  static func validateUserDetail(_ user: UserDetailEntity) throws {
    try self.validateUsername(user.login)

    // Validate URLs
    guard
      URL(string: user.avatarUrl) != nil,
      URL(string: user.htmlUrl) != nil,
      user.blog.isEmpty || URL(string: user.blog) != nil
    else {
      throw DomainError.invalidUserData
    }

    // Validate email if present
    if !user.email.isEmpty {
      let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
      let emailRegex = try NSRegularExpression(pattern: emailPattern)
      let range = NSRange(location: 0, length: user.email.utf16.count)

      guard emailRegex.firstMatch(in: user.email, range: range) != nil else {
        throw DomainError.invalidUserData
      }
    }
  }
}
