import XCTest
@testable import Doable

final class DoableTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Doable().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
