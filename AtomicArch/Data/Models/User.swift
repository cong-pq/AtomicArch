import Foundation

struct UserResponse: Decodable {
  let id: Int
  let login: String?
  let avatarUrl: String?
  let htmlUrl: String?

  enum CodingKeys: String, CodingKey {
    case id
    case login
    case avatarUrl = "avatar_url"
    case htmlUrl = "html_url"
  }
}

extension UserResponse {
  func toDomain() -> UserEntity {
    UserEntity(
      id: UUID(),
      login: self.login ?? "",
      avatarUrl: self.avatarUrl ?? "",
      htmlUrl: self.htmlUrl ?? ""
    )
  }
}
