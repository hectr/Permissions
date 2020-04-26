import Foundation
import HealthKit

public struct HealthStoreShareAuthorizationSource: AuthorizationSource, AuthorizationStatusSource {
    public let subject: HKSampleType

    public var status: AuthorizationStatus<HKSampleType> {
        provider
            .authorizationStatus(for: subject)
            .toAuthorizationStatus(subject: subject)
    }

    private let provider = HKHealthStore()

    public init(subject: HKSampleType) {
        self.subject = subject
    }

    public func requestAuthorization(completion: @escaping (AuthorizationStatus<HKSampleType>) -> Void) {
        provider.requestAuthorization(toShare: Set(arrayLiteral: subject), read: nil) { _, _ in
            self.getStatus(completion: completion)
        }
    }
}
