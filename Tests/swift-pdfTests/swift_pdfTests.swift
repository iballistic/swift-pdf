import XCTest
@testable import swift_pdf

final class swift_pdfTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_pdf().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
