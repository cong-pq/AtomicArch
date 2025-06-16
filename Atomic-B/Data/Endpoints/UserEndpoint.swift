import Foundation
import Networking

enum UserEndpoint {
  case getListUser(Int, Int)
  case getUserDetail(String)
}

extension UserEndpoint: Target {
  public var path: String {
    switch self {
    case .getListUser:
      "/users"
    case let .getUserDetail(loginUserName):
      "/users/\(loginUserName)"
    }
  }

  public var method: Networking.HTTPMethod {
    .get
  }

  public var task: Networking.Task {
    switch self {
    case let .getListUser(perPage, since):
      return .requestParameters(
        parameters: [
          "per_page": "\(perPage)",
          "since": "\(since)"
        ]
      )
    case .getUserDetail:
      return .requestPlain
    }
  }

  public var headers: [String: String] {
    [:]
  }
}
