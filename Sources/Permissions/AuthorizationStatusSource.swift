import Foundation

public protocol AuthorizationStatusSource {
    associatedtype Subject
    var subject: Subject { get }
    var status: AuthorizationStatus<Subject> { get }
}

extension AuthorizationStatusSource where Self: AuthorizationSource {
    public func getStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        operationQueue.addOperation {
            completion(self.status)
        }
    }
}
