import Foundation
import Permissions
import XCTest

final class ExpirableCompletionTests: XCTestCase {
    func testExecute() {
        let expectation = XCTestExpectation()
        let completion = ExpirableCompletion<Void>(timeout: 0.001, operationQueue: .main) { (result) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        completion.execute(with: Result.success(Void()))
        wait(for: [expectation], timeout: 0.01)
        completion.execute(with: Result.failure(NSError(domain: #function, code: #line, userInfo: nil)))
    }
    
    func testExpiration() {
        let expectation = XCTestExpectation()
        let completion = ExpirableCompletion<Void>(timeout: 0.001, operationQueue: .main) { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.01)
        completion.execute(with: Result.success(Void()))
    }
}
