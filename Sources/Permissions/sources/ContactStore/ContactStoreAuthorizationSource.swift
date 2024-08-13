#if canImport(Contacts)
import Contacts
import Foundation

public struct ContactStoreAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: CNEntityType

    public var status: AuthorizationStatus<CNEntityType> {
        type(of: provider)
            .authorizationStatus(for: subject)
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = CNContactStore()

    public init(subject: CNEntityType) {
        self.subject = subject
    }

    public func requestAuthorization(timeout: TimeInterval?, handler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let completion = ExpirableCompletion(timeout: timeout, operationQueue: operationQueue, completion: handler)
        provider.requestAccess(for: subject) { _, error in
            completion.execute(with: error)
        }
    }
}
#endif
