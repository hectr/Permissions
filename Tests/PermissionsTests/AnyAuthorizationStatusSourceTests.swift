import Foundation
import Permissions
import XCTest

final class AnyAuthorizationStatusSourceTests: XCTestCase {
    var source: SomeAuthorizationStatusSource!
    var typeErased: AnyAuthorizationStatusSource<Int>!
    var expectation: XCTestExpectation!

    struct SomeAuthorizationStatusSource: AuthorizationStatusSource {
        var status: AuthorizationStatus<Int>
        typealias Subject = Int
        var subject: Int = 1234
    }

    override func setUp() {
        super.setUp()
        source = SomeAuthorizationStatusSource(status: AuthorizationStatus<Int>.authorized(1234))
        typeErased = AnyAuthorizationStatusSource(source)
    }

    func test() {
        XCTAssertEqual(source.status, typeErased.status)
        XCTAssertEqual(source.subject, typeErased.subject)
    }
}
