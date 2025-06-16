import Foundation

public protocol Target {
  var path: String { get }
  var method: HTTPMethod { get }
  var task: Task { get }
  var headers: [String: String] { get }
}

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}

public enum Task {
  case requestPlain
  case requestParameters(parameters: [String: Any])
  case requestBody(Data)
  case requestJSONEncodable(Encodable)
  case requestCompositeBody(parameters: [String: Any], body: Data)
}
