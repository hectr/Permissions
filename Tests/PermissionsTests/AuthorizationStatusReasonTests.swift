import Foundation
import Permissions
import XCTest

final class AuthorizationStatusReasonTests: XCTestCase {
    var someDouble: Double!
    var someInt: Int!
    var someString: String!

    override func setUp() {
        super.setUp()
        someDouble = 0.1
        someInt = 99
        someString = "some string"
    }

    func testDenied() {
        let original = AuthorizationStatus<Void>.Reason.denied(Void())
        let expected = AuthorizationStatus<String?>.Reason.denied(someString)
        let replaced = original.replacingSubject(with: someString)
        XCTAssertEqual(replaced, expected)
    }

    func testMultiple() {
        let original = AuthorizationStatus<Double?>.Reason.multiple([.denied(someDouble)])
        let expected = AuthorizationStatus<String?>.Reason.multiple([.denied(someString)])
        let replaced = original.replacingSubject(with: someString)
        XCTAssertEqual(replaced, expected)
    }

    func testNotDetermined() {
        let original = AuthorizationStatus<String?>.Reason.notDetermined(someString)
        let expected = AuthorizationStatus<Int?>.Reason.notDetermined(someInt)
        let replaced = original.replacingSubject(with: someInt)
        XCTAssertEqual(replaced, expected)
    }

    func testRestricted() {
        let original = AuthorizationStatus<Int?>.Reason.restricted(someInt)
        let expected = AuthorizationStatus<String?>.Reason.restricted(someString)
        let replaced = original.replacingSubject(with: someString)
        XCTAssertEqual(replaced, expected)
    }
}
