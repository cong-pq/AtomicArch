import Foundation
import Networking

enum UserEndpoint {
  case getListUser(Int, Int)
  case getUserDetail(String)
}

extension UserEndpoint: Target {
  var path: String {
    switch self {
    case .getListUser:
      "/users"
    case let .getUserDetail(loginUserName):
      "/users/\(loginUserName)"
    }
  }

  var method: Networking.HTTPMethod {
    .get
  }

  var task: Networking.Task {
    switch self {
    case let .getListUser(perPage, since):
      .requestParameters(
        parameters: [
          "per_page": "\(perPage)",
          "since": "\(since)"
        ]
      )
    case .getUserDetail:
      .requestPlain
    }
  }

  var headers: [String: String] {
    [:]
  }
}
