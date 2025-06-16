/// @mockable
protocol UserUseCase {
  func getListUser(perPage: Int, since: Int) async throws -> [UserEntity]
  func getUser(with loginUsername: String) async throws -> UserDetailEntity
}
