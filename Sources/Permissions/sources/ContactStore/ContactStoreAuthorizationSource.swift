import Contacts
import Foundation

@available(iOS 9.0, *)
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

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<CNEntityType>) -> Void) {
        provider.requestAccess(for: subject) { _, _ in
            self.getStatus(completion: completion)
        }
    }
}
