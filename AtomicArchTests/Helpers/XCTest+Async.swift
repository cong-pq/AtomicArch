import XCTest

func XCTAssertThrowsErrorAsync(
  _ expression: @autoclosure @escaping () async throws -> some Any,
  _: @autoclosure () -> String = "",
  file: StaticString = #file,
  line: UInt = #line,
  _ errorHandler: (Error) -> Void = { _ in }
) async {
  do {
    _ = try await expression()
    XCTFail("Expected error but got success", file: file, line: line)
  } catch {
    errorHandler(error)
  }
}
