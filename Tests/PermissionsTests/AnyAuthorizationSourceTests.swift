import Foundation
import Permissions
import XCTest

final class AnyAuthorizationSourceTests: XCTestCase {
    var source: SomeAuthorizationSource!
    var typeErased: AnyAuthorizationSource<Int>!
    var expectation: XCTestExpectation!

    final class SomeAuthorizationSource: AuthorizationSource {
        typealias Subject = Int

        var subject: Int = 1234

        fileprivate var getStatusStatus: AuthorizationStatus<Int>!
        fileprivate var requestAuthorizationStatus: AuthorizationStatus<Int>!

        fileprivate var getStatusCalled = false
        fileprivate var requestAuthorizationCalled = false

        func getStatus(completion: @escaping (AuthorizationStatus<Int>) -> Void) {
            self.getStatusCalled = true
            completion(self.getStatusStatus)
        }

        func requestAuthorization(completion: @escaping (AuthorizationStatus<Int>) -> Void) {
            self.requestAuthorizationCalled = true
            completion(self.requestAuthorizationStatus)
        }
    }

    override func setUp() {
        super.setUp()
        source = SomeAuthorizationSource()
        typeErased = AnyAuthorizationSource(source)
        expectation = XCTestExpectation()
    }

    func testDetermineUnauthorized() {
        source.getStatusStatus = .unauthorized(.multiple([]))
        source.requestAuthorizationStatus = .authorized(0)
        typeErased.determineAuthorizationStatus { status in
            XCTAssertEqual(status, self.source.getStatusStatus)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.0)
        XCTAssertTrue(source.getStatusCalled)
        XCTAssertFalse(source.requestAuthorizationCalled)
    }

    func testDetermineAuthorized() {
        source.getStatusStatus = .authorized(0)
        source.requestAuthorizationStatus = .unauthorized(.multiple([]))
        typeErased.determineAuthorizationStatus { status in
            XCTAssertEqual(status, self.source.getStatusStatus)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.0)
        XCTAssertTrue(source.getStatusCalled)
        XCTAssertFalse(source.requestAuthorizationCalled)
    }

    func testDetermineNotDetermined() {
        source.getStatusStatus = .unauthorized(.notDetermined(0))
        source.requestAuthorizationStatus = .authorized(1)
        typeErased.determineAuthorizationStatus { status in
            XCTAssertEqual(status, self.source.requestAuthorizationStatus)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.0)
        XCTAssertTrue(source.getStatusCalled)
        XCTAssertTrue(source.requestAuthorizationCalled)
    }
}
