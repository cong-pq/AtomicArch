import Foundation

public struct UserDetailResponse: Decodable {
  public let id: Int
  public let login: String?
  public let avatarUrl: String?
  public let htmlUrl: String?
  public let name: String?
  public let company: String?
  public let blog: String?
  public let location: String?
  public let email: String?
  public let bio: String?
  public let publicRepos: Int?
  public let publicGists: Int?
  public let followers: Int?
  public let following: Int?

  enum CodingKeys: String, CodingKey {
    case id
    case login
    case avatarUrl = "avatar_url"
    case htmlUrl = "html_url"
    case name
    case company
    case blog
    case location
    case email
    case bio
    case publicRepos = "public_repos"
    case publicGists = "public_gists"
    case followers
    case following
  }
}

extension UserDetailResponse {
  func toDomain() -> UserDetailEntity {
    return UserDetailEntity(
      id: self.id,
      login: self.login ?? "",
      avatarUrl: self.avatarUrl ?? "",
      htmlUrl: self.htmlUrl ?? "",
      name: self.name ?? "",
      company: self.company ?? "",
      blog: self.blog ?? "",
      location: self.location ?? "",
      email: self.email ?? "",
      bio: self.bio ?? "",
      publicRepos: self.publicRepos ?? 0,
      publicGists: self.publicGists ?? 0,
      followers: self.followers ?? 0,
      following: self.following ?? 0
    )
  }
}
