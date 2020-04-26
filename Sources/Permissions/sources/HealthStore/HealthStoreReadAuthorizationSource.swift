import Foundation
import HealthKit

public struct HealthStoreReadAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: HKObjectType

    public var status: AuthorizationStatus<HKObjectType> {
        provider
            .authorizationStatus(for: subject)
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = HKHealthStore()

    public init(subject: HKObjectType) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<HKObjectType>) -> Void) {
        provider.requestAuthorization(toShare: nil, read: Set(arrayLiteral: subject)) { _, _ in
            self.getStatus(completion: completion)
        }
    }
}
