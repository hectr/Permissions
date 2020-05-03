import Foundation

public protocol AuthorizationSource {
    associatedtype Subject
    var operationQueue: OperationQueue { get }
    var subject: Subject { get }
    func determineAuthorizationStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void)
    func getStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void)
    func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void)
}

extension AuthorizationSource {
    public var operationQueue: OperationQueue {
        OperationQueue.main
    }

    public func determineAuthorizationStatus(completion: @escaping (AuthorizationStatus<Subject>) -> Void) {
        getStatus { status in
            switch status {
            case .authorized:
                completion(status)

            case let .unauthorized(reason):
                if reason.canRequestPermission {
                    self.requestAuthorization(timeout: nil) { _ in 
                        self.getStatus(completion: completion)
                    }
                } else {
                    completion(status)
                }
            }
        }
    }
}

