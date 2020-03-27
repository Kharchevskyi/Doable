import XCTest
@testable import Signing

final class SigningTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Signing().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
