import Foundation
import Permissions
import XCTest

final class AuthorizationStatusTests: XCTestCase {
    var someInt: Int!
    var someString: String!

    override func setUp() {
        super.setUp()
        someInt = 99
        someString = "some string"
    }

    func testAuthorized() {
        let original = AuthorizationStatus<Void>.authorized(Void())
        let expected = AuthorizationStatus<String?>.authorized(someString)
        let replaced = original.replacingSubject(with: someString)
        XCTAssertEqual(replaced, expected)
    }

    func testUnauthorized() {
        let original = AuthorizationStatus<Double?>.unauthorized(.multiple([]))
        let expected = AuthorizationStatus<String?>.unauthorized(.multiple([]))
        let replaced = original.replacingSubject(with: someString)
        XCTAssertEqual(replaced, expected)
    }
}
