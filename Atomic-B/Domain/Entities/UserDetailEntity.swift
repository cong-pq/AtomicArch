import Foundation

struct UserDetailEntity: Identifiable, Equatable {
  let id: Int
  let login: String
  let avatarUrl: String
  let htmlUrl: String
  let name: String
  let company: String
  let blog: String
  let location: String
  let email: String
  let bio: String
  let publicRepos: Int
  let publicGists: Int
  let followers: Int
  let following: Int
}
